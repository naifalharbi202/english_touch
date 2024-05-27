import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/home.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:flutter/material.dart';

class ExamResults extends StatelessWidget {
  const ExamResults({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        retrievedWords = [];
        retrievedSentences = [];
        AppCubit.get(context).currentQuestion = 1;
        currentQuestionNum = 1;
        myExamMap = {};
        isComingFromResults = true;
        isSelected = false;

        navigateAndFinish(
          context,
          const HomeLayout(),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'RESULTS',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          leading: BackButton(
            color: isDark ? Colors.white : Colors.black,
            onPressed: () {
              retrievedWords = [];
              retrievedSentences = [];
              AppCubit.get(context).currentQuestion = 1;
              currentQuestionNum = 1;
              myExamMap = {};
              isComingFromResults = true;
              isSelected = false;

              navigateAndFinish(
                context,
                const HomeLayout(),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color:
                isDark ? const Color.fromARGB(31, 102, 96, 96) : Colors.white,
            child: Column(
              children: [
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        ResultItem(index++, context),
                    separatorBuilder: (context, index) => Container(
                          height: 1,
                          color: isDark
                              ? const Color.fromARGB(255, 103, 94, 94)
                              : Colors.grey[300],
                        ),
                    itemCount: myExamMap.length),
                SizedBox(
                  height: Dimensions.size(10, context),
                ),
                Card(
                  color: Colors.amber,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        ' ${numOfCorrectAnswers == 0 ? 'Zero correct answers' : numOfCorrectAnswers == 1 ? 'You have answerd $numOfCorrectAnswers question' : 'You have answerd $numOfCorrectAnswers questions'}'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// If you want to show all answers

       // Text(
        //   '${myExamMap['question ${index == 0 ? 1 : index}']['answers'][0]}',
        // ),
        // Text(
        //     '${myExamMap['question ${index == 0 ? 1 : index}']['answers'][1]}'),
        // Text(
        //     '${myExamMap['question ${index == 0 ? 1 : index}']['answers'][2]}'),