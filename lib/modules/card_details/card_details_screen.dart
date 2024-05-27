import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/layout/home.dart';
import 'package:call_me/models/word_model.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

List<String> myList = [];
List<String> myTransEditedList = [];

class CardDetailsScreen extends StatelessWidget {
  WordModel? model;
  CardDetailsScreen({super.key, this.model});
  late QuillController sentenceToolBarController;
  late QuillController translationToolBarController;
  final anotherSourceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    sentenceRetrievedDoc =
        Document.fromJson(model!.documentAttributes!); // get sentence doc
    translationRetrievedDoc =
        Document.fromJson(model!.transDocumentAttributes!); // get sentence doc

    sentenceToolBarController =
        AppCubit.get(context).fieldController(document: sentenceRetrievedDoc);
    translationToolBarController = AppCubit.get(context)
        .fieldController(document: translationRetrievedDoc);
    source = model!.source.toString();
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

        if (state is UpdateCardSuccessState) {
          navigateAndFinish(context, const HomeLayout());
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: isDark
                  ? const Color.fromARGB(255, 94, 84, 84)
                  : const Color.fromARGB(255, 8, 2, 2),
            ),
            title: isCursorOnSentence
                ? toolBarItem(
                    controller: sentenceToolBarController, context: context)
                : toolBarItem(
                    controller: translationToolBarController, context: context),
          ),
          body: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.size(50, context),
                      horizontal: Dimensions.size(10, context),
                    ),
                    child: Card(
                      color: isDark
                          ? const Color.fromARGB(255, 55, 50, 50)
                          : Colors.grey[200],
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
                                    itemBuilder: (context) =>
                                        sourceMenuItems(context),
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
                  ConditionalBuilder(
                    condition: state is! UpdateCardLoadingState,
                    builder: (context) => defaultButton(
                        text: 'Update',
                        onPress: () {
                          // Clicked on update after clearing sentence field is empty
                          if (sentenceToolBarController.document
                              .toPlainText()
                              .trim()
                              .isEmpty) {
                            toastMessage(message: 'Sentence is Required');
                            return;
                          }

                          if (sentenceToolBarController.document.isEmpty()) {}
                          // Clicked on update but no update has been made
                          if (model!.sentence.toString().trim() ==
                                  sentenceToolBarController.document
                                      .toPlainText()
                                      .toString()
                                      .trim() &&
                              model!.translation.toString().trim() ==
                                  translationToolBarController.document
                                      .toPlainText()
                                      .trim() &&
                              model!.source.toString().trim() == source &&
                              model!.documentAttributes!.toString().trim() ==
                                  sentenceToolBarController.document
                                      .toDelta()
                                      .toJson()
                                      .toString()
                                      .trim() &&
                              model!.transDocumentAttributes!
                                      .toString()
                                      .trim() ==
                                  translationToolBarController.document
                                      .toDelta()
                                      .toJson()
                                      .toString()
                                      .trim()) {
                            // Clicked on update but no update has been made

                            toastMessage(message: 'No Update');
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
                              }
                            }
                            // Take the translation part:
                            if (translationToolBarController.document.length >
                                1) {
                              model!.transDocumentAttributes =
                                  translationToolBarController.document
                                      .toDelta()
                                      .toJson();
                            }
                            // There is something has been updated (sentence, trans or source)
                            cubit.updateCard(
                              docId: model!.docId,
                              documentAttributes:
                                  sentenceRetrievedDoc.toDelta().toJson(),
                              editedWords: myList,
                              sentence: sentenceToolBarController.document
                                  .toPlainText(),
                              source: source,
                              transDocumentAttributes:
                                  translationToolBarController.document
                                      .toDelta()
                                      .toJson(),
                              translation: translationToolBarController.document
                                  .toPlainText(),
                            );
                          }
                        }),
                    fallback: (context) => Center(
                      child: LoadingAnimationWidget.discreteCircle(
                        color: const Color.fromARGB(255, 6, 97, 88),
                        size: Dimensions.size(20, context),
                      ),
                    ),
                  ),
                  // defaultButton(
                  //     text: 'Check',
                  //     onPress: () {
                  //       print(sentenceToolBarController.document
                  //           .toPlainText()
                  //           .trim()
                  //           .isEmpty);
                  //       // model!.transDocumentAttributes =
                  //       //     translationToolBarController.document
                  //       //         .toDelta()
                  //       //         .toJson();

                  //       //print(model!.transDocumentAttributes);

                  //       // print(model!.documentAttributes);
                  //       // print(sentenceToolBarController.document
                  //       //     .toDelta()
                  //       //     .toJson());
                  //       // List<dynamic> tester = sentenceToolBarController
                  //       //     .document
                  //       //     .toDelta()
                  //       //     .toJson();
                  //       // print(model!.documentAttributes!.toString().trim() ==
                  //       //     tester.toString().trim());
                  //       // myList = [];
                  //       // if (sentenceEditedText.isNotEmpty) {
                  //       //   for (int i = 0; i < sentenceEditedText.length; i++) {
                  //       //     if (sentenceEditedText[i]['attributes'] != null) {
                  //       //       myList.add(sentenceEditedText[i]['insert']);
                  //       //     }
                  //       //   }
                  //       // }

                  //       // print(myList);
                  //     }),

                  // TextQuill(controller: controller, focusNode: focusNode)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
