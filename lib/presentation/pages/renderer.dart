import 'package:MedBox/constants/fonts.dart';
import 'package:MedBox/domain/sharedpreferences/sharedprefs.dart';
import 'package:MedBox/presentation/pages/myprofile/myprofile.dart';
import 'package:MedBox/presentation/pages/reminders/reminders.dart';

import 'package:flutter/material.dart';
import 'package:MedBox/presentation/providers/navigation.dart';
import 'package:MedBox/presentation/pages/medication/medication_main.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/colors.dart';
import '../../utils/extensions/notification.dart';
import 'main_dashboard.dart';
import 'settings_main.dart';

class Render extends StatefulWidget {
  const Render({Key key}) : super(key: key);

  @override
  State<Render> createState() => _RenderState();
}

class _RenderState extends State<Render> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  AnimationController animationController;
  List<Widget> _pages;
  String username;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      username = SharedCli().getusername();
    });
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _pages = [
      const DashboardOverview(),
      const Medications(),
      const MyProfile(),
      const Settings()
    ];
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: AppColors.scaffoldColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: _selectedIndex == 0 ? false : true,
            title: _selectedIndex == 0
                ? _dashboardtitle()
                : _selectedIndex == 1
                    ? const Text(
                        ' Medications schedules',
                        style: popheaderB,
                      )
                    : _selectedIndex == 2
                        ? const Text(
                            'My Profile',
                            style: popheaderB,
                          )
                        : const Text(
                            'Settings',
                            style: popheaderB,
                          ),
            actions: _selectedIndex == 0
                ? _dashboardactions(context)
                : _selectedIndex == 1
                    ? _dashboardactions(context)
                    : _selectedIndex == 2
                        ? []
                        : [],
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          extendBody: false,
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

  Column _dashboardtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Good day, ',
          style: TextStyle(
              fontFamily: 'Popb',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black26),
        ),
        const SizedBox(height: 5),
        Text(
          username ?? 'none',
          style: const TextStyle(
              fontFamily: 'Popb',
              fontSize: 10,
              fontWeight: FontWeight.w300,
              color: Colors.black),
        )
      ],
    );
  }
}

List<Widget> _dashboardactions(BuildContext context) {
  return [
    Container(
      height: 25,
      width: 25,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.fill, image: NetworkImage(SharedCli().getgpfp()))),
    ),
    const SizedBox(width: 10),
    FutureBuilder(
        future: NotifConsole().pendingreminders(),
        builder: (c, x) {
          if (x.hasData) {
            return VxBadge(
                color: x.data.isNotEmpty ? Colors.green : Colors.red,
                size: 10,
                type: VxBadgeType.round,
                position: VxBadgePosition.rightTop,
                child: Semantics(
                  tooltip: 'Medication reminders',
                  button: true,
                  child: IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const MedReminders()))),
                    icon: const Icon(Icons.notifications_active_outlined,
                        size: 30),
                    color: AppColors.primaryColor.withOpacity(0.6),
                  ),
                ));
          }
          return const SizedBox();
        }),
    const SizedBox(width: 10)
  ];
}
