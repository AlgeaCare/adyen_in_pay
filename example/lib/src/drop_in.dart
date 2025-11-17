import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:adyen_in_pay_example/src/app_env.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';

class DropInWidget extends StatefulWidget {
  const DropInWidget({super.key});

  @override
  State<DropInWidget> createState() => _DropInWidgetState();
}

class _DropInWidgetState extends State<DropInWidget> {
  final ValueNotifier<int?> amount = ValueNotifier(null);
  ValueNotifier<String?> reference = ValueNotifier(null);
  ValueNotifier<String?> baseURLNotifier = ValueNotifier(null);
  ValueNotifier<PaymentInformation?> paymentInformation = ValueNotifier(null);
  ValueNotifier<ConfigurationStatus?> configurationStatus = ValueNotifier(null);
  AdyenClient? client;
  late final listenable =
      Listenable.merge([amount, reference, configurationStatus, paymentInformation]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: OverflowBar(
            overflowSpacing: 16,
            children: [
              ExpansionTile(
                title: const Text('Configuration'),
                children: [
                  ConfigurationInputWidget(
                    onConfigurationSaved: (baseURL, token, invoiceID) async {
                      baseURLNotifier.value = baseURL;
                      client = AdyenClient(baseUrl: baseURL, interceptors: [
                        InterceptorsWrapper(
                          onRequest: (options, handler) {
                            options.headers['Authorization'] = 'Bearer $token';
                            handler.next(options);
                          },
                        )
                      ]);
                      reference.value = invoiceID;
                      paymentInformation.value = await showDialog<PaymentInformation>(
                        context: context,
                        builder: (context) {
                          return LoadInformation(
                            client: client!,
                            invoiceID: invoiceID,
                            onResult: (data) {
                              Navigator.pop(context, data);
                            },
                          );
                        },
                      );
                      if (paymentInformation.value != null) {
                        amount.value = paymentInformation.value!.amountDue;
                      }
                    },
                  ),
                ],
              ),
              AnimatedBuilder(
                animation: listenable,
                builder: (context, child) {
                  if (paymentInformation.value == null) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.0),
                        1: FlexColumnWidth(1.0),
                      },
                      children: [
                        TableRow(
                          children: [
                            const Text('firstName'),
                            Text(paymentInformation.value!.firstName),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text('lastName'),
                            Text(paymentInformation.value!.lastName),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text('email'),
                            Text(paymentInformation.value!.email),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text('status'),
                            Text(paymentInformation.value!.paymentStatus.toString()),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: listenable,
                builder: (context, child) {
                  return TextButton(
                    onPressed: !isDone(paymentInformation.value?.paymentStatus) &&
                            amount.value != null &&
                            reference.value != null &&
                            configurationStatus.value != ConfigurationStatus.started
                        ? () async {
                            final information =
                                await client!.paymentInformation(invoiceId: reference.value!);
                            if (!context.mounted) {
                              return;
                            }
                            final returnURL = switch (defaultTargetPlatform) {
                              TargetPlatform.android =>
                                'adyencheckout://com.example.adyen_in_pay_example',
                              TargetPlatform.iOS =>
                                'com.mydomain.adyencheckout://com.example.adyenExample',
                              _ =>
                                'https://app.staging.bloomwell.de/payment_status?merchantReference=${reference.value}',
                            };
                            DropInPlatform.dropInAdvancedFlowPlatform(
                              context: context,
                              webURL:
                                  'https://api.payments.${baseURLNotifier.value!.contains('dev') ? 'dev' : 'staging'}.bloomwell.de/pay/$reference',
                              client: client!,
                              paymentInformation: information,
                              reference: reference.value!,
                              acceptOnlyCard: false,
                              configuration: AdyenConfiguration(
                                amount: amount.value!,
                                adyenKeysConfiguration: AdyenKeysConfiguration(
                                  clientKey: EnvInfo.adyenClientKey,
                                  appleMerchantId: EnvInfo.adyenAppleMerchantId,
                                  merchantName: EnvInfo.adyenMerchantName,
                                  googleMerchantId: 'BCR2DN7TRDA45NTJ',
                                ),
                                env: 'test',
                                redirectURL: returnURL,
                                //'https://app.staging.bloomwell.de/payment_status?merchantReference=${reference.value}',
                              ),
                              onConfigurationStatus: (status) {
                                configurationStatus.value = status;
                              },
                              customPaymentConfigurationWidget: CustomPaymentConfigurationWidget(
                                klarnaPayEnum: KlarnaPayEnum.redirect,
                                processingKlarnaWidget: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      Text('Processing Klarna'),
                                    ],
                                  ),
                                ),
                                initializationKlarnaWidget: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      Text('Initializing Klarna'),
                                    ],
                                  ),
                                ),
                              ),
                              shopperPaymentInformation: ShopperPaymentInformation(
                                billingAddress: ShopperBillingAddress(
                                  city: 'Frankfurt',
                                  street: 'berliner strasse',
                                  houseNumberOrName: '1',
                                  country: 'DE',
                                  postalCode: '60351',
                                ),
                                countryCode: 'DE',
                                invoiceId: reference.value!,
                                locale: 'de_DE',
                                appleMerchantId: '',
                                merchantName: 'BloomwellECOM',
                                telephoneNumber: '',
                              ),
                              onPaymentResult: (payment) {
                                switch (payment) {
                                  case PaymentAdvancedFinished():
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          icon: const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 64,
                                          ),
                                          title: const Text('Payment successful'),
                                          actions: [
                                            TextButton(
                                              child: const Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    break;
                                  case PaymentSessionFinished():
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          icon: const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 64,
                                          ),
                                          title: const Text('Payment successful'),
                                          actions: [
                                            TextButton(
                                              child: const Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    break;
                                  case PaymentCancelledByUser():
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          icon: const Icon(
                                            Icons.error,
                                            color: Colors.orangeAccent,
                                            size: 56,
                                          ),
                                          title: const Text('Payment cancelled'),
                                          actions: [
                                            TextButton(
                                              child: const Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    break;
                                  case PaymentError():
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          icon: const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                            size: 56,
                                          ),
                                          title: const Text('Payment Failed'),
                                          actions: [
                                            TextButton(
                                              child: const Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    break;
                                }
                              },
                            );
                          }
                        : null,
                    child: amount.value == null || reference.value == null
                        ? const Text('finish configuration plz')
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 4,
                            children: [
                              Text('Pay now ${amount.value! / 100}€ for ${reference.value!}'),
                              if (configurationStatus.value == ConfigurationStatus.started) ...[
                                const SizedBox.square(
                                  dimension: 16,
                                  child: CircularProgressIndicator(),
                                ),
                              ]
                            ],
                          ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isDone(AdyenPaymentStatus? status) {
    return status == AdyenPaymentStatus.completed ||
        status == AdyenPaymentStatus.authorized ||
        status == AdyenPaymentStatus.paid ||
        status == AdyenPaymentStatus.refunded ||
        status == AdyenPaymentStatus.refundFailed ||
        status == AdyenPaymentStatus.failed;
  }
}

class ConfigurationInputWidget extends StatefulWidget {
  final Function(String, String, String) onConfigurationSaved;
  const ConfigurationInputWidget({super.key, required this.onConfigurationSaved});

  @override
  State<StatefulWidget> createState() => _ConfigurationInputState();
}

class _ConfigurationInputState extends State<ConfigurationInputWidget> {
  final _formKey = GlobalKey<FormState>();
  final _baseUrlController =
      TextEditingController(text: 'https://api.payments.staging.bloomwell.de/v1');
  final _invoiceIdController = TextEditingController(text: 'A06733043421394');
  final _tokenController = TextEditingController(
      text:
          'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlhXSGlYLXpzSWcwYW5KTzFwc1VpWSJ9.eyJodHRwczovL2dydWVuZWJyaXNlLmRlL2VtYWlsIjoic2FiaW5hLmxhdXRoK3N0ZzE0QGJsb29td2VsbC5kZSIsImh0dHBzOi8vZ3J1ZW5lYnJpc2UuZGUvZmlyc3RfbmFtZSI6IlNhYmluYSIsImh0dHBzOi8vZ3J1ZW5lYnJpc2UuZGUvbGFzdF9uYW1lIjoiVmllcnplaG4iLCJodHRwczovL2xvZ2luLmFsZ2VhY2FyZS5jb20vemlkIjoiWjQ5MTk1OTg0ODI1MjE3IiwiaXNzIjoiaHR0cHM6Ly9hbGdlYWNhcmUtc3RhZ2luZy5ldS5hdXRoMC5jb20vIiwic3ViIjoiYXV0aDB8NjgxMjA5NDQ5MWI4MjIzNGZmOWRiNGM3IiwiYXVkIjpbImh0dHBzOi8vYWxnZWFjYXJlLXN0YWdpbmcuZXUuYXV0aDAuY29tL2FwaS92Mi8iLCJodHRwczovL2FsZ2VhY2FyZS1zdGFnaW5nLmV1LmF1dGgwLmNvbS91c2VyaW5mbyJdLCJpYXQiOjE3NTg3MDMyNTgsImV4cCI6MTc1ODg3NjA1OCwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSBlbWFpbCByZWFkOmN1cnJlbnRfdXNlciB1cGRhdGU6Y3VycmVudF91c2VyX21ldGFkYXRhIGRlbGV0ZTpjdXJyZW50X3VzZXJfbWV0YWRhdGEgY3JlYXRlOmN1cnJlbnRfdXNlcl9tZXRhZGF0YSBjcmVhdGU6Y3VycmVudF91c2VyX2RldmljZV9jcmVkZW50aWFscyBkZWxldGU6Y3VycmVudF91c2VyX2RldmljZV9jcmVkZW50aWFscyB1cGRhdGU6Y3VycmVudF91c2VyX2lkZW50aXRpZXMgb2ZmbGluZV9hY2Nlc3MiLCJndHkiOiJwYXNzd29yZCIsImF6cCI6Ik54Nkk0d2FLYWF3WUl2WWI2czl3cExyZGpFTGdkcmtFIn0.ZS60k9jZg7kbsE9gM1Okyr5Nx1u2uNoqaNTc-Xf0qXI_wIb45meJa2rR3p8v1_LIcHPvFyx0e28mCumnOIT0LEvGdwtzezCJNcnsN5MdwC8GiB3lTSFRup7m9iF-XAEPliBJZGbrq1zsj45j0cCAG5W1rSjxfI4uwcNLYaKChCg7DQdVtCY-nRPy4eQYG2KcY3bHoOFQPBEhkHafvR9OoOMheWOs6W-1Zjx7azJKQFBdswumd5R8fL6ZzYVKZM3F3jkpdvr7c7Ivbnaq2cW5RC1ia_qQzTBfHyhy-PZ8-Jr-WmO4fnEpk7osmaAjLunPdsXsFDjzbTia71r4h-mEkA');

  @override
  void dispose() {
    _baseUrlController.dispose();
    _invoiceIdController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onConfigurationSaved(
        _baseUrlController.text,
        _tokenController.text,
        _invoiceIdController.text,
      );
    }
  }

  String? _validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a base URL';
    }
    final uri = Uri.tryParse(value);
    // Check for a valid scheme and a host. This is a more reliable
    // check for a typical web URL.
    final bool hasHttpScheme = uri?.scheme == 'http' || uri?.scheme == 'https';
    final bool hasHost = uri?.host.isNotEmpty ?? false;
    if (!hasHttpScheme || !hasHost) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  String? _validateInvoiceId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an invoice ID';
    }
    if (value.length < 3) {
      return 'Invoice ID must be at least 3 characters';
    }
    return null;
  }

  String? _validateToken(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a token';
    }
    if (value.length < 10) {
      return 'Token must be at least 10 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            const Text(
              'Configure Payment Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            // Base URL Input
            TextFormField(
              controller: _baseUrlController,
              decoration: const InputDecoration(
                labelText: 'Base URL Service',
                hintText: 'https://api.example.com',
                prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              validator: _validateUrl,
            ),

            // Invoice ID Input
            TextFormField(
              controller: _invoiceIdController,
              decoration: const InputDecoration(
                labelText: 'Invoice ID',
                hintText: 'Enter invoice identifier',
                prefixIcon: Icon(Icons.receipt),
                border: OutlineInputBorder(),
              ),
              validator: _validateInvoiceId,
            ),

            // Token Input
            TextFormField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: 'Authentication Token',
                hintText: 'Enter your access token',
                prefixIcon: Icon(Icons.security),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: _validateToken,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _baseUrlController.clear();
                    _invoiceIdController.clear();
                    _tokenController.clear();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(
                      width: 0,
                    ),
                  ),
                  child: const Text(
                    'Clear Form',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Configuration',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Clear Button
              ],
            ),
            // Submit Button
          ],
        ),
      ),
    );
  }
}

class LoadInformation extends StatefulWidget {
  final AdyenClient client;
  final String invoiceID;
  final Function(PaymentInformation) onResult;
  const LoadInformation({
    super.key,
    required this.client,
    required this.invoiceID,
    required this.onResult,
  });
  @override
  State<StatefulWidget> createState() => _LoadInformationState();
}

class _LoadInformationState extends State<LoadInformation> {
  late final Future<PaymentInformation> future;
  @override
  void initState() {
    super.initState();
    future = loadInformation();
  }

  Future<PaymentInformation> loadInformation() async {
    final data = await widget.client.paymentInformation(invoiceId: widget.invoiceID);
    widget.onResult(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Dialog(
          child: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
