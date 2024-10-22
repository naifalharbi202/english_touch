import 'package:audioplayers/audioplayers.dart';
import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:call_me/shared/remote/dict_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:translator/translator.dart';

extension StringCasingExtension on String {
  String capitalizeFirstOfEach() {
    return split(' ')
        .map((str) =>
            str.length > 0 ? str[0].toUpperCase() + str.substring(1) : '')
        .join(' ');
  }
}

class MyDictionaryScreen extends StatelessWidget {
  const MyDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            appBar: AppBar(),
            body: PageView.builder(
                itemCount: highlightedWords.length,
                itemBuilder: (context, index) {
                  //final wordData = cubit.wordModel!.editedWords![index];

                  return Padding(
                    padding: const EdgeInsets.all(19.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              highlightedWords[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(
                              width: Dimensions.size(5, context),
                            ),
                            if (cubit.audioUrls[index] != 'No audio available')
                              IconButton(
                                onPressed: () async {
                                  final player = AudioPlayer();

                                  await player.play(
                                    UrlSource(cubit.audioUrls[index]!),
                                  );
                                },
                                icon: const Icon(Icons.volume_up),
                              ),
                            const Spacer(),
                            Text(
                              cubit.translations[index] ?? '',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
// Display definitions and examples for each part of speech
                        for (var partOfSpeech in [
                          'noun',
                          'verb',
                          'adjective',
                          'adverb',
                          'pronoun',
                          'preposition',
                        ]) ...[
                          if (cubit.definitions[index]!
                                  .containsKey(partOfSpeech) &&
                              cubit.definitions[index]![partOfSpeech] !=
                                  null) ...[
                            Text(
                              partOfSpeech.capitalizeFirstOfEach(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            // Display the single definition
                            Text(
                              cubit.definitions[index]![partOfSpeech] ??
                                  'No definition available',
                            ),
                            const SizedBox(height: 10),

                            // Check if there are examples available
                            if (cubit.examples[index][partOfSpeech] != null &&
                                cubit.examples[index][partOfSpeech]!
                                    .isNotEmpty) ...[
                              const Text('Example(s):'),
                              // Display up to two examples
                              for (int i = 0;
                                  i <
                                          cubit.examples[index][partOfSpeech]!
                                              .length &&
                                      i < 2;
                                  i++) ...[
                                Text(
                                  cubit.examples[index][partOfSpeech]![i] ??
                                      'No example available',
                                ),
                              ],
                              const SizedBox(height: 20),
                            ],
                          ],
                        ],
                      ],
                    ),
                  );
                }),
          ),
        );
      },
    );
  }
}
