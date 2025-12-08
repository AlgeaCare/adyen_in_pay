class CostCoverageResponse {
  final bool applied;
  final int amount;
  final CostCoverageTransaction transaction;

  const CostCoverageResponse({
    required this.applied,
    required this.amount,
    required this.transaction,
  });

  factory CostCoverageResponse.fromJson(Map<String, dynamic> json) {
    return CostCoverageResponse(
      applied: json['applied'] as bool,
      amount: json['amount'] as int,
      transaction: CostCoverageTransaction.fromJson(json['transaction'] as Map<String, dynamic>),
    );
  }


  CostCoverageResponse copyWith({
    bool? applied,
    int? amount,
    CostCoverageTransaction? transaction,
  }) {
    return CostCoverageResponse(
      applied: applied ?? this.applied,
      amount: amount ?? this.amount,
      transaction: transaction ?? this.transaction,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CostCoverageResponse &&
          runtimeType == other.runtimeType &&
          applied == other.applied &&
          amount == other.amount &&
          transaction == other.transaction;

  @override
  int get hashCode => Object.hash(applied, amount, transaction);

  @override
  String toString() =>
      'CostCoverageResponse(applied: $applied, amount: $amount, transaction: $transaction)';
}

class CostCoverageTransaction {
  final int id;
  final String paymentInvoiceId;
  final int amount;
  final String status;
  final String transactionDate;
  final String type;
  final String? method;
  final String? pspNumber;
  final String? costCoverageCode;
  final int basketId;
  final int? transferId;
  final List<SubMerchantShare>? intendedSubMerchantShares;
  final List<SubMerchantShare>? appliedSubMerchantShares;
 
  const CostCoverageTransaction({
    required this.id,
    required this.paymentInvoiceId,
    required this.amount,
    required this.status,
    required this.transactionDate,
    required this.type,
    this.method,
    this.pspNumber,
    this.costCoverageCode,
    required this.basketId,
    this.transferId,
    this.intendedSubMerchantShares,
    this.appliedSubMerchantShares,

  });

  factory CostCoverageTransaction.fromJson(Map<String, dynamic> json) {
    return CostCoverageTransaction(
      id: json['id'] as int,
      paymentInvoiceId: json['payment_invoice_id'] as String,
      amount: json['amount'] as int,
      status: json['status'] as String,
      transactionDate: json['transaction_date'] as String,
      type: json['type'] as String,
      method: json['method'] as String?,
      pspNumber: json['psp_number'] as String?,
      costCoverageCode: json['cost_coverage_code'] as String?,
      basketId: json['basket_id'] as int,
      transferId: json['transfer_id'] as int?,
      intendedSubMerchantShares: (json['intendedSubMerchantShares'] as List<dynamic>?)
          ?.map((e) => SubMerchantShare.fromJson(e as Map<String, dynamic>))
          .toList(),
      appliedSubMerchantShares: (json['appliedSubMerchantShares'] as List<dynamic>?)
          ?.map((e) => SubMerchantShare.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }



  CostCoverageTransaction copyWith({
    int? id,
    String? paymentInvoiceId,
    int? amount,
    String? status,
    String? transactionDate,
    String? type,
    String? method,
    String? pspNumber,
    String? costCoverageCode,
    int? basketId,
    int? transferId,
    List<SubMerchantShare>? intendedSubMerchantShares,
    List<SubMerchantShare>? appliedSubMerchantShares,
    String? createdAt,
    String? updatedAt,
  }) {
    return CostCoverageTransaction(
      id: id ?? this.id,
      paymentInvoiceId: paymentInvoiceId ?? this.paymentInvoiceId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      transactionDate: transactionDate ?? this.transactionDate,
      type: type ?? this.type,
      method: method ?? this.method,
      pspNumber: pspNumber ?? this.pspNumber,
      costCoverageCode: costCoverageCode ?? this.costCoverageCode,
      basketId: basketId ?? this.basketId,
      transferId: transferId ?? this.transferId,
      intendedSubMerchantShares: intendedSubMerchantShares ?? this.intendedSubMerchantShares,
      appliedSubMerchantShares: appliedSubMerchantShares ?? this.appliedSubMerchantShares,

    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CostCoverageTransaction &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          paymentInvoiceId == other.paymentInvoiceId &&
          amount == other.amount &&
          status == other.status &&
          transactionDate == other.transactionDate &&
          type == other.type &&
          method == other.method &&
          pspNumber == other.pspNumber &&
          costCoverageCode == other.costCoverageCode &&
          basketId == other.basketId &&
          transferId == other.transferId;

  @override
  int get hashCode => Object.hash(
    id,
    paymentInvoiceId,
    amount,
    status,
    transactionDate,
    type,
    method,
    pspNumber,
    costCoverageCode,
    basketId,
    transferId,
  );

  @override
  String toString() =>
      'CostCoverageTransaction(id: $id, paymentInvoiceId: $paymentInvoiceId, amount: $amount, status: $status, type: $type)';
}

class SubMerchantShare {
  final int id;
  final int amount;
  final String subMerchantResourceId;
  final SubMerchant? subMerchant;

  const SubMerchantShare({
    required this.id,
    required this.amount,
    required this.subMerchantResourceId,
    this.subMerchant,
  });

  factory SubMerchantShare.fromJson(Map<String, dynamic> json) {
    return SubMerchantShare(
      id: json['id'] as int,
      amount: json['amount'] as int,
      subMerchantResourceId: json['sub_merchant_resource_id'] as String,
      subMerchant: json['subMerchant'] != null
          ? SubMerchant.fromJson(json['subMerchant'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'sub_merchant_resource_id': subMerchantResourceId,
    'subMerchant': subMerchant?.toJson(),
  };

  SubMerchantShare copyWith({
    int? id,
    int? amount,
    String? subMerchantResourceId,
    SubMerchant? subMerchant,
  }) {
    return SubMerchantShare(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      subMerchantResourceId: subMerchantResourceId ?? this.subMerchantResourceId,
      subMerchant: subMerchant ?? this.subMerchant,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubMerchantShare &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amount == other.amount &&
          subMerchantResourceId == other.subMerchantResourceId &&
          subMerchant == other.subMerchant;

  @override
  int get hashCode => Object.hash(id, amount, subMerchantResourceId, subMerchant);

  @override
  String toString() =>
      'SubMerchantShare(id: $id, amount: $amount, subMerchantResourceId: $subMerchantResourceId)';
}

class SubMerchant {
  final String type;

  const SubMerchant({required this.type});

  factory SubMerchant.fromJson(Map<String, dynamic> json) {
    return SubMerchant(type: json['type'] as String);
  }

  Map<String, dynamic> toJson() => {'type': type};

  SubMerchant copyWith({String? type}) {
    return SubMerchant(type: type ?? this.type);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubMerchant && runtimeType == other.runtimeType && type == other.type;

  @override
  int get hashCode => type.hashCode;

  @override
  String toString() => 'SubMerchant(type: $type)';
}
