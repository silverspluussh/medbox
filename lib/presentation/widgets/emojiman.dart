import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/constants/fonts.dart';
import 'package:MedBox/domain/models/emotions.dart';
import 'package:MedBox/domain/sharedpreferences/sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:velocity_x/velocity_x.dart';

class EmojiChanger extends StatefulWidget {
  const EmojiChanger({Key key}) : super(key: key);

  @override
  State<EmojiChanger> createState() => _EmojiChangerState();
}

class _EmojiChangerState extends State<EmojiChanger> {
  final emojicounter = ValueNotifier<int>(0);
  @override
  void dispose() {
    emojicounter.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Today\'s Mood',
            style: popheaderB,
          ),
        ),
        body: ValueListenableBuilder(
            valueListenable: emojicounter,
            builder: (context, emoji, _) {
              return Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                    color: emoji == 0
                        ? const Color.fromARGB(255, 252, 181, 248)
                        : emoji == 1
                            ? const Color.fromARGB(225, 199, 123, 123)
                            : emoji == 2
                                ? const Color.fromARGB(255, 184, 217, 240)
                                : emoji == 3
                                    ? const Color.fromARGB(255, 248, 85, 85)
                                    : emoji == 4
                                        ? const Color.fromARGB(
                                            255, 240, 225, 94)
                                        : const Color.fromARGB(
                                            255, 136, 248, 92)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      emoticons[emoji].description,
                      style: const TextStyle(
                          fontFamily: 'Pop',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ).centered(),
                    Image.asset(emoticons[emoji].image).centered(),
                    Slider(
                      activeColor: AppColors.primaryColor,
                      thumbColor: Colors.black26,
                      label: emoticons[emoji].emojiname,
                      value: double.parse(emoji.toString()),
                      onChanged: (e) {
                        emoji = e.floor();
                        emojicounter.value = e.floor();
                      },
                      min: 0,
                      max: 5,
                      divisions: 5,
                    ).centered(),
                    InkWell(
                      onTap: () => SharedCli()
                          .setemo(value: emoticons[emojicounter.value])
                          .then((value) => context.pop()),
                      child: Container(
                          height: 50,
                          width: size.width - 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.primaryColor),
                          child: const Center(
                            child: Text('Add vitals', style: popwhite),
                          )),
                    )
                  ],
                ),
              )..animate()
                  .fadeIn(duration: 800.milliseconds, delay: 500.milliseconds);
            }));
  }
}
