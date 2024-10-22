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

  /// `Are you sure you want to permanently delete your account? This action will erase all your data on the app.`
  String get deactivate_confirmation_msg {
    return Intl.message(
      'Are you sure you want to permanently delete your account? This action will erase all your data on the app.',
      name: 'deactivate_confirmation_msg',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get delete_account {
    return Intl.message(
      'Delete Account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `All your data has been erased`
  String get data_erased_success {
    return Intl.message(
      'All your data has been erased',
      name: 'data_erased_success',
      desc: '',
      args: [],
    );
  }

  /// `The provided information does not match`
  String get information_not_match {
    return Intl.message(
      'The provided information does not match',
      name: 'information_not_match',
      desc: '',
      args: [],
    );
  }

  /// `If your email is in the system, you'll be notified.`
  String get you_will_be_notified {
    return Intl.message(
      'If your email is in the system, you\'ll be notified.',
      name: 'you_will_be_notified',
      desc: '',
      args: [],
    );
  }

  /// `This may take some time. Please Wait`
  String get please_wait {
    return Intl.message(
      'This may take some time. Please Wait',
      name: 'please_wait',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, only Arabic and English are supported at the moment`
  String get only_arabic_and_english_supported {
    return Intl.message(
      'Sorry, only Arabic and English are supported at the moment',
      name: 'only_arabic_and_english_supported',
      desc: '',
      args: [],
    );
  }

  /// `Write your sentence!`
  String get write_sentence {
    return Intl.message(
      'Write your sentence!',
      name: 'write_sentence',
      desc: '',
      args: [],
    );
  }

  /// `Translate`
  String get translate {
    return Intl.message(
      'Translate',
      name: 'translate',
      desc: '',
      args: [],
    );
  }

  /// `Oops! It seems you're not connected to the internet. Please check your connection and try again`
  String get no_internet {
    return Intl.message(
      'Oops! It seems you\'re not connected to the internet. Please check your connection and try again',
      name: 'no_internet',
      desc: '',
      args: [],
    );
  }

  /// `How many words would you like to learn?`
  String get how_many_words {
    return Intl.message(
      'How many words would you like to learn?',
      name: 'how_many_words',
      desc: '',
      args: [],
    );
  }

  /// `Learning Duration`
  String get learning_duration {
    return Intl.message(
      'Learning Duration',
      name: 'learning_duration',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message(
      'From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Let's go`
  String get lets_go {
    return Intl.message(
      'Let\'s go',
      name: 'lets_go',
      desc: '',
      args: [],
    );
  }

  /// `Your learning plan is:`
  String get your_learning_plan {
    return Intl.message(
      'Your learning plan is:',
      name: 'your_learning_plan',
      desc: '',
      args: [],
    );
  }

  /// `words in`
  String get words_in {
    return Intl.message(
      'words in',
      name: 'words_in',
      desc: '',
      args: [],
    );
  }

  /// `day(s)`
  String get day {
    return Intl.message(
      'day(s)',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Set Your Goal`
  String get Set_a_goal {
    return Intl.message(
      'Set Your Goal',
      name: 'Set_a_goal',
      desc: '',
      args: [],
    );
  }

  /// `Success! Your new goal is now active.`
  String get created_goal_successfully {
    return Intl.message(
      'Success! Your new goal is now active.',
      name: 'created_goal_successfully',
      desc: '',
      args: [],
    );
  }

  /// `My Dictionary`
  String get my_dictionary {
    return Intl.message(
      'My Dictionary',
      name: 'my_dictionary',
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
