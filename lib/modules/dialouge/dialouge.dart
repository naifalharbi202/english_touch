import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:flutter/material.dart';

class TrackingText extends StatefulWidget {
  final String text; // when we call this class we will pass a text
  const TrackingText({super.key, required this.text});

  @override
  State<TrackingText> createState() => _TrackingTextState();
}

class _TrackingTextState extends State<TrackingText> {
  @override
  void initState() {
    super.initState();
    AppCubit.get(context).initVoices();

    speak(widget.text, context);
  }

  String wordSpoken = '';
  int currentIndex = 0;
  int currentWordIndex = 0;

  // method will be called when speak is on
  Future speak(myText, context) async {
    AppCubit.get(context)
        .flutterTts
        .setProgressHandler((text, start, end, word) {
      text = widget.text;

      setState(() {
        currentWordStart = start; // PAUSE BUG //
        currentWordEnd = end;

        if (currentWordEnd == widget.text.length - 1 ||
            currentWordEnd == widget.text.length - 2) {
          isSpeakOn = false;
        }
      });
    });

    await AppCubit.get(context).flutterTts.speak(myText);
    //
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: AlertDialog(
              backgroundColor: isDark
                  ? const Color.fromARGB(255, 55, 50, 50)
                  : Colors.grey[200],
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    // highlightWord(currentWordIndex),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge,
                              children: <TextSpan>[
                                TextSpan(
                                    text: widget.text
                                        .toString()
                                        .substring(0, currentWordStart)),
                                if (currentWordStart != null)
                                  TextSpan(
                                    text: widget.text.toString().substring(
                                        currentWordStart!, currentWordEnd),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        backgroundColor: Colors.amber),
                                  ),
                                if (currentWordEnd != null)
                                  TextSpan(
                                    text: widget.text
                                        .toString()
                                        .substring(currentWordEnd!),
                                  ),
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // BottomNavigation Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: BottomNavigationBar(
                backgroundColor: isDark
                    ? const Color.fromARGB(255, 88, 82, 82)
                    : const Color.fromARGB(255, 232, 217, 217),
                currentIndex: currentIndex,
                onTap: (index) {
                  // Here You make the logic of on press

                  setState(() {
                    currentIndex = index;

                    if (index == 1) {
                      if (isSpeakOn) {
                        AppCubit.get(context).flutterTts.pause();
                        setState(() {
                          isSpeakOn = false;
                        });
                      } else {
                        if (widget.text.isNotEmpty) {
                          for (int i = 0;
                              i < widget.text.substring(wordsCounter).length;
                              i++) {
                            words =
                                widget.text.substring(wordsCounter).split(' ');
                          }

                          speak(widget.text.substring(wordsCounter), context);
                          setState(() {
                            isSpeakOn = true;
                          });
                        }
                      }
                    }
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.fast_rewind,
                      size: Dimensions.size(25, context),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: isSpeakOn
                        ? const Icon(Icons.pause_circle_outline_outlined)
                        : const Icon(Icons.play_circle_outline_outlined),
                    label: '',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.replay,
                    ),
                    label: '',
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
