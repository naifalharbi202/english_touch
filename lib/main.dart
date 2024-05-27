import 'package:call_me/generated/l10n.dart';
import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/layout/home.dart';
import 'package:call_me/modules/app_language/app_lang_screen.dart';

import 'package:call_me/modules/login/login_screen.dart';
import 'package:call_me/shared/bloc_observer.dart';

import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/local/cachehelper.dart';
import 'package:call_me/shared/styles/styles.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  Gemini.init(apiKey: GEMINIAPI);

  await CacheHelper.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  cachedSources = CacheHelper.getListData('otherSources') ?? [];
  isDark = CacheHelper.getData('mode') ?? false;

  fontSelectedSize = CacheHelper.getData("font") ?? 16;

  uId = CacheHelper.getData('uId') ?? '';
  langCode = CacheHelper.getData('lang') ?? '';

  Widget widget;
  // New brand user
  if (uId.isEmpty && langCode.isEmpty) {
    widget = const AppLangugaeScreen();
  }

  // User selected language but didn't register yet
  else if (uId.isEmpty && langCode.isNotEmpty) {
    widget = LoginScreen();
  } else {
    widget = const HomeLayout();
  }

  runApp(
    MyApp(
      startwidget: widget,
      isModeChanged: isDark,
      selectedFontSize: fontSelectedSize,
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget? startwidget;
  final bool? isModeChanged;
  final double? selectedFontSize;
  const MyApp(
      {super.key, this.startwidget, this.isModeChanged, this.selectedFontSize});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AppCubit()
              ..getCards()
              ..getUser()
              ..initVoices()
              ..changeStyleMode(isModeChanged!)),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              locale: langCode.isEmpty
                  ? const Locale('ar')
                  : Locale(langCode), // 'ar' is default
              debugShowCheckedModeBanner: false,
              theme: lightMode,
              darkTheme: darkMode,
              themeMode:
                  isDark ? ThemeMode.dark : ThemeMode.light, // In styles file
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              home: startwidget,
            );
          }),
    );
  }
}
