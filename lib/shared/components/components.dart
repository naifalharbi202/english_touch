// DEFAULT TEXTFORMFIELD
//String charCounter = '30';

// ignore_for_file: sized_box_for_whitespace

import 'package:call_me/generated/l10n.dart';
import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/models/word_model.dart';
import 'package:call_me/modules/card_details/card_details_screen.dart';

import 'package:call_me/modules/dialouge/dialouge.dart';
import 'package:call_me/modules/exam/exam_screen.dart';
import 'package:call_me/modules/results/results_screen.dart';
import 'package:call_me/modules/search/search_screen.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/dimentions.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  required String text,
  required Function() onPress,
  double width = 250,
  Color color = const Color.fromARGB(255, 9, 58, 48),
  ShapeBorder shape = const StadiumBorder(),
}) =>
    Container(
      width: width,
      child: MaterialButton(
        onPressed: onPress,
        color: color,
        textColor: Colors.white,
        shape: shape,
        elevation: 5.0,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

// Old default
Widget defaultTextFormField(
        {isNotEditalble = false,
        required TextEditingController controller,
        required TextInputType type,
        required String label,
        required FormFieldValidator<String>? validate,
        void Function()? onFieldPress,
        void Function(String)? onChange,
        void Function(String)? onFieldSubmitted,
        IconData? prefixIcon,
        IconData? suffixIcon,
        FocusNode? focusNode,
        bool isPassword = false,
        bool isThisCounter = false,
        TextStyle? style,
        TextDirection? textDirection,
        void Function()? onSuffixPress,
        Color prefixIconColor = Colors.blue,
        bool expandedField = false,
        bool isSearchField = false,
        TextInputAction? textInputAction}) =>
    TextFormField(
      textDirection: textDirection,
      focusNode: focusNode,
      maxLength: isThisCounter ? 30 : null,
      readOnly: isNotEditalble,
      textInputAction: textInputAction,
      maxLines: expandedField ? null : 1,
      style: style,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChange,
      validator: validate,
      controller: controller,
      onTap: onFieldPress,
      keyboardType: type,
      obscureText: isPassword,
      decoration: InputDecoration(
          isDense: true,
          labelText: label,
          prefixIcon: Icon(
            prefixIcon,
            color: prefixIconColor,
          ),
          suffixIcon: IconButton(
              icon: Icon(
                suffixIcon,
                color: isDark
                    ? const Color.fromARGB(255, 103, 95, 95)
                    : const Color.fromARGB(255, 84, 78, 78),
              ),
              onPressed: onSuffixPress),
          enabledBorder: OutlineInputBorder(
            borderSide: isSearchField
                ? BorderSide.none
                : const BorderSide(
                    color: Colors.grey,
                  ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          border:
              isSearchField ? InputBorder.none : const OutlineInputBorder()),
    );

void navigatTo(context, Widget destination) => Navigator.push(
    context, MaterialPageRoute(builder: (context) => destination));

//Will nav to next screen but without back arrow
void navigateAndFinish(context, newRoute) => Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => newRoute), (route) {
      return false;
    });

void toastMessage({
  required String message,
  Color? backgroundColor = const Color.fromARGB(255, 27, 98, 11),
}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: Colors.white,
        fontSize: 16.0);
Widget defaultItem(WordModel model, context) => Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: () {
          //Go To Card Page
          navigatTo(
              context,
              CardDetailsScreen(
                model: model,
              ));
        },
        child: Dismissible(
          background: Container(
            color: const Color.fromARGB(255, 153, 69, 69),
            child: Row(
              children: [
                Icon(
                  Icons.delete,
                  size: Dimensions.size(30, context),
                ).animate().tint(color: Colors.white).then().shimmer(
                    duration: const Duration(seconds: 3), color: Colors.red),
              ],
            ),
          ),
          onDismissed: (direction) {
            // This is called when card is fully dismissed
            if (retrievedSentences.contains(model.sentence)) {
              retrievedSentences.remove(model.sentence);
            }

            AppCubit.get(context).deleteCard(docId: model.docId);
          },
          key: UniqueKey(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: Card(
                color: const Color.fromARGB(255, 40, 127, 118),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      //Source Icon
                      Icon(
                        AppCubit.get(context)
                            .getSourceIcon(model.source.toString()),
                        size: Dimensions.size(40, context),
                        color: const Color.fromARGB(255, 16, 67, 50),
                      ),
                      SizedBox(
                        width: Dimensions.size(10, context),
                      ),
                      //Sentence and keywords

                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sentence
                            Text(
                              model.sentence.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            ),

                            SizedBox(
                              height: Dimensions.size(10, context),
                            ),
                            // Keywords
                            if (model.editedWords!.isNotEmpty)
                              Container(
                                height: Dimensions.size(27, context),
                                width: double.infinity,
                                child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => Text(
                                          model.editedWords![index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  fontSize:
                                                      fontSelectedSize - 2,
                                                  color: Colors.black),
                                        ),
                                    separatorBuilder: (context, index) =>
                                        const Text(','),
                                    itemCount: model.editedWords!.length),
                              )
                          ],
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.play_circle_filled_sharp,
                            color: const Color.fromARGB(255, 180, 219, 211),
                            size: Dimensions.size(30, context),
                          ),
                          onPressed: () {
                            isSpeakOn = true;

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return TrackingText(
                                      text: model.sentence.toString());
                                }).then((value) {
                              AppCubit.get(context).flutterTts.stop();
                              currentWordStart = 0;
                              currentWordEnd = 0;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

PreferredSizeWidget defaultAppBar({required String title, context}) => AppBar(
      actions: [
        IconButton(
            onPressed: () {
              navigatTo(context, SearchScreen());
            },
            icon: const Icon(Icons.search))
      ],
      centerTitle: true,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      backgroundColor:
          isDark ? const Color.fromARGB(255, 15, 100, 91) : Colors.teal[500],
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor:
            isDark ? const Color.fromARGB(255, 25, 121, 111) : Colors.teal[300],
      ),
    );

// new default text form field (English App)

Widget newDefaultTextField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required FormFieldValidator<String>? validate,
  void Function()? onFieldPress,
  void Function(String)? onChange,
  void Function(String)? onFieldSubmitted,
  IconData? prefixIcon,
  IconData? suffixIcon,
  bool isPassword = false,
  bool isThisCounter = false,
  TextStyle? style,
  TextDirection? textDirection,
  List<TextInputFormatter>? inputFormatters,
  TextAlign textAlign = TextAlign.start,
  void Function()? onSuffixPress,
  required BuildContext context,
}) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: TextFormField(
          textAlign: textAlign,
          inputFormatters: inputFormatters,
          onFieldSubmitted: onFieldSubmitted,
          keyboardType: type,
          decoration: InputDecoration(
              hintText: label,
              prefixIcon: Icon(
                prefixIcon,
              ),
              suffixIcon: IconButton(
                  icon: Icon(
                    suffixIcon,
                  ),
                  onPressed: onSuffixPress),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              )),
          maxLines: null,
          enabled: true,
          textDirection: textDirection,
          controller: controller,
          style: const TextStyle(fontFamily: 'Cairo'),
          onChanged: onChange,
        ),
      ),
    );

Widget toolBarItem({required controller, context}) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: Dimensions.size(56, context),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: QuillToolbar.simple(
            configurations: QuillSimpleToolbarConfigurations(
              controller: controller,
              showHeaderStyle: false,
              color: isDark
                  ? Color.fromARGB(255, 193, 179, 179)
                  : const Color.fromARGB(255, 248, 248, 248),
              showDividers: false,
              showFontFamily: false,
              showFontSize: false,
              showItalicButton: true,
              showSmallButton: false,
              showUnderLineButton: true,
              showStrikeThrough: false,
              showBoldButton: true,
              showInlineCode: false,
              showColorButton: true,
              showBackgroundColorButton: true,
              showClearFormat: false,
              showAlignmentButtons: true,
              showLeftAlignment: true,
              showCenterAlignment: true,
              showRightAlignment: true,
              showJustifyAlignment: true,
              showListNumbers: false,
              showListBullets: true,
              showListCheck: true,
              showCodeBlock: false,
              showQuote: true,
              showIndent: true,
              showLink: false,
              showUndo: true,
              showRedo: true,
              showDirection: false,
              showSearchButton: false,
              showSubscript: false,
              showSuperscript: false,
              multiRowsDisplay: false,
            ),
          ),
        ),
      ),
    );

bool isCursorOnSentence = false;
FocusNode focusNode1 = FocusNode();
FocusNode focusNode2 = FocusNode();
// ignore: non_constant_identifier_names
Widget TextQuill({
  required QuillController controller,
  required FocusNode focusNode,
  String? placeHolder,
  GlobalKey<EditorState>? editorKey,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: QuillEditor.basic(
          focusNode: focusNode,
          configurations: QuillEditorConfigurations(
              editorKey: editorKey,
              placeholder: placeHolder,
              controller: controller,
              showCursor: true),
        ),
      ),
    );

// ignore: non_constant_identifier_names
Widget MenuItems() => Column(
      children: [
        Container(
          height: 50,
          color: Colors.amber,
        ),
        Container(
          height: 50,
          color: Colors.red,
        ),
        Container(
          height: 50,
          color: Colors.green,
        ),
      ],
    );
int resultItemIndex = 1;
// ignore: non_constant_identifier_names
Widget ResultItem(index, context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '- ${myExamMap['question ${index == 0 ? 1 : ++index}']['question']}',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: Dimensions.size(5, context),
          ),
          Text(
            '${myExamMap['question ${index == 0 ? 1 : index}']['correctAnswer'] == 'A' ? myExamMap['question ${index == 0 ? 1 : index}']['answers'][0].substring(
                2,
              ) : myExamMap['question ${index == 0 ? 1 : index}']['correctAnswer'] == 'B' ? myExamMap['question ${index == 0 ? 1 : index}']['answers'][1].substring(
                2,
              ) : myExamMap['question ${index == 0 ? 1 : index}']['answers'][2].substring(
                2,
              )}',
            style: TextStyle(
                color: isDark ? Colors.green : Color.fromARGB(255, 17, 99, 35)),
          )
        ],
      ),
    );

Widget intialExamWidget(
  context,
) =>
    Expanded(
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
                onPressed: () {
                  if (cards.isEmpty) {
                    AppCubit.get(context).getWords();
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              backgroundColor: isDark
                                  ? const Color.fromARGB(31, 102, 96, 96)
                                  : Colors.white,
                              title: Center(
                                  child: Text(S.of(context).choose_lang_exam,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontSize: Dimensions.size(
                                                  18, context)))),
                              actions: [
                                defaultButton(
                                    text: 'EN',
                                    color:
                                        const Color.fromARGB(255, 10, 87, 79),
                                    onPress: () {
                                      isCreateExamSelected = true;
                                      isComingFromResults = false;
                                      isEnglishExam = true;
                                      isArabicExam = false;
                                      AppCubit.get(context).getWords();
                                      Navigator.pop(context);
                                    }),
                                defaultButton(
                                    text: 'عربي',
                                    color: Colors.teal,
                                    onPress: () {
                                      isCreateExamSelected = true;
                                      isComingFromResults = false;
                                      isEnglishExam = false;
                                      isArabicExam = true;
                                      AppCubit.get(context).getWords();
                                      Navigator.pop(context);
                                    }),
                              ],
                            ));
                  }
                },
                icon: const Icon(Icons.pinch_rounded),
                label: isComingFromResults && cards.isNotEmpty
                    ? Text(
                        S.of(context).create_another_exam,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    : Text(
                        S.of(context).create_exam,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )),
          ],
        ),
      ),
    );

Widget buildEnglishExam(context) => Expanded(
      child: Column(
        children: [
          Text(
            textAlign: TextAlign.center,
            '${myExamMap['question ${AppCubit.get(context).currentQuestion}']['question']}',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: Dimensions.size(18, context),
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: Dimensions.size(30, context),
          ),
          Expanded(
            flex: 3,
            child: ListView.separated(
                itemBuilder: (context, index) => AnswerItem(
                      index: index,
                      color: Colors.white,
                      answerText:
                          '${myExamMap['question ${AppCubit.get(context).currentQuestion}']['answers'][index]}',
                    ),
                separatorBuilder: (context, index) => SizedBox(
                      height: Dimensions.size(10, context),
                    ),
                itemCount: 3),
          ),
          currentQuestionNum < myExamMap.length
              ? defaultButton(
                  text: 'Next $currentQuestionNum / ${myExamMap.length}',
                  onPress: () {
                    if (isSelected) {
                      AppCubit.get(context)
                          .goToNextQuestion(++currentQuestionNum);
                    } else {
                      toastMessage(message: 'Are you afraid of answering?');
                    }
                  })
              : isSelected
                  ? defaultButton(
                      text: 'CHECK ANSWERS',
                      onPress: () {
                        isExamGenerated = false;
                        isCreateExamSelected = false;
                        isEnglishExam = false;
                        isArabicExam = false;
                        navigatTo(context, const ExamResults());
                      })
                  : const SizedBox(),
        ],
      ),
    );

Widget buildArabicExam(context) => Expanded(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Text(
              textAlign: TextAlign.center,
              '${myExamMap['question ${AppCubit.get(context).currentQuestion}']['question']}',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: Dimensions.size(30, context),
            ),
            Expanded(
              flex: 3,
              child: ListView.separated(
                  itemBuilder: (context, index) => Directionality(
                        textDirection: TextDirection.ltr,
                        child: AnswerItem(
                          index: index,
                          color: Colors.white,
                          answerText:
                              '${myExamMap['question ${AppCubit.get(context).currentQuestion}']['answers'][index]}',
                        ),
                      ),
                  separatorBuilder: (context, index) => SizedBox(
                        height: Dimensions.size(10, context),
                      ),
                  itemCount: 3),
            ),
            currentQuestionNum < myExamMap.length
                ? defaultButton(
                    text: 'Next $currentQuestionNum / ${myExamMap.length}',
                    onPress: () {
                      if (isSelected) {
                        AppCubit.get(context)
                            .goToNextQuestion(++currentQuestionNum);
                      } else {
                        toastMessage(message: 'خائف من الإجابة؟');
                      }
                    })
                : isSelected
                    ? defaultButton(
                        text: 'CHECK ANSWERS',
                        onPress: () {
                          isExamGenerated = false;
                          isCreateExamSelected = false;
                          isEnglishExam = false;
                          isArabicExam = false;
                          navigatTo(context, const ExamResults());
                        })
                    : const SizedBox(),
          ],
        ),
      ),
    );
