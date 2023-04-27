import 'package:MedBox/presentation/pages/myprofile/myprofile.dart';
import 'package:flutter/material.dart';
import 'package:MedBox/presentation/providers/navigation.dart';
import 'package:MedBox/presentation/pages/medication/medication_main.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/colors.dart';
import 'main_dashboard.dart';
import 'settings_main.dart';

class Render extends StatefulWidget {
  const Render({super.key});

  @override
  State<Render> createState() => _RenderState();
}

class _RenderState extends State<Render> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController animationController;
  late List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _pages = [
      const DashboardOverview(),
      const Medications(),
      const MyProfile(),
      const Settings()
    ];
  }

  @override
  void dispose() {
    // ...
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        VxToast.show(context,
            msg: 'Slide to Exit Med Box',
            pdVertical: 20,
            pdHorizontal: 20,
            bgColor: Colors.red,
            textColor: Colors.white,
            position: VxToastPosition.bottom);

        return true;
      },
      child: Scaffold(
          backgroundColor: AppColors.scaffoldColor,
          body: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),

          ///backgroundColor: Colors.white,
          extendBody: true,
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              ...navitems.map((e) => BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage(e.icon), size: 20),
                  label: e.title))
            ],
            elevation: 5,
            selectedFontSize: 12,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: Colors.black,
            backgroundColor: AppColors.primaryColor,
            unselectedFontSize: 11,
            showSelectedLabels: true,
            iconSize: 20,
          )),
    );
  }
}
