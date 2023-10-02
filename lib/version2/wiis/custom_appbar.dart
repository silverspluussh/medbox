import 'package:MedBox/version2/UI/profile/profile.dart';
import 'package:MedBox/version2/UI/reminders.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import '../providers.dart/authprovider.dart';
import '../providers.dart/navprovider.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int index = ref.watch(navIndexProvider);
    final user = ref.watch(authRepositoryProvider).currentUser;

    return SliverAppBar(
      floating: true,
      toolbarHeight: 45,
      backgroundColor: Colors.white,
      title: Ltxt(
          text: index == 0
              ? 'Home'.toUpperCase()
              : index == 1
                  ? "Medications".toUpperCase()
                  : "Medical Test".toUpperCase()),
      centerTitle: true,
      actions: [
        InkWell(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const Profile())),
          child: CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage(user!.photoURL!),
          ),
        ),
        const SizedBox(width: 20),
        InkWell(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const Reminders())),
            child: Image.asset("assets/icons/reminder.png",
                width: 30, height: 25)),
        10.widthBox
      ],
    );
  }
}
