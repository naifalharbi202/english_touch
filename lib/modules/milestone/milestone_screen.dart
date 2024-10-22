import 'package:call_me/generated/l10n.dart';
import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/home.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:call_me/shared/local/cachehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as dt;
import 'package:path/path.dart';

class MileStoneScreen extends StatefulWidget {
  const MileStoneScreen({super.key});

  @override
  State<MileStoneScreen> createState() => _MileStoneScreenState();
}

class _MileStoneScreenState extends State<MileStoneScreen> {
  final TextEditingController createdNumController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  DateTime dateFrom = DateTime.now();
  DateTime dateTo = DateTime.now();
  bool isDateCorrect = false;
  List<bool> selectionToggle = [false, false, false, false, false];
  bool isAnotherNumberClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              navigateAndFinish(
                context,
                const HomeLayout(),
              );
            },
            child: Text(S.of(context).skip),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsetsDirectional.only(top: Dimensions.size(10, context)),
          child: Center(
            child: Column(
              children: [
                // WORDS NUM
                Text(
                  S.of(context).how_many_words,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(
                  height: Dimensions.size(10, context),
                ),
                SizedBox(
                  height: Dimensions.size(100, context),
                  width: Dimensions.size(150, context),
                  child: Center(
                    child: defaultTextFormField(
                        isThisCounter: true,
                        controller: createdNumController,
                        type: TextInputType.number,
                        label: '',
                        validate: (value) {
                          return null;
                        }),
                  ),
                ),
                SizedBox(
                  height: Dimensions.size(10, context),
                ),
                if (createdNumController.text.isNotEmpty)
                  Column(
                    children: [
                      Text(
                        S.of(context).learning_duration,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                            top: Dimensions.size(10, context)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.size(30, context)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: Dimensions.size(60, context),
                                      width: Dimensions.size(177, context),
                                      child: defaultTextFormField(
                                          isNotEditalble: true,
                                          onFieldPress: () {
                                            showDatePicker(
                                                    context: context,
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime(2100))
                                                .then((value) {
                                              print(value);
                                              setState(() {});
                                              fromDateController.text =
                                                  '${value!.year}-${value.month}-${value.day}';

                                              dateFrom = DateTime(value.year,
                                                  value.month, value.day);

                                              isDateCorrect = true;
                                              if (toDateController
                                                  .text.isNotEmpty) {
                                                if (dateFrom.isAfter(dateTo) ||
                                                    dateFrom.isAtSameMomentAs(
                                                        dateTo)) {
                                                  setState(() {
                                                    toastMessage(
                                                        message: langCode ==
                                                                'ar'
                                                            ? 'يرجى تحديد التاريخ بشكل صحيح'
                                                            : 'please specify the date correctly',
                                                        backgroundColor:
                                                            Colors.red);
                                                    fromDateController.text =
                                                        '';
                                                    isDateCorrect = false;
                                                    return;
                                                  });
                                                }
                                              }
                                            });
                                          },
                                          controller: fromDateController,
                                          type: TextInputType.datetime,
                                          label: S.of(context).from,
                                          validate: (value) {
                                            return null;
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.size(30, context)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: Dimensions.size(60, context),
                                      width: Dimensions.size(177, context),
                                      child: defaultTextFormField(
                                          isNotEditalble: true,
                                          onFieldPress: () {
                                            if (fromDateController
                                                .text.isEmpty) {
                                              toastMessage(
                                                message: langCode == 'ar'
                                                    ? 'اختر تاريخ البداية'
                                                    : 'Choose starting date',
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 73, 66, 43),
                                              );
                                              isDateCorrect = false;
                                              return;
                                            }
                                            showDatePicker(
                                                    context: context,
                                                    firstDate: dateFrom.add(
                                                        const Duration(
                                                            days: 1)),
                                                    lastDate: DateTime(2100))
                                                .then((value) {
                                              setState(() {
                                                toDateController.text =
                                                    '${value!.year}-${value.month}-${value.day}';
                                                //English

                                                dateTo = DateTime(value.year,
                                                    value.month, value.day);
                                                print('This is dateTo $dateTo');

                                                isDateCorrect = true;
                                              });
                                            });
                                          },
                                          controller: toDateController,
                                          type: TextInputType.datetime,
                                          label: S.of(context).to,
                                          validate: (value) {
                                            return null;
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (createdNumController.text.isNotEmpty &&
                    fromDateController.text.isNotEmpty &&
                    toDateController.text.isNotEmpty &&
                    isDateCorrect)
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).your_learning_plan,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.right,
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            '${createdNumController.text} ${S.of(context).words_in} ${dateTo.difference(dateFrom).inDays} ${S.of(context).day}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: Dimensions.size(30, context),
                          ),
                          Center(
                            child: defaultButton(
                                text: S.of(context).lets_go,
                                onPress: () {
                                  // periodOfLearning =
                                  //     dateTo.difference(dateFrom).inDays;

                                  wordsGoalCount =
                                      int.parse(createdNumController.text);

                                  //  print('dateTo:::::::: ${dateTo.month}');
                                  AppCubit.get(context).createChallenge(
                                      dateFrom,
                                      dateTo,
                                      wordsGoalCount,
                                      context);
                                }),
                          )
                        ],
                      ),
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
