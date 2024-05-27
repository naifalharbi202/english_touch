// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `My Library`
  String get home_title {
    return Intl.message(
      'My Library',
      name: 'home_title',
      desc: '',
      args: [],
    );
  }

  /// `Exam Spot`
  String get exam_screen_title {
    return Intl.message(
      'Exam Spot',
      name: 'exam_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings_title {
    return Intl.message(
      'Settings',
      name: 'settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Dark mode`
  String get dark_mode {
    return Intl.message(
      'Dark mode',
      name: 'dark_mode',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get sign_out {
    return Intl.message(
      'Sign Out',
      name: 'sign_out',
      desc: '',
      args: [],
    );
  }

  /// `Deactivate`
  String get deactivate {
    return Intl.message(
      'Deactivate',
      name: 'deactivate',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Create An Exam`
  String get create_exam {
    return Intl.message(
      'Create An Exam',
      name: 'create_exam',
      desc: '',
      args: [],
    );
  }

  /// `Extract Text From Image`
  String get extract_text {
    return Intl.message(
      'Extract Text From Image',
      name: 'extract_text',
      desc: '',
      args: [],
    );
  }

  /// `Source`
  String get source {
    return Intl.message(
      'Source',
      name: 'source',
      desc: '',
      args: [],
    );
  }

  /// `Book`
  String get book {
    return Intl.message(
      'Book',
      name: 'book',
      desc: '',
      args: [],
    );
  }

  /// `Movie`
  String get movie {
    return Intl.message(
      'Movie',
      name: 'movie',
      desc: '',
      args: [],
    );
  }

  /// `School`
  String get school {
    return Intl.message(
      'School',
      name: 'school',
      desc: '',
      args: [],
    );
  }

  /// `Friend`
  String get friend {
    return Intl.message(
      'Friend',
      name: 'friend',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get another_source {
    return Intl.message(
      'Other',
      name: 'another_source',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get canncel {
    return Intl.message(
      'Cancel',
      name: 'canncel',
      desc: '',
      args: [],
    );
  }

  /// `Choose Exam Language`
  String get choose_lang_exam {
    return Intl.message(
      'Choose Exam Language',
      name: 'choose_lang_exam',
      desc: '',
      args: [],
    );
  }

  /// `Results`
  String get results {
    return Intl.message(
      'Results',
      name: 'results',
      desc: '',
      args: [],
    );
  }

  /// `Zero correct answers`
  String get zero_correct_answers {
    return Intl.message(
      'Zero correct answers',
      name: 'zero_correct_answers',
      desc: '',
      args: [],
    );
  }

  /// `You have answerd`
  String get you_have_answered {
    return Intl.message(
      'You have answerd',
      name: 'you_have_answered',
      desc: '',
      args: [],
    );
  }

  /// `question`
  String get question {
    return Intl.message(
      'question',
      name: 'question',
      desc: '',
      args: [],
    );
  }

  /// `questions`
  String get questions {
    return Intl.message(
      'questions',
      name: 'questions',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get sign_in {
    return Intl.message(
      'Sign In',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `New Member?`
  String get new_member {
    return Intl.message(
      'New Member?',
      name: 'new_member',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'forgot_password?' key

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Phone No`
  String get phone {
    return Intl.message(
      'Phone No',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `I have an account`
  String get have_an_accont {
    return Intl.message(
      'I have an account',
      name: 'have_an_accont',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset {
    return Intl.message(
      'Reset Password',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove_source {
    return Intl.message(
      'Remove',
      name: 'remove_source',
      desc: '',
      args: [],
    );
  }

  /// `Sentence is required`
  String get sentence_required {
    return Intl.message(
      'Sentence is required',
      name: 'sentence_required',
      desc: '',
      args: [],
    );
  }

  /// `Create Another Exam`
  String get create_another_exam {
    return Intl.message(
      'Create Another Exam',
      name: 'create_another_exam',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to cancel this exam?`
  String get do_you_want_to_cancel_exam {
    return Intl.message(
      'Do you want to cancel this exam?',
      name: 'do_you_want_to_cancel_exam',
      desc: '',
      args: [],
    );
  }

  /// `Required`
  String get required_field {
    return Intl.message(
      'Required',
      name: 'required_field',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgot_password {
    return Intl.message(
      'Forgot Password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Minimum password length: 6 digits`
  String get must_be_six_digits {
    return Intl.message(
      'Minimum password length: 6 digits',
      name: 'must_be_six_digits',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get new_register {
    return Intl.message(
      'Sign Up',
      name: 'new_register',
      desc: '',
      args: [],
    );
  }

  /// `No update`
  String get no_update {
    return Intl.message(
      'No update',
      name: 'no_update',
      desc: '',
      args: [],
    );
  }

  /// `Field empty`
  String get nothing_entered {
    return Intl.message(
      'Field empty',
      name: 'nothing_entered',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Font size`
  String get font_size {
    return Intl.message(
      'Font size',
      name: 'font_size',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contact_us {
    return Intl.message(
      'Contact Us',
      name: 'contact_us',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
