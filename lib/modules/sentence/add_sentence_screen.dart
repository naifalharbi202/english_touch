import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/layout/home.dart';

import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'dart:core';

import 'package:jumping_dot/jumping_dot.dart';

List<String> myList = [];
String mySentence = '';
String myTranslation = '';

// ignore: must_be_immutable
class AddSentenceScreen extends StatelessWidget {
  AddSentenceScreen({super.key});

  final regex = RegExp(r'^[a-zA-Z0-9\s]+$');
  late QuillController sentenceToolBarController;
  late QuillController translationToolBarController;
  final anotherSourceController = TextEditingController();
  //var editorKey = GlobalKey<EditorState>();

  @override
  Widget build(BuildContext context) {
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

        if (state is GetCardsSuccessState) {
          navigatTo(context, const HomeLayout());
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 5,
              title: AppCubit.isCursorOnSentence
                  ? toolBarItem(
                      controller: sentenceToolBarController, context: context)
                  : toolBarItem(
                      controller: translationToolBarController,
                      context: context)),
          body: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  // Main Card
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.size(50, context),
                      horizontal: Dimensions.size(10, context),
                    ),
                    child: Card(
                      color: Colors.white,
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            //Sentence Field
                            TextQuill(
                              focusNode: focusNode1,
                              controller: sentenceToolBarController,
                              placeHolder: '  Write your sentence!',
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
                                                      child:
                                                          const Text('إلغاء'),
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
                                                          // Take what's written and send it to firebase
                                                          cubit.changeSourceLabel(
                                                              anotherSourceController
                                                                  .text);
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      child:
                                                          const Text('تأكيد'),
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
                                    itemBuilder: (context) => sourceMenuItems,
                                    child: Chip(
                                      label: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        textBaseline: TextBaseline.ideographic,
                                        children: [
                                          Text(
                                            source.isEmpty == true
                                                ? 'مصدر'
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
                                    child: const Text(
                                      'إزالة المصدر',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Add button
                  Padding(
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
                          if (sentenceToolBarController.document.length <= 1) {
                            toastMessage(message: 'يجب كتابة الجملة');
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
                                }
                                mySentence = sentenceToolBarController.document
                                    .toPlainText();

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
                              );
                            }
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.teal)),
                        child: const Text(
                          'إضافة',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     cubit.getCards();
                  //   },
                  //   child: Text('Get'),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
