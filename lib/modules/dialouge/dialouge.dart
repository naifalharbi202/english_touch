import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
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
    toastMessage(message: 'init');
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
        start = currentWordStart = start;
        currentWordEnd = end;
      });
    });

    AppCubit.get(context).flutterTts.setPauseHandler(() {
      currentWordStart = null;
      currentWordEnd = null;
    });

    await AppCubit.get(context).flutterTts.speak(myText);
    //
  }

  Widget highlightWord(int index) {
    // if (index < 0 || index >= widget.text.split(' ').length)
    //   return; // Handle edge cases

    final words = widget.text.split(' ');
    final highlightedText = RichText(
      text: TextSpan(
        children: [
          for (int i = 0; i < words.length; i++)
            TextSpan(
              text: words[i] + (i != words.length - 1 ? ' ' : ''), // Add spaces
              style: i == index
                  ? const TextStyle(
                      color: Colors.yellow, fontWeight: FontWeight.bold)
                  : const TextStyle(color: Colors.black),
            ),
        ],
      ),
    );

    return highlightedText;
    // Update your UI to display the highlightedText
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          // highlightWord(currentWordIndex),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.w200,
                    fontFamily: 'Cairo',
                    color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: widget.text
                          .toString()
                          .substring(0, currentWordStart)),
                  if (currentWordStart != null)
                    TextSpan(
                      text: widget.text
                          .toString()
                          .substring(currentWordStart!, currentWordEnd),
                      style: const TextStyle(
                          color: Colors.white, backgroundColor: Colors.amber),
                    ),
                  if (currentWordEnd != null)
                    TextSpan(
                      text: widget.text.toString().substring(currentWordEnd!),
                    ),
                ]),
          ),
          Spacer(),
          BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    color: const Color.fromARGB(255, 220, 159, 46),
                    child: IconButton(
                      icon: const Icon(Icons.fast_rewind),
                      onPressed: () {},
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: IconButton(
                    icon: const Icon(Icons.pause_circle_outline_outlined),
                    onPressed: () async {
                      if (isSpeakOn) {
                        AppCubit.get(context).flutterTts.pause();
                        isSpeakOn = false;
                        toastMessage(message: 'IT\'s $isSpeakOn');
                      } else {
                        if (widget.text.isNotEmpty) {
                          for (int i = 0;
                              i < widget.text.substring(wordsCounter).length;
                              i++) {
                            words =
                                widget.text.substring(wordsCounter).split(' ');
                          }

                          await speak(
                              widget.text.substring(wordsCounter), context);

                          isSpeakOn = true;
                        }
                      }
                    },
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: IconButton(
                    icon: const Icon(Icons.replay),
                    onPressed: () {
                      toastMessage(message: wordsCounter.toString());
                    },
                  ),
                  label: '',
                ),
              ])
        ],
      ),
    );
  }
}
