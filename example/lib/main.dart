import 'package:adyen_in_pay_example/src/adyen_component.dart';
import 'package:adyen_in_pay_example/src/drop_in.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Colors.blue,
          onPrimary: Colors.white,
          secondary: Colors.blue,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
          brightness: Brightness.light,
        ),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final pageController = PageController();
  int currentPage = 0;
  final drawerKey = GlobalKey<ScaffoldState>();
  bool expandedSideBar = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageView = PageView(
      controller: pageController,
      onPageChanged: (value) {
        setState(() {
          currentPage = value;
        });
      },
      physics: const NeverScrollableScrollPhysics(),
      allowImplicitScrolling: true,
      children: const [MyAdyenComponentApp(), DropInWidget()],
    );
    return Scaffold(
      key: drawerKey,
      appBar: AppBar(
        title: const Text('Adyen integration app'),
      ),
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;

        return width >= 850
            ? Row(
                children: [
                  SizedBox(
                    width: expandedSideBar ? 200 : 92,
                    child: NavigationRail(
                      extended: expandedSideBar,
                      elevation: 12,
                      groupAlignment: expandedSideBar ? -1 : null,
                      labelType:
                          expandedSideBar ? null : NavigationRailLabelType.none,
                      leading: Align(
                        alignment: expandedSideBar
                            ? Alignment.topLeft
                            : Alignment.topCenter,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              expandedSideBar = !expandedSideBar;
                            });
                          },
                          icon: const Icon(Icons.menu, size: 24),
                        ),
                      ),
                      destinations: [
                        NavigationRailDestination(
                          icon: const Icon(Icons.payment),
                          label: expandedSideBar
                              ? const Text('Adyen Component')
                              : const SizedBox.shrink(),
                        ),
                        NavigationRailDestination(
                          icon: const Icon(Icons.payments),
                          label: expandedSideBar
                              ? const Text('Drop-in Widget')
                              : const SizedBox.shrink(),
                        ),
                      ],
                      selectedIndex: currentPage,
                      onDestinationSelected: (value) {
                        drawerKey.currentState?.openEndDrawer();
                        pageController.animateToPage(value,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                    ),
                  ),
                  Expanded(child: pageView)
                ],
              )
            : pageView;
      }),
      drawer: MediaQuery.sizeOf(context).width > 600 &&
              MediaQuery.sizeOf(context).width < 850
          ? SizedBox(
              width: 200,
              child: NavigationRail(
                extended: true,
                groupAlignment: -1,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.payment),
                    label: Text('Adyen Component'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.payments),
                    label: Text('Drop-in Widget'),
                  ),
                ],
                selectedIndex: currentPage,
                onDestinationSelected: (value) {
                  drawerKey.currentState?.openEndDrawer();
                  pageController.animateToPage(value,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
              ),
            )
          : null,
      bottomNavigationBar: MediaQuery.sizeOf(context).width > 600
          ? null
          : BottomNavigationBar(
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
    );
  }
}
