import 'package:MedBox/version2/wiis/customdialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../constants/colors.dart';
import '../UI/profile/profile.dart';
import '../providers.dart/authprovider.dart';
import 'txt.dart';

class Mydrawer extends ConsumerWidget {
  const Mydrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;

    return Drawer(
      child: VStack([
        UserAccountsDrawerHeader(
          decoration: const BoxDecoration(color: kprimary),
          accountName: Text(user!.displayName!),
          accountEmail: Text(user.email!),
          currentAccountPicture: CachedNetworkImage(
            imageUrl: user.photoURL!,
            errorWidget: (context, url, error) =>
                imageContainer(const AssetImage('assets/icons/Home.png')),
            imageBuilder: (context, imageProvider) =>
                imageContainer(imageProvider),
            placeholder: (context, url) =>
                imageContainer(const AssetImage('assets/icons/Home.png')),
            cacheManager: CacheManager(Config('pfpcache', stalePeriod: 5.days)),
          ),
        ),
        ListTile(
            trailing: const Icon(Icons.arrow_forward_ios, size: 20),
            onTap: () {},
            leading: const Icon(Icons.info, color: kprimary),
            title: const Ltxt(text: 'About Med Box')),
        ListTile(
            trailing: const Icon(Icons.arrow_forward_ios, size: 20),
            onTap: () {},
            leading: const Icon(Icons.language, color: kprimary),
            title: const Ltxt(text: 'Languages')),
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios, size: 20),
          onTap: () {},
          leading: const Icon(Icons.rule, color: kprimary),
          title: const Ltxt(text: 'Units'),
        ),
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios, size: 20),
          onTap: () {
            Navigator.pop(context);
            launchUrl(Uri.parse('https://www.medboxdata.com'));
          },
          leading: const Icon(Icons.support_agent, color: kprimary),
          title: const Ltxt(text: 'Support'),
        ),
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios, size: 20),
          onTap: () {
            Navigator.pop(context);

            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const Profile()));
          },
          leading: const Icon(Icons.support, color: kprimary),
          title: const Ltxt(text: 'Terms and Conditions'),
        ),
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios, size: 20),
          onTap: () {
            Navigator.pop(context);
            Share.share(
                'https://play.google.com/store/apps/details?id=com.datasus.medbox Hi there,can I share this amazing application called medbox with you?',
                subject: 'Medbox for easy health management');
          },
          leading: const Icon(Icons.share, color: kprimary),
          title: const Ltxt(text: 'share with a friend'),
        ),
        const Spacer(),
        ListTile(
          onTap: () => showDialog(
              context: context, builder: (_) => const Customdialog()),
          leading: Image.asset('assets/icons/log-out-54-512.png',
              width: 30, height: 30, color: kred),
          title: Ltxt(text: AppLocalizations.of(context)!.lout).centered(),
        ),
        const SizedBox(height: 20),
        ListTile(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                  child: Ltxt(text: AppLocalizations.of(context)!.ext)),
            ).px12(),
          )),
          leading: Image.asset('assets/icons/sign-out-243-512.png',
              width: 30, height: 30, color: kred),
          title: Ltxt(text: AppLocalizations.of(context)!.ext).centered(),
        ),
        const SizedBox(height: 20),
      ]),
    );
  }
}

Container imageContainer(ImageProvider<Object> imageProvider) {
  return Container(
    width: 70,
    height: 70,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
    ),
  );
}
