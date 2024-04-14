// DEFAULT TEXTFORMFIELD
//String charCounter = '30';

import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/models/word_model.dart';
import 'package:call_me/modules/dialouge/dialouge.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  required String text,
  required Function() onPress,
  double width = 250,
  Color color = Colors.orange,
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
Widget defaultTextFormField({
  isNotEditalble = false,
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
  void Function()? onSuffixPress,
  Color prefixIconColor = Colors.blue,
  bool expandedField = false,
}) =>
    TextFormField(
      textDirection: textDirection,
      maxLength: isThisCounter ? 30 : null,
      readOnly: isNotEditalble,
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
              ),
              onPressed: onSuffixPress),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: const OutlineInputBorder()),
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
}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 109, 53, 53),
        textColor: Colors.white,
        fontSize: 16.0);

Widget defaultItem(WordModel model, context) => Directionality(
      textDirection: TextDirection.ltr,
      child: Dismissible(
        onDismissed: (value) {
          // AppCubit.get(context)
        },
        key: UniqueKey(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            child: Card(
              color: const Color.fromARGB(255, 87, 173, 165),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    //Source Icon
                    Icon(
                      AppCubit.get(context)
                          .getSourceIcon(model.source.toString()),
                      size: Dimensions.size(40, context),
                      color: const Color.fromARGB(255, 61, 101, 149),
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
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: Dimensions.size(17, context),
                                fontWeight: FontWeight.bold),
                          ),

                          SizedBox(
                            height: Dimensions.size(10, context),
                          ),
                          // Keywords
                          if (model.editedWords!.isNotEmpty)
                            Container(
                              height: Dimensions.size(22, context),
                              width: double.infinity,
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      Text(model.editedWords![index]),
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
    );

PreferredSizeWidget defaultAppBar({required String title, context}) => AppBar(
      title: Center(
          child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      )),
      backgroundColor: Colors.teal[500],
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.teal[300],
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

Widget toolBarItem({required controller, context}) => Container(
      height: Dimensions.size(56, context),
      width: double.infinity,
      child: QuillToolbar.simple(
        configurations: QuillSimpleToolbarConfigurations(
          controller: controller,
          showHeaderStyle: false,
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
          border: Border.all(
            color: Colors.grey[400]!,
          )),
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

// 'تفاصيل إضافية (إختياري)'
//  'من وين جبتها؟'
// 'الترجمة (اختياري)'
// 'الجملة/الكلمة: (I love writing)'

// newDefaultTextField(
//                           textDirection:
//                               sentenceSourceController.text.isNotEmpty &&
//                                       regex.hasMatch(
//                                         sentenceSourceController.text[0],
//                                       )
//                                   ? TextDirection.ltr
//                                   : TextDirection.rtl,
//                           context: context,
//                           controller: sentenceController,
//                           type: TextInputType.multiline,
//                           label: 'الكلمة/العبارة',
//                           validate: (value) {
//                             return null;
//                           },
//                           onChange: (value) {
//                             if (value.length == 1) {
//                               cubit.checkTextDirection();
//                             }
//                           },
//                         ),

// PADDING CARD REMOVED CODE

/*
     Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 4.0,
                      child: Column(
                        children: [
                          //Sentence Field

                          // Test Field

                          //Translation Row
                          Row(
                            children: [
                              // Translation Field
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                10.0)),
                                  ),
                                ),
                              ),
                              ConditionalBuilder(
                                condition: state is! TranslationLoadingState,
                                builder: (context) => IconButton(
                                  onPressed: () {
                                    //Translate what is inside sentenceController
                                    cubit.translateText(
                                      sentenceController.text,
                                    );
                                  },
                                  icon: const Icon(Icons.translate_outlined),
                                ),
                                fallback: (context) => JumpingDots(),
                              ),
                            ],
                          ),
                          // Sentence source field
                          newDefaultTextField(
                            textDirection:
                                sentenceSourceController.text.isNotEmpty &&
                                        regex.hasMatch(
                                          sentenceSourceController.text[0],
                                        )
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                            context: context,
                            controller: sentenceSourceController,
                            type: TextInputType.multiline,
                            label: 'المصدر (إختياري)',
                            validate: (value) {
                              return null;
                            },
                            onChange: (value) {
                              if (value.length == 1) {
                                cubit.checkTextDirection();
                              }
                            },
                          ),
                          // More Details Field
                          newDefaultTextField(
                              textDirection:
                                  moreDetailsController.text.isNotEmpty &&
                                          regex.hasMatch(
                                              moreDetailsController.text[0])
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                              context: context,
                              controller: moreDetailsController,
                              type: TextInputType.multiline,
                              label: 'تفاصيل إضافية (إختياري)',
                              validate: (value) {
                                return null;
                              },
                              onChange: (value) {
                                if (value.length == 1) {
                                  cubit.checkTextDirection();
                                }
                              }),
                          ElevatedButton(
                            onPressed: () {
                              var editedText =
                                  quillController.document.toDelta().toJson();
                              myList = [];
                              //print('EDITED TEXT IS----- $editedText');
                              for (int i = 0; i < editedText.length; i++) {
                                if (editedText[i]['attributes'] != null) {
                                  myList.add(editedText[i]['insert']);
                                  print('HIGLIGHTED TEXT IS --- $myList');
                                }
                              }
                            },
                            child: Text('Get Highlighted'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print(myList);
                            },
                            child: Text('CHECK LIST'),
                          )
                        ],
                      ),
                    ),
                  ),*/


    // for (int i = 0; i < words.length; i++) {
    //       setState(() {
    //         start = words[i].indexOf(words[i][0]);
    //         end = words[i].indexOf(words[i][words[i].length - 1]);

    //         currentWordStart = start;
    //         currentWordEnd = end;
    //       });
    //     }