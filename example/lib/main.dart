import 'package:adyen_in_pay_example/src/adyen_component.dart';
import 'package:adyen_in_pay_example/src/drop_in.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final pageController = PageController();
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Adyen integration app'),
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (value) {
            setState(() {
              currentPage = value;
            });
          },
          physics: const NeverScrollableScrollPhysics(),
          allowImplicitScrolling: true,
          children: const [MyAdyenComponentApp(), DropInWidget()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          onTap: (value) {
            pageController.animateToPage(value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              label: 'Adyen Component',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payments),
              label: 'Drop-in Widget',
            ),
          ],
        ),
      ),
    );
  }
}
