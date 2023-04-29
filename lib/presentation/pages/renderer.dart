import 'package:MedBox/presentation/pages/myprofile/myprofile.dart';
import 'package:MedBox/presentation/pages/reminders/reminders_main.dart';
import 'package:flutter/material.dart';
import 'package:MedBox/presentation/providers/navigation.dart';
import 'package:MedBox/presentation/pages/medication/medication_main.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/colors.dart';
import '../../main.dart';
import '../../utils/extensions/notification.dart';
import '../../utils/extensions/photos_extension.dart';
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
  late String? username;
  var pfp;

  bool alarmactive = false;

  void referesh() async {
    final datum = await NotifConsole().getreminders();

    setState(() {
      datum.isNotEmpty ? alarmactive = true : alarmactive = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    referesh();
    setState(() {
      pfp = prefs.getString('pfp');
      username = prefs.getString('username') ?? prefs.getString('googlename');
    });
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _pages = [
      const DashboardOverview(),
      const Medications(),
      MyProfile(),
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
        VxToast.show(context,
            msg: 'Slide to Exit Med Box',
            pdVertical: 20,
            pdHorizontal: 20,
            bgColor: Colors.red,
            textColor: Colors.white,
            position: VxToastPosition.bottom);

        return false;
      },
      child: Scaffold(
          backgroundColor: AppColors.scaffoldColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: _selectedIndex == 0
                ? false
                : _selectedIndex == 1
                    ? false
                    : true,
            title: _selectedIndex == 0
                ? _dashboardtitle()
                : _selectedIndex == 1
                    ? const Text(
                        ' Medications schedules',
                        style: TextStyle(
                            fontFamily: 'Popb',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      )
                    : _selectedIndex == 2
                        ? const Text(
                            'My Profile',
                            style: TextStyle(
                                fontFamily: 'Popb',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          )
                        : const Text(
                            'Settings',
                            style: TextStyle(
                                fontFamily: 'Popb',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
            actions: _selectedIndex == 0
                ? _dashboardactions(pfp)
                : _selectedIndex == 1
                    ? _medicationactions(context, alarmactive: alarmactive)
                    : _selectedIndex == 2
                        ? []
                        : [],
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          extendBody: true,
          resizeToAvoidBottomInset: true,
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black26),
        ),
        const SizedBox(height: 5),
        username != null
            ? Text(
                username!,
                style: const TextStyle(
                    fontFamily: 'Popb',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )
            : InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex == 2;
                  });
                },
                child: const Text(
                  'set username',
                  style: TextStyle(
                      fontFamily: 'Popb',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor),
                ),
              ),
      ],
    );
  }
}

List<Widget> _medicationactions(BuildContext context, {required alarmactive}) {
  return [
    Badge(
      smallSize: 10,
      backgroundColor: alarmactive == true ? Colors.green : Colors.red,
      alignment: AlignmentDirectional.topStart,
      child: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const DrugAlarms()));
          },
          icon: const ImageIcon(
              size: 25, AssetImage('assets/icons/reminder.png'))),
    )
  ];
}

List<Widget> _dashboardactions(pfp) {
  return [
    Container(
      height: 25,
      width: 25,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: prefs.getBool('googleloggedin') == true
                  ? NetworkImage(prefs.getString('googleimage')!)
                  : pfp != null
                      ? MemoryImage(Utility().dataFromBase64String(pfp))
                      : const AssetImage('assets/icons/profile-35-64.png')
                          as ImageProvider)),
    ),
    DropdownButton(
      items: [],
      onChanged: (e) {},
      icon: const Icon(
        Icons.notifications_none_outlined,
        size: 25,
        color: AppColors.primaryColor,
      ),
    )
  ];
}
