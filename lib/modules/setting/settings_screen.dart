import 'package:call_me/generated/l10n.dart';
import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/modules/deactivate_account/deactivate_screen.dart';
import 'package:call_me/modules/login/login_screen.dart';
import 'package:call_me/modules/milestone/milestone_screen.dart';
import 'package:call_me/modules/my_dictionary/dictionary_screen.dart';
import 'package:call_me/modules/track_goal/track_goal_screen.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:call_me/shared/local/cachehelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as dt;
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is GetChallengeSuccessState) {
          navigatTo(context, TrackGoalScreen());
        }

        if (state is GetChallengeNotFoundState) {
          navigatTo(context, MileStoneScreen());
        }

        if (state is FetchDefinitionsSuccessState) {
          navigatTo(context, MyDictionaryScreen());
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection:
              langCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: Column(
            children: [
              Container(
                color: isDark
                    ? const Color.fromARGB(255, 55, 50, 50)
                    : Colors.grey[200],
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.size(12, context)),
                      child: Text(
                        S.of(context).dark_mode,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const Icon(Icons.contrast_outlined),
                    const Spacer(),
                    Container(
                      width: Dimensions.size(60, context),
                      height: Dimensions.size(55, context),
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Switch.adaptive(
                              value: isDark,
                              activeColor:
                                  const Color.fromARGB(255, 145, 23, 166),
                              onChanged: (value) {
                                AppCubit.get(context).changeStyleMode(value);
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: isDark
                    ? const Color.fromARGB(255, 55, 50, 50)
                    : Colors.grey[200],
                child: Row(
                  children: [
                    TextButton(
                      child: Text(
                        S.of(context).language,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  backgroundColor: isDark
                                      ? const Color.fromARGB(255, 55, 50, 50)
                                      : Colors.grey[200],
                                  actions: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.all(8.0),
                                      child: defaultButton(
                                          text: 'English',
                                          onPress: () {
                                            langCode = 'en';
                                            CacheHelper.saveData(
                                                    key: 'lang',
                                                    value: langCode)
                                                .then((value) {
                                              AppCubit.get(context)
                                                  .changeAppLanguage();
                                              Navigator.pop(context);
                                            });
                                          }),
                                    ),
                                    defaultButton(
                                        text: 'العربية',
                                        onPress: () {
                                          langCode = 'ar';
                                          CacheHelper.saveData(
                                                  key: 'lang', value: langCode)
                                              .then((value) {
                                            AppCubit.get(context)
                                                .changeAppLanguage();
                                            Navigator.pop(context);
                                          });
                                        }),
                                  ],
                                ));
                      },
                    ),
                    const Icon(
                      Icons.language,
                      color: Color.fromARGB(255, 10, 22, 91),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Dimensions.size(10, context),
              ),
              // Set a goal or check progress
              Container(
                color: isDark
                    ? const Color.fromARGB(255, 55, 50, 50)
                    : Colors.grey[200],
                child: Row(
                  children: [
                    TextButton(
                      child: Text(
                        S.of(context).Set_a_goal,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onPressed: () async {
                        // Check if a user has already set a goal.
                        // If that was the case direct him to tracing screen
                        // Or direct him to MileStoneScreen (to set a goal)
                        AppCubit.get(context).getChallengeId();
                        // This is for tracking your goal
                        // navigatTo(context, TrackGoalScreen());//

                        // This is for set a new goal
                        //   navigatTo(context, MileStoneScreen());

                        //**FIREBASE SET A NEW CHALLENGE **//

                        //CHECK CACHE FIRST
                        // wordsGoalCount =
                        //     CacheHelper.getData('wordsGoal_$uId') ?? 0;
                        // deadlineStr = CacheHelper.getData('endDate_$uId') ?? '';
                        // String cacheSavedTime =
                        //     CacheHelper.getData('lastReset_$uId') ?? '';

                        // // THEN CHECK FIRSTORE CHALLENGE COLLECTION
                        // DateTime savedResetTime =
                        //     dt.DateFormat("yyyy-MM-dd HH:mm:ss.SSS", 'en')
                        //         .parse(cacheSavedTime);

                        // CollectionReference challengeCollection =
                        //     FirebaseFirestore.instance
                        //         .collection('users')
                        //         .doc(uId)
                        //         .collection('challenge');

                        // // This query will check if there is updated lastReset date
                        // QuerySnapshot checkLastResetQuery =
                        //     await challengeCollection
                        //         .where('lastReset',
                        //             isGreaterThan:
                        //                 Timestamp.fromDate(savedResetTime))
                        //         .orderBy('lastReset', descending: true)
                        //         .limit(1)
                        //         .get();

                        // print(checkLastResetQuery.docs.isEmpty);

                        // // if there is no update on lastReset and cached data isn't stale
                        // // or no challenge and no cached data

                        // if (checkLastResetQuery.docs.isEmpty &&
                        //     deadlineStr.isEmpty &&
                        //     wordsGoalCount == 0) {
                        //   // NO SAVED DATA AT ALL
                        //   // ignore: use_build_context_synchronously
                        //   navigatTo(context, const MileStoneScreen());
                        // } else if (checkLastResetQuery.docs.isEmpty &&
                        //     deadlineStr.isNotEmpty &&
                        //     wordsGoalCount != 0) {
                        //   // THE CACHED DATA IS NOT STALE
                        //   print('GETTING CHALLENGE RECORD FROM CACHE');
                        //   List<String> dateParts =
                        //       deadlineStr.split(' ')[0].split('-');
                        //   int year = int.parse(dateParts[0]);
                        //   int month = int.parse(dateParts[1]);
                        //   int day = int.parse(dateParts[2]);

                        //   deadlineDt = DateTime(year, month, day);
                        //   navigatTo(context, TrackGoalScreen());
                        // } else {
                        //   // GET NEW UPDATES FROM DB
                        //   print('GETTING CHALLENGE RECORD FROM CACHE');
                        //   challengeCollection
                        //       .doc('myPlan$uId')
                        //       .get()
                        //       .then((value) {});
                        // }

                        // if (deadlineStr.isNotEmpty && wordsGoalCount != 0) {
                        //   // if there was any saved data before
                        // } else {
                        //   // if no saved data
                        // }
                      },
                    ),
                    const Icon(
                      Icons.flag,
                      color: Color.fromARGB(255, 202, 22, 133),
                    ),
                  ],
                ),
              ),

              // My Dictionary
              Container(
                color: isDark
                    ? const Color.fromARGB(255, 55, 50, 50)
                    : Colors.grey[200],
                child: Row(
                  children: [
                    // Sign out

                    TextButton(
                      child: Text(S.of(context).my_dictionary,
                          style: Theme.of(context).textTheme.bodyLarge!),
                      onPressed: () {
                        AppCubit.get(context).fetchDefinitions();
                      },
                    ),
                    const Icon(
                      Icons.book_rounded,
                      color: Color.fromARGB(255, 26, 59, 194),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Dimensions.size(10, context),
              ),
              // Font Size
              Container(
                color: isDark
                    ? const Color.fromARGB(255, 55, 50, 50)
                    : Colors.grey[200],
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).font_size,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Slider.adaptive(
                          min: 16,
                          max: 24,
                          divisions: 4,
                          label: fontSelectedSize.round().toString(),
                          value: fontSelectedSize,
                          onChanged: (value) {
                            AppCubit.get(context).changeFontSize(value);
                          }),
                    ],
                  ),
                ),
              ),
              // Contact Us
              Container(
                color: isDark
                    ? const Color.fromARGB(255, 55, 50, 50)
                    : Colors.grey[200],
                child: Row(
                  children: [
                    TextButton(
                      child: Text(
                        S.of(context).contact_us,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onPressed: () {
                        String? encodeQueryParameters(
                            Map<String, String> params) {
                          return params.entries
                              .map((MapEntry<String, String> e) =>
                                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                              .join('&');
                        }

                        final emailUrl = Uri(
                          scheme: 'mailto',
                          path: 'sa1460sa@gmail.com',
                          query: encodeQueryParameters(<String, String>{
                            'body':
                                'PS. Miro is watching you. Be nice or I SWEAR (قسمًا عظمًا) this is gonna be your last day on EARTH.\n \n Support Team'
                          }),
                        );

                        launchUrl(emailUrl);
                      },
                    ),
                    const Icon(
                      Icons.contact_mail_rounded,
                      color: Color.fromARGB(255, 13, 131, 80),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Dimensions.size(10, context),
              ),
              // Sign Out
              Container(
                color: isDark
                    ? const Color.fromARGB(255, 55, 50, 50)
                    : Colors.grey[200],
                child: Row(
                  children: [
                    // Sign out

                    TextButton(
                      child: Text(S.of(context).sign_out,
                          style: Theme.of(context).textTheme.bodyLarge!),
                      onPressed: () {
                        //Sign me out
                        AppCubit.get(context).signOut(context, LoginScreen());
                      },
                    ),
                    const Icon(
                      Icons.logout,
                      color: Color.fromARGB(255, 232, 61, 135),
                    ),
                  ],
                ),
              ),
              // Deactivate
              Container(
                color: isDark
                    ? const Color.fromARGB(255, 55, 50, 50)
                    : Colors.grey[200],
                child: Row(
                  children: [
                    TextButton(
                      child: Text(
                        S.of(context).deactivate,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onPressed: () {
                        //Show dialouge to deactivate account

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: isDark
                                ? const Color.fromARGB(31, 102, 96, 96)
                                : Colors.white,
                            title: Text(
                              S.of(context).deactivate_confirmation_msg,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      S.of(context).canncel,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      navigatTo(context, DeactivateScreen());
                                    },
                                    child: Text(
                                      S.of(context).confirm,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Icon(
                      Icons.do_disturb_on_rounded,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),

              // defaultButton(
              //     text: 'TEST ',
              //     onPress: () {
              //       // AppCubit.get(context).getChallengeId();
              //      // AppCubit.get(context).fetchDefinitions();
              //     })
            ],
          ),
        );
      },
    );
  }
}
