import 'package:call_me/generated/l10n.dart';
import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/modules/deactivate_account/deactivate_screen.dart';
import 'package:call_me/modules/login/login_screen.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:call_me/shared/local/cachehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // if (state is ChangeSwitchModeState) {
        //   AppCubit.get(context).changeAppMode();
        // }
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
                              activeColor: Color.fromARGB(255, 145, 23, 166),
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
              Container(
                color: isDark
                    ? const Color.fromARGB(255, 55, 50, 50)
                    : Colors.grey[200],
                child: Row(
                  children: [
                    // Sign out

                    TextButton(
                      child: Text(
                        S.of(context).sign_out,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
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
                              'هذا الإجراء سيحذف جميع بياناتك على هذا التطبيق. هل أنت متأكد من حذف حسابك؟',
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
                                      'إلغاء',
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
                                      'تأكيد',
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
            ],
          ),
        );
      },
    );
  }
}
