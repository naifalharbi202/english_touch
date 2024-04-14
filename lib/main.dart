import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/home.dart';

import 'package:call_me/modules/login/login_screen.dart';
import 'package:call_me/shared/bloc_observer.dart';

import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/local/cachehelper.dart';
import 'package:call_me/shared/styles/styles.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await CacheHelper.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  uId = CacheHelper.getData('uId') ?? '';
  Widget widget;
  if (uId.isEmpty) {
    widget = LoginScreen();
  } else {
    //toastMessage(message: uId);
    widget = const HomeLayout();
  }

  runApp(MyApp(startwidget: widget));
}

class MyApp extends StatelessWidget {
  final Widget? startwidget;
  const MyApp({super.key, this.startwidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()
            ..getCards()
            ..initVoices(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: lightMode, // In styles file

        supportedLocales: const [
          Locale('ar'),
          Locale('en'),
        ],
        home: startwidget,
      ),
    );
  }
}
