import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/l10n/langprovider.dart';
import 'package:MedBox/version2/UI/alarms.dart';
import 'package:MedBox/version2/UI/profile/profile.dart';
import 'package:MedBox/version2/UI/reminders.dart';
import 'package:MedBox/version2/firebase/vitalsfirebase.dart';
import 'package:MedBox/version2/providers.dart/authprovider.dart';
import 'package:MedBox/version2/providers.dart/emoticon.dart';
import 'package:MedBox/version2/wiis/async_value_widget.dart';
import 'package:MedBox/version2/wiis/barchart.dart';
import 'package:MedBox/version2/wiis/cucontainer.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../l10n/l10n.dart';
import '../models/emotions.dart';
import '../providers.dart/navprovider.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final locale = ref.read(languageProvider).locale ?? const Locale('en');
    final user = ref.watch(authRepositoryProvider).currentUser;
    final vitals = ref.watch(vitalsStreamProvider);

    var size = MediaQuery.of(context);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            width: size.size.width,
            child: HStack([
              InkWell(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => MedReminders())),
                child: SizedBox(
                  width: size.size.width * 0.565,
                  child: VStack(
                      alignment: MainAxisAlignment.center,
                      crossAlignment: CrossAxisAlignment.start,
                      [
                        Text(
                          '${AppLocalizations.of(context)!.hi} ${user!.displayName}',
                          style: const TextStyle(
                              fontFamily: 'Pop',
                              fontSize: 14,
                              fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 10),
                        HStack([
                          Image.asset(ref.watch(emojiProvider),
                              width: 30, height: 30),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () => modelPop(context),
                            child: Text(
                              AppLocalizations.of(context)!.mood,
                              style: const TextStyle(
                                  fontFamily: 'Go',
                                  color: kprimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        ])
                      ]),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const Profile())),
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(user.photoURL!),
                ),
              ),
              const SizedBox(width: 13),
              DropdownButtonHideUnderline(
                  child: DropdownButton(
                value: locale,
                icon: Container(width: 20),
                items: L10n.all.map((e) {
                  var langflag = L10n.getflag(e.languageCode);
                  return DropdownMenuItem(
                    value: e,
                    child: Center(
                      child: Text(
                        langflag,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 8, 8, 8)),
                      ),
                    ),
                    onTap: () {
                      ref.watch(languageProvider).setlocalizations(e);
                    },
                  );
                }).toList(),
                onChanged: (_) {},
              )),
            ]).p8(),
          ).py8(),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          AsyncValueWidget(
            value: vitals,
            data: (v) => v.isNotEmpty
                ? GestureDetector(
                    onTap: () {},
                    child: Container(
                        width: size.size.width,
                        height: size.size.height * 0.27,
                        decoration: BoxDecoration(
                            color: kprimary.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: BarChartSample2(v)),
                  )
                : Cuscontainer(
                    decor: 'assets/icons/Statistics.png',
                    height: size.size.height * 0.12,
                    child: ListTile(
                      onTap: () =>
                          ref.read(navIndexProvider.notifier).state = 1,
                      leading: const Icon(
                        Icons.add_task,
                        color: kblack,
                      ),
                      title: Ttxt(text: AppLocalizations.of(context)!.vvitals),
                      trailing: Image.asset('assets/icons/Statistics.png',
                          color: kprimary),
                    )).py8(),
          ),
          InkWell(
            onTap: () => ref.read(navIndexProvider.notifier).state = 3,
            child: Cuscontainer(
              height: size.size.height * 0.16,
              decor: 'assets/images/banner.png',
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.medical_information,
                      color: kblack,
                    ),
                    const SizedBox(width: 20),
                    Ttxt(text: AppLocalizations.of(context)!.med),
                  ],
                ),
              ),
            ).py8(),
          ),
          Cuscontainer(
              decor: 'assets/images/bg1.png',
              height: size.size.height * 0.12,
              child: ListTile(
                onTap: () => ref.read(navIndexProvider.notifier).state = 2,
                leading: const Icon(
                  Icons.medical_information,
                  color: kblack,
                ),
                title: Ttxt(text: AppLocalizations.of(context)!.itest),
                trailing: Image.asset('assets/images/testkit.png'),
              )).py8(),
          Cuscontainer(
              decor: 'assets/images/bg1.png',
              height: size.size.height * 0.12,
              child: ListTile(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const Reminders())),
                leading: const Icon(
                  Icons.alarm,
                  color: kblack,
                ),
                title: Ttxt(text: AppLocalizations.of(context)!.reminder),
                trailing: Image.asset('assets/icons/reminders-15-64.png'),
              )).py8(),
        ]))
      ],
    ).px8();
  }
}

void modelPop(context) {
  showModalBottomSheet(
      context: context,
      builder: ((BuildContext context) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          height: 120,
          child: Center(
            child: Consumer(
              builder: (context, WidgetRef ref, child) => SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: HStack(crossAlignment: CrossAxisAlignment.center, [
                    ...emoticons.map((e) => Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  ref.read(emojiProvider.notifier).state =
                                      e.image;
                                  context.pop();
                                },
                                child: Image.asset(e.image)),
                            Btxt(text: e.emojiname)
                          ],
                        ).px8())
                  ]).px4()),
            ),
          ))));
}
