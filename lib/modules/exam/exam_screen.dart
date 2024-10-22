import 'package:call_me/generated/l10n.dart';
import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/modules/results/results_screen.dart';
import 'package:call_me/modules/sentence/add_sentence_screen.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:call_me/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../shared/constants/constants.dart';

class ExamScreen extends StatelessWidget {
  const ExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is GetEditedWordsEmptyState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Center(
                      child: Text(
                        'عفوًا ليس لديك كلمات للإختبار. هل ترغب بالكتابة الآن؟',
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 15),
                      ),
                    ),
                    actions: [
                      defaultButton(
                          text: 'نعم',
                          onPress: () =>
                              navigatTo(context, AddSentenceScreen())),
                      defaultButton(
                          text: 'لا',
                          onPress: () {
                            Navigator.pop(context);
                          })
                    ],
                  ));
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return PopScope(
          canPop: false,
          onPopInvoked: ((didPop) {
            if (isExamGenerated) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        backgroundColor: isDark ? Colors.black : Colors.white,
                        title: Center(
                          child: Text(
                            S.of(context).do_you_want_to_cancel_exam,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize: Dimensions.size(18, context)),
                          ),
                        ),
                        actions: [
                          defaultButton(
                              text: S.of(context).yes,
                              onPress: () {
                                cubit.cancelExam(context);
                              }),
                          defaultButton(
                              text: S.of(context).no,
                              onPress: () {
                                Navigator.pop(context);
                              }),
                        ],
                      ));
            }
          }),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Column(
                children: [
                  // defaultButton(
                  //     text: 'TEST Getting WORDS',
                  //     onPress: () => AppCubit.get(context).getWords()),
                  if (!isCreateExamSelected) intialExamWidget(context),
                  // English Exam in English
                  if (isCreateExamSelected && cards.isNotEmpty && isEnglishExam)
                    ConditionalBuilder(
                      condition: isExamGenerated && myExamMap.isNotEmpty,
                      builder: (context) => buildEnglishExam(context),
                      fallback: (context) => Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: LoadingAnimationWidget.inkDrop(
                                  color: Colors.green,
                                  size: Dimensions.size(40, context)),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              S.of(context).please_wait,
                              style: Theme.of(context).textTheme.bodyLarge,
                            )
                          ],
                        ),
                      ),
                    ),

                  // English Exam in Arabic
                  if (isCreateExamSelected && cards.isNotEmpty && isArabicExam)
                    ConditionalBuilder(
                      condition: isExamGenerated && myExamMap.isNotEmpty,
                      builder: (context) => buildArabicExam(context),
                      fallback: (context) => Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: LoadingAnimationWidget.inkDrop(
                                  color: Colors.green,
                                  size: Dimensions.size(40, context)),
                            ),
                            SizedBox(
                              height: Dimensions.size(7, context),
                            ),
                            Text(
                              S.of(context).please_wait,
                              style: Theme.of(context).textTheme.bodyLarge,
                            )
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnswerItem extends StatelessWidget {
  final int index;
  String answerText;
  Color color;
  AnswerItem(
      {super.key,
      required this.index,
      required this.color,
      required this.answerText});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        String correctAnswer =
            myExamMap['question ${AppCubit.get(context).currentQuestion}']
                ['correctAnswer'];
        String selectedAnswer =
            myExamMap['question ${AppCubit.get(context).currentQuestion}']
                ['answers'][index][0];
        // print(myExamMap['question ${AppCubit.get(context).currentQuestion}']
        //         ['answers']
        //     .indexOf(
        //         myExamMap['question ${AppCubit.get(context).currentQuestion}']
        //             ['answers'][index]));
        // if (isSelected) {
        //   toastMessage(message: 'Changing Answers Are Not Allowed');
        // } else {

        //     isSelected = true;

        // }
        if (isSelected) {
          // Means user has selected an answer
          toastMessage(message: 'You\'ve already answerd this question');
        } else {
          // User has not answerd yet

          AppCubit.get(context).changeAnswerColors();
          if (selectedAnswer == correctAnswer) {
            numOfCorrectAnswers++;
          } else {}
        }
      },
      child: Container(
        width: double.infinity,
        height: Dimensions.size(50, context),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(4),
            color: isSelected
                ? (myExamMap['question ${AppCubit.get(context).currentQuestion}']
                            ['answers'][index][0] ==
                        myExamMap['question ${AppCubit.get(context).currentQuestion}']
                            ['correctAnswer']
                    ? correctAnswerColor
                    : (myExamMap['question ${AppCubit.get(context).currentQuestion}']
                                    ['answers'][index][0] !=
                                myExamMap['question ${AppCubit.get(context).currentQuestion}']
                                    ['correctAnswer'] &&
                            myExamMap['question ${AppCubit.get(context).currentQuestion}']
                                        ['answers']
                                    .indexOf(myExamMap[
                                            'question ${AppCubit.get(context).currentQuestion}']
                                        ['answers'][index]) ==
                                index)
                        ? wrongAnswerColor
                        : defaultAnswerColor)
                : defaultAnswerColor),
        child: Center(
          child: Text(
            answerText,
            textAlign: TextAlign.end,
          ),
        ),
      ),
    );
  }
}
