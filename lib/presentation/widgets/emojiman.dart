import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/domain/models/emotions.dart';
import 'package:MedBox/domain/sharedpreferences/sharedprefs.dart';
import 'package:MedBox/presentation/pages/renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:velocity_x/velocity_x.dart';

class EmojiChanger extends StatefulWidget {
  const EmojiChanger({super.key});

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
          title: Text(
            'Today\'s Mood',
            style: Theme.of(context).textTheme.titleSmall,
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
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ).centered(),
                    Image.asset(emoticons[emoji].image).centered(),
                    Slider(
                      activeColor: kprimary,
                      thumbColor: Colors.black26,
                      label: emoticons[emoji].emojiname,
                      value: double.parse(emoji.toString()),
                      onChanged: (e) {
                        setState(() {
                          emoji = e.floor();
                        });
                        emojicounter.value = e.floor();
                      },
                      min: 0,
                      max: 5,
                      divisions: 5,
                    ).centered(),
                    ElevatedButton(
                      onPressed: () => SharedCli()
                          .setemo(value: emoticons[emoji].image)
                          .then((v) {
                        setState(() {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const Render()));
                        });
                      }),
                      child: Center(
                        child: Text('Done',
                            style: Theme.of(context).textTheme.titleSmall),
                      ),
                    )
                  ],
                ),
              )..animate()
                  .fadeIn(duration: 800.milliseconds, delay: 500.milliseconds);
            }));
  }
}
