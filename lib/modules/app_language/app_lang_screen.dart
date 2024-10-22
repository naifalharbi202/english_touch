import 'package:call_me/layout/home.dart';
import 'package:call_me/modules/login/login_screen.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/local/cachehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppLangugaeScreen extends StatelessWidget {
  const AppLangugaeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            defaultButton(
                text: 'English',
                onPress: () {
                  langCode = 'en';
                  CacheHelper.saveData(key: 'lang', value: langCode)
                      .then((value) {
                    uId = CacheHelper.getData('uId') ?? '';
                    if (uId.isEmpty) {
                      navigateAndFinish(context, LoginScreen());
                    } else {
                      // Here handle if he skipped set a goal or not
                      // if he skipped then direct him to homelayout
                      // else direct him to milestone
                      navigateAndFinish(context, const HomeLayout());
                    }
                  });
                }),
            defaultButton(
                text: 'العربية',
                onPress: () {
                  langCode = 'ar';

                  CacheHelper.saveData(key: 'lang', value: langCode)
                      .then((value) {
                    uId = CacheHelper.getData('uId') ?? '';
                    if (uId.isEmpty) {
                      navigateAndFinish(context, LoginScreen());
                    } else {
                      navigateAndFinish(context, const HomeLayout());
                    }
                  });
                }),
          ],
        ),
      ),
    );
  }
}
