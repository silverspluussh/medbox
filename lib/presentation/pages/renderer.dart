import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/domain/sharedpreferences/sharedprefs.dart';
import 'package:MedBox/main.dart';
import 'package:MedBox/presentation/pages/myprofile/myprofile.dart';
import 'package:MedBox/presentation/pages/reminders/reminders.dart';
import 'package:flutter/material.dart';
import 'package:MedBox/presentation/providers/navigation.dart';
import 'package:MedBox/presentation/pages/medication/medication_main.dart';
import '../../utils/extensions/notification.dart';
import 'main_dashboard.dart';
import 'settings_main.dart';

class Render extends StatefulWidget {
  const Render({super.key});

  @override
  State<Render> createState() => _RenderState();
}

class _RenderState extends State<Render> with SingleTickerProviderStateMixin {
  int _selectedIndex = prefs.getInt('selectedindex') ?? 0;
  List<Widget>? pages;
  String? username;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      prefs.setInt('selectedindex', index);
    });
  }

  @override
  void initState() {
    super.initState();

    pages = [
      const DashboardOverview(),
      const Medications(),
      const MedReminders(),
      const MyProfile(),
      const Settings(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: _selectedIndex == 0 ? false : true,
              title: _selectedIndex == 0
                  ? _dashboardtitle()
                  : _selectedIndex == 1
                      ? Text(
                          ' Medications',
                          style: Theme.of(context).textTheme.titleSmall,
                        )
                      : _selectedIndex == 2
                          ? Text(
                              'Reminders',
                              style: Theme.of(context).textTheme.titleSmall,
                            )
                          : _selectedIndex == 3
                              ? Text(
                                  'My Profile',
                                  style: Theme.of(context).textTheme.titleSmall,
                                )
                              : Text(
                                  'Settings',
                                  style: Theme.of(context).textTheme.titleSmall,
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
              children: pages!,
            ),
            extendBody: false,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: [
                ...navitems.map((e) => BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage(e.icon!), size: 20),
                    label: e.title))
              ],
              elevation: 5,
              selectedFontSize: 12,
              selectedItemColor: kprimary,
              unselectedItemColor: Colors.black,
              backgroundColor: kprimary,
              unselectedFontSize: 11,
              showSelectedLabels: true,
              iconSize: 20,
            )));
  }

  Column _dashboardtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good day, ',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 5),
        Text(
          SharedCli().getusername() ?? '',
          style: Theme.of(context).textTheme.bodySmall,
        )
      ],
    );
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
                fit: BoxFit.fill, image: NetworkImage(SharedCli().getgpfp()!))),
      ),
      const SizedBox(width: 10),
      FutureBuilder(
          future: NotifConsole().pendingreminders(),
          builder: (c, x) {
            if (x.hasData) {
              return Semantics(
                tooltip: 'Notifications',
                button: true,
                child: IconButton(
                  onPressed: () {},
                  icon:
                      const Icon(Icons.notifications_active_outlined, size: 30),
                  color: kprimary.withOpacity(0.6),
                ),
              );
            }
            return const SizedBox();
          }),
      const SizedBox(width: 10)
    ];
  }
}
