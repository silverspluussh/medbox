import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/version2/UI/home.dart';
import 'package:MedBox/version2/UI/meds/medication.dart';
import 'package:MedBox/version2/UI/menu.dart';
import 'package:MedBox/version2/UI/rtest/rapidtest.dart';
import 'package:MedBox/version2/UI/vitals.dart';
import 'package:MedBox/version2/providers.dart/navprovider.dart';
import 'package:MedBox/version2/utilites/navigation.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';

class MyRender extends ConsumerStatefulWidget {
  const MyRender({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyRenderState();
}

class _MyRenderState extends ConsumerState<MyRender> {
  List<Widget>? pages;

  void onItemTapped(int index) {
    ref.watch(navIndexProvider.notifier).state = index;
  }

  @override
  void initState() {
    super.initState();

    pages = [
      const Home(),
      const MyVitals(),
      const Rapidtest(),
      const Medications(),
      const Menu()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: 500.milliseconds,
          showCloseIcon: true,
          backgroundColor: Colors.green[300],
          content: SizedBox(
            height: 50,
            width: 200,
            child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red[300]!)),
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Ltxt(text: 'exit medbox')),
          ).px12(),
        ));
        return false;
      },
      child: Scaffold(
        body: SafeArea(
            child: IndexedStack(
                index: ref.watch(navIndexProvider), children: pages!)),
        bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            selectedItemColor: kwhite,
            type: BottomNavigationBarType.shifting,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            unselectedItemColor: kblack,
            selectedIconTheme: const IconThemeData(size: 20),
            unselectedIconTheme: const IconThemeData(size: 15),
            backgroundColor: kprimary,
            currentIndex: ref.watch(navIndexProvider),
            selectedFontSize: 11,
            onTap: onItemTapped,
            items: [
              ...navitems.map((e) => BottomNavigationBarItem(
                  backgroundColor: kprimary,
                  icon: ImageIcon(AssetImage(e.icon!)),
                  label: e.title))
            ]),
      ),
    );
  }
}
