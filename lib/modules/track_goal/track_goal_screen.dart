import 'package:call_me/generated/l10n.dart';
import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/modules/milestone/milestone_screen.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:call_me/shared/local/cachehelper.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:intl/intl.dart';

class TrackGoalScreen extends StatelessWidget {
  TrackGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: DashedCircularProgressBar.aspectRatio(
                      aspectRatio: 2.5, // width ÷ height
                      progress: (cubit.goalModel!.learnedWordsCounter! /
                              cubit.goalModel!.numberOfWords!) *
                          100, // // Calculate progress as a percentage
                      startAngle: 270,
                      sweepAngle: 180,
                      circleCenterAlignment: Alignment.bottomCenter,
                      foregroundColor: Color.fromARGB(255, 29, 2, 2),
                      backgroundColor: Color(0xffeeeeee),
                      foregroundStrokeWidth: 4,
                      backgroundStrokeWidth: 5,
                      backgroundGapSize: 3,
                      backgroundDashSize: 1,
                      seekColor: Colors.yellow,
                      seekSize: 22,
                      animation: true,
                    ),
                  ),
                  Text(
                    S.of(context).your_learning_plan,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  // Learning Plan
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${AppCubit.get(context).goalModel!.numberOfWords} ${S.of(context).words_in} ${AppCubit.get(context).goalModel!.endDate!.difference(AppCubit.get(context).goalModel!.startDate!).inDays} ${S.of(context).day}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(
                    height: Dimensions.size(40, context),
                  ),
                  // Time Left
                  Container(
                    decoration: BoxDecoration(
                        color: isTimerFinished
                            ? Colors.red
                            : const Color.fromARGB(255, 7, 122, 13),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TimerCountdown(
                        format: CountDownTimerFormat.daysHoursMinutes,
                        endTime: cubit.goalModel!.endDate!,
                        timeTextStyle: TextStyle(color: Colors.white),
                        descriptionTextStyle: TextStyle(color: Colors.white),
                        onEnd: () {
                          cubit.changeTimeLeftColor();
                          print("Timer finished");
                        },
                      ),
                    ),
                  ),

                  defaultButton(text: 'Add', onPress: () {}),

                  // defaultButton(
                  //     text: 'Set New Goal',
                  //     onPress: () {
                  //       navigatTo(
                  //         context,
                  //         const MileStoneScreen(),
                  //       );
                  //     }),
                ],
              ),
            ));
      },
    );
  }
}
