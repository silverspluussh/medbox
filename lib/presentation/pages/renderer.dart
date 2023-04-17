import 'package:flutter/material.dart';
import 'package:MedBox/presentation/providers/navigation.dart';
import 'package:MedBox/presentation/pages/medication/medication_main.dart';
import 'package:MedBox/presentation/pages/bodyvitals/vscreen.dart';
import 'package:MedBox/presentation/pages/profilescreen.dart';
import 'package:provider/provider.dart';
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
  bool drawerclised = true;

  late AnimationController animationController;
  late Animation<double> animation;
  late Animation<double> scanimation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });

    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    scanimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        VxToast.show(context,
            msg: 'You cannot exit Med Box this way.',
            pdVertical: 20,
            pdHorizontal: 20,
            bgColor: Colors.red,
            textColor: Colors.white,
            position: VxToastPosition.bottom);

        return false;
      },
      child: Scaffold(
          body: Consumer<BottomNav>(builder: (context, vale, child) {
            if (vale.navEnum.name == 'home') {
              return const DashboardOverview();
            } else if (vale.navEnum.name == 'settings') {
              return const Settings();
            } else if (vale.navEnum.name == 'vitals') {
              return const VitalsMain();
            } else if (vale.navEnum.name == 'medications') {
              return const Medications();
            } else if (vale.navEnum.name == 'Profile') {}
            return const ProfileScren();
          }),
          backgroundColor: Colors.white,
          extendBody: true,
          resizeToAvoidBottomInset: false,

          // Image.asset('assets/icons/reminder.png'),
          bottomNavigationBar: BottomNavigatorx(size: size)),
    );
  }
}

class BottomNavigatorx extends StatelessWidget {
  const BottomNavigatorx({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        height: 80,
        width: size.width - 20,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...navitems.map((e) {
                final bottomprovider =
                    Provider.of<BottomNav>(context, listen: false);
                return Consumer<BottomNav>(builder: (context, value, child) {
                  return GestureDetector(
                    onTap: () => bottomprovider.updatenav(e),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: value.navEnum == e.navEnum
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(25),
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(25))),
                          child: Center(
                              child: ImageIcon(
                            AssetImage(e.icon),
                            color: value.navEnum == e.navEnum
                                ? Colors.blue
                                : Colors.white,
                            size: 20,
                          )),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          e.title.toUpperCase(),
                          style: TextStyle(
                              fontSize: 12,
                              color: value.navEnum == e.navEnum
                                  ? Colors.blue
                                  : Colors.white,
                              fontFamily: 'Pop',
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                });
              })
            ]),
      ),
    );
  }
}
