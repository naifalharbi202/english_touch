import 'package:call_me/generated/l10n.dart';
import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/layout/home.dart';

import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:call_me/shared/local/cachehelper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'dart:core';

import 'package:jumping_dot/jumping_dot.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

List<String> myList = [];
String mySentence = '';
String myTranslation = '';

// ignore: must_be_immutable
class AddSentenceScreen extends StatelessWidget {
  AddSentenceScreen({super.key});

  late QuillController sentenceToolBarController;
  late QuillController translationToolBarController;
  final anotherSourceController = TextEditingController();

  //var editorKey = GlobalKey<EditorState>();

  @override
  Widget build(BuildContext context) {
    source = '';
    sentenceToolBarController =
        AppCubit.get(context).fieldController(document: AppCubit.sentenceDoc);
    translationToolBarController = AppCubit.get(context)
        .fieldController(document: AppCubit.translationDoc);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is TranslationSuccessState) {
          translationToolBarController.document =
              Document.fromDelta(Delta.fromJson(
            [
              {'insert': '${AppCubit.get(context).translatedText}\n'}
            ],
          ));

          //
        }

        if (state is GetTextFromImageSuccessState) {
          sentenceToolBarController.document =
              Document.fromDelta(Delta.fromJson(
            [
              {'insert': '$extractedText\n'}
            ],
          ));

          //
        }

        if (state is GetCardsSuccessState) {
          navigateAndFinish(context, const HomeLayout());
          Future.delayed(const Duration(seconds: 1), () {
            sentenceToolBarController.clear();
            translationToolBarController.clear();
          });
          // Shows Error Here
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            navigateAndFinish(context, const HomeLayout());
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor:
                  isDark ? const Color.fromARGB(31, 102, 96, 96) : Colors.white,
              elevation: 5,
              title: isCursorOnSentence
                  ? toolBarItem(
                      controller: sentenceToolBarController, context: context)
                  : toolBarItem(
                      controller: translationToolBarController,
                      context: context),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Main Card
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.size(50, context),
                      horizontal: Dimensions.size(10, context),
                    ),
                    child: Card(
                      color: isDark
                          ? const Color.fromARGB(31, 139, 133, 133)
                          : Colors.white,
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            //Sentence Field
                            TextQuill(
                              focusNode: focusNode1,
                              controller: sentenceToolBarController,
                              placeHolder: 'Write your sentence!',
                            ),
                            SizedBox(
                              height: Dimensions.size(10, context),
                            ),
                            //Translation Row
                            Row(
                              children: [
                                // Translation Field
                                Expanded(
                                  child: TextQuill(
                                    focusNode: focusNode2,
                                    controller: translationToolBarController,
                                    placeHolder: 'Translate',
                                  ),
                                ),
                                ConditionalBuilder(
                                  condition: state is! TranslationLoadingState,
                                  builder: (context) => IconButton(
                                    onPressed: () {
                                      // Translate what is inside sentenceController
                                      cubit.translateText(
                                          sentenceToolBarController.document
                                              .toPlainText());
                                    },
                                    icon: const Icon(Icons.translate_outlined),
                                  ),
                                  fallback: (context) => JumpingDots(),
                                ),
                              ],
                            ),
                            // Sentence source field
                            SizedBox(
                              height: Dimensions.size(20, context),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  //sources menu
                                  child: PopupMenuButton(
                                    initialValue: source,
                                    elevation: 3,
                                    onSelected: (value) {
                                      if (value == 'DiffSource') {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  backgroundColor: isDark
                                                      ? const Color.fromARGB(
                                                          255, 55, 50, 50)
                                                      : Colors.grey[200],
                                                  content: Container(
                                                    height: Dimensions.size(
                                                        59, context),
                                                    width: Dimensions.size(
                                                        80, context),
                                                    child: TextFormField(
                                                      maxLines: 1,
                                                      maxLength: 10,
                                                      controller:
                                                          anotherSourceController,
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        if (anotherSourceController
                                                            .text.isNotEmpty) {
                                                          anotherSourceController
                                                              .text = '';
                                                        }
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(S
                                                          .of(context)
                                                          .canncel),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        if (anotherSourceController
                                                            .text
                                                            .trim()
                                                            .isEmpty) {
                                                          toastMessage(
                                                              message:
                                                                  'لايوجد إدخال');
                                                        }

                                                        if (anotherSourceController
                                                            .text
                                                            .trim()
                                                            .isNotEmpty) {
                                                          if (cachedSources.contains(
                                                              anotherSourceController
                                                                  .text
                                                                  .trim())) {
                                                            toastMessage(
                                                                message:
                                                                    'عفواً المصدر موجود مسبقًا');
                                                            return;
                                                          }
                                                          // Take what's written and send it to firebase
                                                          cubit.changeSourceLabel(
                                                              anotherSourceController
                                                                  .text);
                                                          // Add what was written in other sources in list
                                                          cachedSources.add(
                                                              anotherSourceController
                                                                  .text);

                                                          // Save other sources in cache
                                                          CacheHelper.saveData(
                                                                  key:
                                                                      'otherSources',
                                                                  value:
                                                                      cachedSources)
                                                              .then((value) {
                                                            // Go back when saved
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        }
                                                      },
                                                      child: Text(S
                                                          .of(context)
                                                          .confirm),
                                                    ),
                                                  ],
                                                ));
                                      } else {
                                        if (value
                                            .toString()
                                            .trim()
                                            .isNotEmpty) {
                                          cubit.changeSourceLabel(value);
                                        }
                                      }
                                    },
                                    popUpAnimationStyle: AnimationStyle(
                                        curve: Curves.easeInCirc),
                                    itemBuilder: (context) =>
                                        sourceMenuItems(context),
                                    child: Chip(
                                      label: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        textBaseline: TextBaseline.ideographic,
                                        children: [
                                          Text(
                                            source.isEmpty == true
                                                ? S.of(context).source
                                                : source,
                                            style: const TextStyle(
                                              fontFamily: 'Cairo',
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Icon(
                                            source.isEmpty == true
                                                ? Icons.add
                                                : Icons.check,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      side: BorderSide.none,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: Colors.teal,
                                    ),
                                  ),
                                ),
                                if (source.isNotEmpty)
                                  TextButton(
                                    onPressed: () {
                                      cubit.changeSourceLabel('');
                                    },
                                    child: Text(
                                      S.of(context).remove_source,
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            // Check if there are already added other sources
                            if (CacheHelper.getData('otherSources') != null)
                              Container(
                                height: 50,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => TextButton(
                                    onLongPress: () {
                                      // Delete Source

                                      showAdaptiveDialog(
                                          context: context,
                                          builder: (context) => Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: AlertDialog(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          if (source ==
                                                              cachedSources[
                                                                  index]) {
                                                            source = '';
                                                          }
                                                          cachedSources.remove(
                                                              cachedSources[
                                                                  index]);

                                                          // Save updated version of cachedSourced
                                                          CacheHelper.saveData(
                                                                  key:
                                                                      'otherSources',
                                                                  value:
                                                                      cachedSources)
                                                              .then((value) {
                                                            cubit
                                                                .updateCachedSources();
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                          if (cachedSources
                                                              .isEmpty) {
                                                            CacheHelper.removeData(
                                                                'otherSources');
                                                          }
                                                        },
                                                        child: const Text(
                                                            'حذف المصدر'),
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            // if selected source was one of deleted cachedSources elements
                                                            for (int i = 0;
                                                                i <
                                                                    cachedSources
                                                                        .length;
                                                                i++) {
                                                              if (source ==
                                                                  cachedSources[
                                                                      i]) {
                                                                source = '';
                                                                break;
                                                              }
                                                            }
                                                            cachedSources
                                                                .clear();

                                                            CacheHelper.removeData(
                                                                    'otherSources')
                                                                .then((value) {
                                                              cubit
                                                                  .updateCachedSources();
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          child: const Text(
                                                              'حذف جميع المصادر')),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                      // Update Cache
                                    },
                                    onPressed: () {
                                      cubit.changeSourceLabel(
                                          cachedSources[index]);
                                    },
                                    child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Text(
                                        '#${cachedSources[index]}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                color: const Color.fromARGB(
                                                    255, 108, 194, 178)),
                                      ),
                                    ),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    width: 2,
                                  ),
                                  itemCount: cachedSources.length,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Add text button
                  ConditionalBuilder(
                    condition: state is! AddCardLoadingState,
                    builder: (context) => Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.size(10, context)),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Check if any char has been written
                            if (sentenceToolBarController.document.length <=
                                    1 ||
                                sentenceToolBarController.document
                                    .toPlainText()
                                    .trim()
                                    .isEmpty) {
                              toastMessage(
                                  message: S.of(context).sentence_required);
                            } else {
                              var sentenceEditedText = sentenceToolBarController
                                  .document
                                  .toDelta()
                                  .toJson();

                              myList = [];
                              // Check for edited words
                              if (sentenceEditedText.isNotEmpty) {
                                for (int i = 0;
                                    i < sentenceEditedText.length;
                                    i++) {
                                  if (sentenceEditedText[i]['attributes'] !=
                                      null) {
                                    myList.add(sentenceEditedText[i]['insert']);

                                    if (retrievedWords.isNotEmpty) {
                                      retrievedWords
                                          .add(sentenceEditedText[i]['insert']);
                                    }
                                  }
                                  mySentence = sentenceToolBarController
                                      .document
                                      .toPlainText();

                                  if (retrievedSentences.isNotEmpty) {
                                    retrievedSentences.add(mySentence);
                                    print(retrievedSentences);
                                  }

                                  myTranslation = translationToolBarController
                                      .document
                                      .toPlainText();
                                }
                                // Now take what's written in sentence and other fields (if filled)

                                cubit.addCard(
                                    sentence: mySentence,
                                    translation: myTranslation,
                                    editedWords: myList,
                                    pickedSource: source,
                                    docAttributrs: sentenceToolBarController
                                        .document
                                        .toDelta()
                                        .toJson(),
                                    transDocAttributrs:
                                        translationToolBarController.document
                                            .toDelta()
                                            .toJson());
                              }
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.teal)),
                          child: Text(
                            S.of(context).add,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                    fallback: (context) => Center(
                      child: LoadingAnimationWidget.discreteCircle(
                        color: const Color.fromARGB(255, 6, 97, 88),
                        size: Dimensions.size(20, context),
                      ),
                    ),
                  ),

                  // Add image to text button
                  TextButton(
                      onPressed: () {
                        cubit.getImage(context);

                        //         .asUint8List();
                      },
                      child: Text(
                        S.of(context).extract_text,
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: Color.fromARGB(255, 57, 185, 189)),
                      )),
                  SizedBox(
                    height: Dimensions.size(10, context),
                  ),
                  // Extracted Text
                  if (isImagePicked)
                    ConditionalBuilder(
                        condition: state is! GetTextFromImageLoadingState,
                        builder: (context) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color.fromARGB(
                                        255, 232, 229, 219)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text(
                                      extractedText,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        fallback: (contetxt) => Center(
                              child: LoadingAnimationWidget.beat(
                                  color: Colors.amber,
                                  size: Dimensions.size(20, context)),
                            )),

                  // if (cubit.image != null)
                  //   Image.file(
                  //     cubit.image!,
                  //     height: 100,
                  //     width: 100,
                  //   ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
