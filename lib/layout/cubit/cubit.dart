import 'dart:convert';
import 'dart:io';

import 'package:call_me/generated/l10n.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/layout/home.dart';
import 'package:call_me/models/goal_model.dart';
import 'package:call_me/models/dictionary_model.dart';
import 'package:call_me/shared/remote/dict_api.dart';
import 'package:call_me/shared/remote/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart' as dt; // Import the intl package for parsing

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;

import 'package:call_me/models/exam_model.dart';
import 'package:call_me/models/user_model.dart';
import 'package:call_me/models/word_model.dart';
import 'package:call_me/modules/exam/exam_screen.dart';
import 'package:call_me/modules/homepage/home_screen.dart';
import 'package:call_me/modules/setting/settings_screen.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/local/cachehelper.dart';
import 'package:call_me/shared/styles/colors.dart';
import 'package:call_me/shared/styles/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

import 'package:translator/translator.dart';

class AppCubit extends Cubit<AppStates> {
  late Stream<DocumentSnapshot> cardsDataStream;
  late DocumentSnapshot? cachedData;
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

// Data sources -- not used yet

  Source CACHE = Source.cache;
  Source SERVER = Source.server;

// current inext of bottom nav bar
  int currentIndex = 0;
// List of screen titles

  List<String> titles(context) {
    return [
      S.of(context).home_title,
      S.of(context).exam_screen_title,
      S.of(context).settings_title
    ];
  }

// List of screens to move to based on currentIndex value
  List<Widget> screens = [
    const HomeScreen(),
    ExamScreen(),
    const SettingsScreen(),
  ];

  void changeBottomNaveIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  void updateCachedSources() {
    emit(UpdateCachedSourcesState());
  }

  ThemeData buildlightMode() {
    return ThemeData(
        primaryColor: defaultColor,
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(color: Colors.black, fontFamily: 'Cairo'),
            actionsIconTheme: IconThemeData(
              color: Colors.black,
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark),
            color: Colors.white,
            elevation: 0.0),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: defaultColor,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
            bodyLarge: TextStyle(
                fontFamily: 'Cairo',
                color: Colors.black,
                fontSize: fontSelectedSize)));
  }

  ThemeData buildDarkMode() {
    return ThemeData(
      appBarTheme: const AppBarTheme(
          color: Colors.black,
          actionsIconTheme: IconThemeData(
            color: Colors.white,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light, //Controls status bar
              statusBarColor: Colors.black)),
      scaffoldBackgroundColor: const Color.fromARGB(255, 11, 11, 11),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          elevation: 0.7,
          backgroundColor: Color.fromARGB(255, 24, 23, 23),
          selectedItemColor: Color.fromARGB(255, 14, 76, 87),
          unselectedItemColor: Colors.white),
      inputDecorationTheme:
          const InputDecorationTheme(labelStyle: TextStyle(color: Colors.grey)),
      textTheme: TextTheme(
          bodyLarge: TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontSize: fontSelectedSize)),
    );
  }

  void changeFontSize(double value) {
    fontSelectedSize = value;
    lightMode = buildlightMode();
    darkMode = buildDarkMode();
    CacheHelper.saveData(key: "font", value: fontSelectedSize);

    emit(ChangeFontSizeState());
  }

  void changeStyleMode(bool value) {
    isDark = value;
    print('isSwitched value is $isDark');
    CacheHelper.saveData(key: 'mode', value: isDark).then((value) {
      emit(ChangeSwitchModeState());
    });
  }

  final regex = RegExp(r'^[a-zA-Z0-9\s]+$');
  TextDirection textDirection = TextDirection.rtl;

  void checkTextDirection() {
    emit(TextDirectionState());
  }

  String translatedText = '';
  Future<String> translateText(String text, {bool? isDictionary}) async {
    emit(TranslationLoadingState());
    try {
      final value = await text.translate(from: 'auto', to: 'ar');
      translatedText = value.text;
      print(translatedText);

      emit(TranslationSuccessState());
      return translatedText; // Return the translated text
    } catch (error) {
      toastMessage(message: error.toString());
      emit(TranslationErrorState());
      return ''; // Return an empty string or handle it as needed
    }
  }

  UserModel? userModel;
  //Get One User (FIREBASE)-- tryToken (Alternative  for laravel)
  void getUser() async {
    if (token.isEmpty) {
      return;
    }

    DioHelper.setAuthToken(token);
    Response response = await DioHelper.getData(
      url: '/user',
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> userData = {
        'id': response.data['id'],
        'name': response.data['name'],
        'email': response.data['email'],
        'phone': response.data['phone'],
      };
      userModel = UserModel.fromJson(userData);

      // print('THIS IS USER ID ${userModel!.id}');
    }

    // if (uId.isEmpty) {
    //   return; // Because a document path must be a non-empty string
    // }
    // // First go and get userData saved in cache by his unuqie uId
    // final userCache = CacheHelper.getUserData('userModel_$uId');
    // if (userCache != null) {
    //   userModel = UserModel.fromJson(userCache);

    //   emit(GetUserSuccessState());
    // } else {
    //   final userDoc =
    //       await FirebaseFirestore.instance.collection('users').doc(uId).get();
    //   userModel = UserModel.fromJson(userDoc.data());
    //   CacheHelper.saveUserData('userModel_$uId', userDoc.data()!).then((value) {

    //     emit(GetUserSuccessState());
    //   }).catchError((error) {
    //     emit(GetUserErrorState());
    //   });
    // }
  }

  //Forgot password
  void forgetPassword({required email}) async {
    emit(SendPasswordResetLoadingState());

    Response response = await DioHelper.postData(
        url: '/forgot-pass/send-email', data: {'email': email});

    if (response.statusCode == 200) {
      emit(SendPasswordResetSuccessState());
    } else {
      emit(SendPasswordResetErrorState());
    }
    //* Firebase Forgot Pass *//
    // FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
    //   emit(SendPasswordResetSuccessState());
    // }).catchError((error) {
    //   toastMessage(message: 'حدث خطأ');
    //   emit(SendPasswordResetErrorState());
    // });
  }

  static bool isToolBarShown = true;
  static final Document sentenceDoc = Document();
  static final Document translationDoc = Document();
  //On Text Change Quill Editor

  void hideToolbar(
    bool val,
  ) {
    isToolBarShown = val;
  }

  QuillController fieldController({
    required Document document,
  }) {
    if (document == sentenceDoc || document == sentenceRetrievedDoc) {
      return QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0),
          onSelectionChanged: (value) {
            isCursorOnSentence = true;
            emit(ChangeToolBarState());
          });
    } else {
      emit(ChangeToolBarState());
      return QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0),
          onSelectionChanged: (value) {
            isCursorOnSentence = false;
            emit(ChangeToolBarState());
          });
    }
  }

  void changeAppLanguage() {
    emit(ChangeAppLanguageState());
  }

  void changeSourceLabel(value) {
    source = value;
    emit(ChangeSourceLabelState());
  }

  IconData getSourceIcon(String source) {
    switch (source) {
      case 'كتاب':
        return Icons.book;

      case 'فيلم':
        return Icons.movie_creation_outlined;

      case 'صديق':
        return Icons.person_3_outlined;

      case 'المدرسة':
        return Icons.school;

      default:
        return Icons.source;
    }
  }

  FlutterTts flutterTts = FlutterTts();
  Map? defaultVoice;
  void initVoices() {
    flutterTts.setSpeechRate(0.0);
    flutterTts.getVoices.then((value) {
      List<Map> voices = List<Map>.from(value);

      voices = voices.where((voice) => voice['name'].contains('en')).toList();

      defaultVoice = voices.last;

      setVoice(defaultVoice!);
      emit(GetVoiceSuccessState());
    }).catchError((error) {
      // toastMessage(message: error.toString());
      emit(GetVoiceErrorState());
    });
  }

  void setVoice(Map voices) {
    flutterTts.setVoice({'name': voices['name'], 'locale': voices['locale']});
  }

  // EXAM OPERATIONS //
  void getWords() {
    if (cards.isEmpty) {
      // Go check it
      print('First I want to check');
      getCards();
      if (isCardsEmpty) {
        print('Oh, I checked but cards are empty');
        isExamGenerated = false;
        emit(GetEditedWordsEmptyState());
      }
    } else {
      // If no card is added yet

      print('Wow there are words');
      // There are added cards
      retrievedSentences = [];
      retrievedWords = [];
      // fill them
      for (int i = 0; i < cards.length; i++) {
        // print(cards[i].editedWords);

        if (!retrievedWords.contains(cards[i].editedWords)) {
          retrievedWords.add(cards[i].editedWords);
        }

        if (!retrievedSentences.contains(cards[i].sentence)) {
          retrievedSentences.add(cards[i].sentence);
        }
      }

      // After filling generate exams based on exam lang
      // print("SENTENCES : $retrievedSentences");
      // print("EDITED WORDS : $retrievedWords");
      if (isEnglishExam) {
        generateQuestion();
      } else {
        generateArabicQuestion();
      }
    }

    // Already filled
    // if (retrievedWords.isNotEmpty ||
    //     retrievedSentences.isNotEmpty && cards.isNotEmpty) {
    //   if (isEnglishExam) {
    //     print('It is ENGLISH EXAM');
    //     // Priority: Exam about higlighted words
    //     generateQuestion();
    //   } else {
    //     print('It is ARABIC EXAM');
    //     // Priority: Exam about higlighted words
    //     generateArabicQuestion();
    //   }
    // }

    // // Not filled yet. Go get them from server
    // if (retrievedWords.isEmpty && retrievedSentences.isEmpty) {
    //   // print('FIRESTORE GETGETGETGETGET');
    //   // Get it for the first time

    //   FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(uId)
    //       .collection('learning')
    //       .get()
    //       .then((value) {
    //     retrievedWords = [];
    //     retrievedSentences = [];
    //     for (var element in value.docs) {
    //       var data = element.data();
    //       // Recieve timestamp, turn it into date time

    //       data['lastTouched'] = DateTime.fromMillisecondsSinceEpoch(
    //           data['lastTouched'].seconds * 1000);

    //       WordModel model = WordModel.fromJson(data);

    //       retrievedWords += model.editedWords!;

    //       retrievedSentences.add(model.sentence); // Will always have value
    //     }
    //     if (isEnglishExam) {
    //       if (retrievedWords.isNotEmpty) {
    //         // Priority: Exam about higlighted words
    //         generateQuestion();
    //       } else if (retrievedWords.isEmpty && retrievedSentences.isNotEmpty) {
    //         generateQuestion();
    //       } else {
    //         isExamGenerated = false;
    //         emit(GetEditedWordsEmptyState());
    //       }
    //     } else {
    //       if (retrievedWords.isNotEmpty) {
    //         // Priority: Exam about higlighted words
    //         generateArabicQuestion();
    //       } else if (retrievedWords.isEmpty && retrievedSentences.isNotEmpty) {
    //         generateArabicQuestion();
    //       } else {
    //         isExamGenerated = false;

    //         emit(GetEditedWordsEmptyState());
    //       }
    //     }
    //   }).catchError((error) {
    //     print("ERROR GETTING WORDS $error");
    //   });
    // }
  }

  final gemini = Gemini.instance;
  ExamModel? examModel;
  void generateQuestion() {
    emit(GenrateExamLoadingState());
    isExamGenerated = false;
    examWords = retrievedWords + retrievedSentences;
    gemini.text(prompt(examWords)).then((value) {
      //  String jsonString = value!.content!.toJson().toString();
      // Map<String, dynamic> jsonData = jsonDecode(jsonString);
      myExamMap = jsonDecode(value!.content!.parts![0].text!);
      // print(myExamMap);
      // print( 'THIS IS QUESTION 1 Question ${myExamMap['question 1']['question']}');
      // print('THIS IS QUESTION 1 Answers ${myExamMap['question 1']['answers']}');
      // print('THIS IS QUESTION 1 CorrectAnswer ${myExamMap['question 1']['correctAnswer']}');
      if (myExamMap.isNotEmpty) {
        if (myExamMap.keys.first == 'question 1' &&
            myExamMap['question 1']['question'] != null &&
            myExamMap['question 1']['answers'] != null &&
            myExamMap['question 1']['correctAnswer'] != null) {
          isEnglishExam = true;
          isExamGenerated = true; // if exam is ready
          numOfCorrectAnswers = 0;
        } else {
          myExamMap = {};
          generateQuestion();
        }
      }

      emit(GenrateExamSuccessState());
    }).catchError((error) {
      // Error Types: Format Exception '''json

      generateQuestion();
      emit(GenrateExamErrorState());
      //toastMessage(message: error.toString());
    });
  }

  void generateArabicQuestion() {
    emit(GenrateExamLoadingState());
    isExamGenerated = false;
    examWords = retrievedWords + retrievedSentences;
    gemini.text(arabicPrompt(examWords)).then((value) {
      myExamMap = jsonDecode(value!.content!.parts![0].text!);

      if (myExamMap.isNotEmpty) {
        if (regex.hasMatch(myExamMap.keys.first)) {
          // Handle NoSuchMethod Error
          isArabicExam = true;
          isExamGenerated = true; // if exam is ready
          numOfCorrectAnswers = 0;
        } else {
          myExamMap = {};
          generateArabicQuestion();
        }
      }

      emit(GenrateExamSuccessState());
    }).catchError((error) {
      // Error Types: Format Exception '''json

      generateArabicQuestion();
      emit(GenrateExamErrorState());
      //toastMessage(message: error.toString());
    });
  }

  cancelExam(context) {
    isExamGenerated = false;
    isCreateExamSelected = false;
    isArabicExam = false;
    isEnglishExam = false;
    numOfCorrectAnswers = 0;
    currentQuestionNum = 1;
    isSelected = false;
    Navigator.pop(context);
    emit(CancelExamSuccessState());
  }

  int currentQuestion = 1;
  void goToNextQuestion(int currentQuestionNum) {
    currentQuestion = currentQuestionNum;
    isSelected = false;
    emit(GoToNextQuestionSuccessState());
  }

  //Change answer colors

  void changeAnswerColors() {
    isSelected = true;
    emit(ChangeAnswerColor());
  }

  WordModel? wordModel;
  void addCard(
      {required String sentence,
      String? translation,
      List<String>? editedWords,
      String? pickedSource,
      List<Map<String, dynamic>>? docAttributrs,
      List<Map<String, dynamic>>? transDocAttributrs,
      DateTime? lastTouched}) async {
    emit(AddCardLoadingState());

    wordModel = WordModel(
        sentence,
        translation,
        editedWords,
        pickedSource,
        docAttributrs,
        transDocAttributrs,
        DateTime.now(),
        DateTime.now(),
        userModel!.id);
    try {
      Response response = await DioHelper.postData(
          url: '/cards', data: wordModel!.toJson(), token: token);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);

        cards.add(WordModel.fromJson(response.data));
        isCreateExamSelected = false;
        emit(AddCardSuccessState());
      } else {
        print('hereerer');
        toastMessage(
            message: langCode == 'ar'
                ? 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى'
                : 'Unexpected error. Please try again later');
        emit(AddCardErrorState());
      }
    } catch (e) {
      toastMessage(
          message: langCode == 'ar'
              ? 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى'
              : 'Unexpected error. Please try again later');
      print("Error $e");
      emit(AddCardErrorState());
    }
    ////////  Firebase Add New Card ///////
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(uId)
    //     .collection('learning')
    //     .add(wordModel!.toJson())
    //     .then((value) {
    //   wordModel!.docId =
    //       value.id; // Because doc ids are acquired, can't set them

    //   CacheHelper.saveData(
    //           key: 'lastUpdated_$uId',
    //           value: lastTouched.toString().substring(0, 23))
    //       .then((value) {
    //     cards.add(wordModel!);
    //     cachedCards = cards;
    //     isCreateExamSelected = false;
    //     emit(AddCardSuccessState()); // This will update ui
    //   });
    // }).catchError((error) {
    //   toastMessage(message: error.toString());
    //   emit(AddCardErrorState());
    // });
  }

// Laravel get cards
  void getCards() async {
    if (token.isEmpty) {
      return;
    }
    emit(GetCardsLoadingState());
    try {
      print(token);
      DioHelper.setAuthToken(token);
      Response response = await DioHelper.getData(url: '/cards');
      if (response.statusCode == 200) {
        if (response.data['cards'].isNotEmpty) {
          //If there were cards added]
          cards = [];
          for (var element in response.data['cards']) {
            cards.add(WordModel.fromJson(element));
            // Handle Edited Words
            if (element['edited_words'] is List) {
              highlightedWords.addAll(element['edited_words']);
            } else if (element['edited_words'] is String) {
              // If it's a string, decode it first
              var decodedWords = jsonDecode(element['edited_words']);
              if (decodedWords is List) {
                highlightedWords.addAll(decodedWords);
              } else {
                highlightedWords
                    .add(element['edited_words']); // Add as is if not a list
              }
            }
          }

          // Now flatten highlightedWords if needed
          // If you want to split phrases into individual words:
          highlightedWords = highlightedWords.expand((word) {
            if (word is String) {
              return word.split(' '); // Split by spaces
            }
            return [word]; // Return as a single-item list
          }).toList();

          print(highlightedWords);
          isCardsEmpty = false;
        } else {
          // No cards added
          isCreateExamSelected = false;
          isCardsEmpty = true;
          print('NO CARDS ADDED');
        }

        emit(GetCardsSuccessState());
      } else {
        toastMessage(
            message: langCode == 'ar'
                ? 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى'
                : 'Unexpected error. Please try again later');
        emit(GetCardsErrorState());
      }
    } catch (e) {
      toastMessage(
          message: langCode == 'ar'
              ? 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى'
              : 'Unexpected error. Please try again later');
      print('error $e');
    }
  }

  // Laravel delete card
  void deleteCard({required docId}) async {
    try {
      Response response =
          await DioHelper.deleteCard(url: '/cards/$docId', token: token);
      if (response.statusCode == 200) {
        cards.removeWhere((element) => element.docId == docId);
        emit(DeleteCardSuccessState());
      }
    } catch (e) {
      print('Error $e');
      emit(DeleteUserErrorState());
    }
  }

// Laravel Create Challenge
  void createChallenge(
      DateTime startDate, DateTime endDate, int numWords, context) async {
    Map<String, dynamic> challengeData = {
      'number_of_words': numWords,
      'start_date':
          startDate.toIso8601String().split('T')[0], // Format to YYYY-MM-DD
      'end_date': endDate.toIso8601String().split('T')[0],
    };

    try {
      Response response =
          await DioHelper.postData(url: '/challenges', data: challengeData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('This IS CHALLENGE ID ON CREATE ${response.data}');
        // Will save it in shared-pref to be able to check whether a user set a goal
        CacheHelper.saveData(
                key: 'goal_${userModel!.id}', value: response.data['id'])
            .then((value) {
          currentIndex = 0;
          navigatTo(context, HomeLayout());
          toastMessage(
              message: S.of(context).created_goal_successfully,
              backgroundColor: const Color.fromARGB(255, 80, 230, 85));
          emit(SetGoalSuccessState());
        });
      }
    } catch (error) {
      print(error.toString());
      emit(SetGoalErrorState());
    }
  }

// Laravel Get Challenge ID

  void getChallengeId(
      {bool? isFromDictionary, Map<String, dynamic>? learnedData}) async {
    challenge = CacheHelper.getData(
        'goal_${userModel!.id}'); // This must be deleted from cache on goal removal

    if (challenge == null) {
      // Means, user didn't set a goal yet or signed in from different device
      try {
        DioHelper.setAuthToken(token);
        Response response = await DioHelper.getData(url: '/user/challenge');
        if (response.statusCode == 200) {
          print('DATA FROM GET CHALLENGE ID ${response.data}');

          // This means user coming from tracking progress
          if (isFromDictionary == null) {
            getChallenge(response.data['challengeId']);
          } else {
            //User is coming from dictionary screen
            getChallenge(response.data['challengeId'],
                isFromDictionary: true, learnedData: learnedData);
          }

          emit(GetChallengeIdSuccessState());
        }
      } catch (error) {
        // Not found or Server Down
        emit(GetChallengeNotFoundState());
      }
    } else {
      // Means, user has already set a goal
      print('GETTING CHALLENGE FROM ID SAVED IN CACHE');
      // This means user coming from tracking progress
      if (isFromDictionary == null) {
        getChallenge(challenge);
      } else {
        //User is coming from dictionary screen
        getChallenge(challenge,
            isFromDictionary: true, learnedData: learnedData);
      }
    }
  }

  GoalModel? goalModel;
// Laravel Get Challenge
  void getChallenge(int challengeId,
      {bool? isFromDictionary, Map<String, dynamic>? learnedData}) async {
    {
      try {
        DioHelper.setAuthToken(token);
        Response response = await DioHelper.getData(
            url: '/challenges/${challengeId.toString()}');

        if (response.statusCode == 200) {
          goalModel = GoalModel.fromJson(response.data['challenge']);

          if (isFromDictionary != null) {
            print("GOT HEEEEEERE");

            learnedData!['learned_words_counter'] =
                goalModel!.learnedWordsCounter! + 1;

            updateLearnedWords(learnedData);
          } else {
            // Just emit state
            emit(GetChallengeSuccessState());
          }

          // print('LEARNED WORDS COUNTER === ${goalModel!.learnedWordsCounter}');

          // print('PERIOD OF LEARNING');
          // print(
          //     '${goalModel!.endDate!.difference(goalModel!.startDate!).inDays}');
        }
      } catch (error) {
        //Unauthorized access or Server Down
        print(error.toString());

        emit(GetChallengeErrorState());
      }
    }
  }

// Laravel Update Challenge

// Laravel Delete Challenge

// Laravel -- UPDATE A CARD
  void updateCard(
      {required docId,
      documentAttributes,
      editedWords,
      sentence,
      source,
      transDocumentAttributes,
      translation,
      createdAt}) async {
    emit(UpdateCardLoadingState());

    wordModel = WordModel(
        sentence,
        translation,
        editedWords,
        source,
        documentAttributes,
        transDocumentAttributes,
        createdAt,
        DateTime.now(),
        userModel!.id);

    try {
      // Prepare data to send to the server
      final data = {
        'sentence': sentence,
        'translation': translation,
        'edited_words': jsonEncode(editedWords),
        'source': source,
        'document_attributes': jsonEncode(documentAttributes),
        'trans_doc_attributes': jsonEncode(transDocumentAttributes),
      };

      Response response = await DioHelper.updateData(
          url: '/cards/$docId', token: token, data: data);

      if (response.statusCode == 200) {
        cards
            .removeWhere((element) => element.docId == docId); //first remove it
        // Then add it as brand-new card but with same previous docId
        // Already in add card you get doc id and then save in cards
        cards.add(WordModel.fromJson(response.data));

        emit(UpdateCardSuccessState());
      } else {
        print(response.statusCode);
        toastMessage(
            message: langCode == 'ar'
                ? 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى'
                : 'Unexpected error. Please try again later');
        emit(UpdateCardErrorState());
      }
    } catch (e) {
      print('Error: $e');
      emit(UpdateCardErrorState());
    }
  }

  // Firebase Operations -- SET A GOAL

  // void setGoal(DateTime endDate, int wordsGoal, context) {
  //   emit(SetGoalLoadingState());

  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uId)
  //       .collection('challenge')
  //       .doc('myPlan$uId')
  //       .set({
  //     'endDate': endDate,
  //     'wordsGoal': wordsGoal,
  //     'lastReset': DateTime.now()
  //   }).then((value) {
  //     // if added then save in cache //
  //     CacheHelper.saveData(key: 'endDate_$uId', value: endDate.toString());
  //     CacheHelper.saveData(
  //         key: 'lastReset_$uId',
  //         value: dt.DateFormat("yyyy-MM-dd HH:mm:ss.SSS", 'en')
  //             .format(DateTime.now())
  //             .toString());

  //     CacheHelper.saveData(key: 'wordsGoal_$uId', value: wordsGoal)
  //         .then((value) {
  //       navigateAndFinish(context, const HomeLayout());
  //       emit(SetGoalSuccessState());
  //     });
  //   }).catchError((error) {
  //     toastMessage(
  //         message: langCode == 'ar'
  //             ? 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى'
  //             : 'Unexpected error. Please try again later');

  //     emit(SetGoalErrorState());
  //   });
  // }

  // Text - Image recognition //
  final file = File('assets/images/test.jpg');

  // extractTextFromImage() async {
  //   final Uint8List file =
  //       (await rootBundle.load('assets/images/test.jpg')).buffer.asUint8List();
  //   gemini.textAndImage(
  //       text: 'What is written in this image?', images: [file]).then((value) {
  //     print(value?.content!.parts!.last.text);
  //   }).catchError((error) {
  //     print(error);
  //   });
  // }

  final ImagePicker picker = ImagePicker();
  File? image; // This will store picked image
  getImage(context) async {
    isTextExtracted = false;
    isImagePicked = false;
    // User selected image
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      print('-----------UNDER PICKED IMAGE');
      // if user has really selected an image
      if (pickedImage != null) {
        print('------------INSIDE IF PICKED IMAGE');
        image = File(pickedImage.path);
        isImagePicked = true;
        extractText();
      } else {
        toastMessage(message: 'No image is picked');
        return;
      }
    } on Exception catch (e) {
      Navigator.pop(context);
      print('Failed to pick image $e');
    }
  }

  extractText() {
    emit(GetTextFromImageLoadingState());
    gemini.textAndImage(
        text:
            'What is written in this image? Just give the text. Do not reply with any introductions',
        images: [image!.readAsBytesSync()]).then((value) {
      isTextExtracted = true;
      print('got here');
      extractedText = value!.content!.parts!.last.text!;
      emit(GetTextFromImageSuccessState());

      print(value.content!.parts!.last.text);
    }).catchError((error) {
      toastMessage(message: 'حدث خطأ عند استخراج النص');
      emit(GetTextFromImageErrorState());
    });
  }

  // Change Time Left Color

  void changeTimeLeftColor() {
    isTimerFinished = true;
    emit(ChangeTimeLeftColorState());
  }

// Sign Out //

  void signOut(context, Widget destination) async {
    try {
      // Make the request to revoke the token
      Response response =
          await DioHelper.postData(url: '/user/revoke', token: token);

      // Check response status code
      if (response.statusCode == 200) {
        // Handle successful response
        var responseData = response.data.toString();
        if (responseData.contains('Token(s) revoked successfully')) {
          CacheHelper.removeData('token').then((value) {
            if (cards.isNotEmpty) {
              cards.clear();
            }
            if (highlightedWords.isNotEmpty) {
              highlightedWords.clear();
            }
            token = ''; // empty token
            currentIndex = 0;
            isTimerFinished = false;
            navigateAndFinish(context, destination);
            emit(SignOutSuccessState());
          });
        } else {
          print('Unexpected response format: $responseData');
          // Handle unexpected response format
        }
      } else {
        // Handle other status codes
        print('Failed to revoke token. Status code: ${response.statusCode}');
        // Handle error appropriately
      }
    } catch (error) {
      print('Error logging out: $error');
      // Handle error
    }

    // * FIREBASE SIGN OUT  * //

    // await FirebaseAuth.instance.signOut().then((value) {
    //   CacheHelper.removeData('uId').then((value) {
    //     if (cards.isNotEmpty) {
    //       cards.clear();
    //     }
    //     navigateAndFinish(context, destination);
    //     emit(SignOutSuccessState());
    //   });
    // }).catchError((error) {
    //   toastMessage(message: 'حدث خطأ عند تسجيل الخروج');
    //   emit(SignOutErrorState());
    // });
  }

  void deactivateAccount(context, String email, String pass) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .get()
          .then((value) {
        userModel = UserModel.fromJson(
            value.data()); // get user data to make sure userModel is not null

        // If provided email and pass are matching the data in db
        if (email.trim() == user.email && pass.trim() == userModel!.password) {
          emit(DeleteUserLoadingState());
          AuthCredential credential =
              EmailAuthProvider.credential(email: email, password: pass);
          user.reauthenticateWithCredential(credential).then((value) {
            // First will delete data using docId
            FirebaseFirestore.instance
                .collection('users')
                .doc(uId)
                .delete()
                .then((value) {
              // This because subcollections don't get deleted even if you delete the parent doc
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(uId)
                  .collection('learning')
                  .get()
                  .then((value) {
                //if learning collection doesn't exist .. then it equals 0.
                if (value.size == 0) {
                  // Then Delete User
                  user.delete().then((value) {
                    // Finally, remove data saved in sahred prefrences.. then navigate to login
                    CacheHelper.removeData('mode');
                    CacheHelper.removeData('uId').then((value) {
                      emit(DeleteUserSuccessState());
                    });
                  });
                } else {
                  // means learning collection is still there
                  deleteAllCards(); // This function will loop on every document inside it and delete it
                  user.delete().then((value) {
                    // Finally, remove data saved in sahred prefrences.. then navigate to login
                    CacheHelper.removeData('mode');
                    CacheHelper.removeData('uId').then((value) {
                      emit(DeleteUserSuccessState());
                    });
                  });
                }
              });
            });
          });
        } else {
          // Provided email and password are not matching database data
          emit(ProvidedEmailAndPassErrorState());
        }
      });
    } else {
      toastMessage(message: 'User is null');
    }
  }

  deleteAllCards() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('learning')
        .get();

    for (var document in querySnapshot.docs) {
      document.reference.delete();
    }
  }

  // Listen to changes in Firestore document

  void searchCards(searchedWords) {
    searchedCards = cards
        .where((element) =>
            element.sentence!.toLowerCase().contains(searchedWords))
        .toList();

    emit(SeachedCardsStates());
  }

  emptySearchedCards() {
    emit(EmptySearchedCardsState());
  }

  createPdf() async {
    final font = await rootBundle.load("assets/fonts/cairofont.ttf");
    pw.Document pdf = pw.Document();
    pdf.addPage(pw.Page(
        theme: pw.ThemeData(
            defaultTextStyle: pw.TextStyle(
                fontSize: 18,
                font: pw.Font.helvetica(),
                fontFallback: [
                  pw.Font.courier(),
                  pw.Font.times(),
                  pw.Font.zapfDingbats()
                ]),
            textAlign: pw.TextAlign.start),
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          // Page content goes here

          return pw.Column(
              children: List.generate(
                  cards
                      .length, // Adjust the number of items according to your content
                  (index) => pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              '${cards[index].sentence}',
                              style: pw.TextStyle(font: pw.Font.ttf(font)),
                              textAlign: pw.TextAlign.start,
                            ),
                            if (cards[index].editedWords!.isNotEmpty)
                              pw.Text('${cards[index].editedWords}',
                                  style: pw.TextStyle(
                                      color: PdfColor.fromHex('#D20103'),
                                      font: pw.Font.ttf(font))),
                            pw.SizedBox(
                                child: pw.Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: PdfColor.fromHex('#9EA6AF'))),
                            pw.SizedBox(height: 10),
                            pw.Text(longText),
                            pw.Text(longText),
                          ])));
        }));
    final dir = await getApplicationDocumentsDirectory();
    const fileName = "xcd.pdf";
    final savePath = path.join(dir.path, fileName);
    final file = File(savePath);

    await file.writeAsBytes(await pdf.save());
    OpenFilex.open(file.path);
  }

  // Fetch definitions
  List<Map<String, dynamic>?> definitions = [];
  List<Map<String, dynamic>> examples = [];
  List<String?> audioUrls = [];
  List<String?> translations = [];

  Future<void> fetchDefinitions() async {
    emit(FetchDefinitionsLoadingState());
    try {
      definitions = [];
      examples = [];
      audioUrls = [];
      translations = [];
      for (String word in highlightedWords) {
        var box = Hive.box('userDefinitions');
        DefinitionModel? cachedDefinition =
            await box.get('${word}_${userModel!.id}');

        if (cachedDefinition != null && cachedDefinition.word == word) {
          definitions.add(cachedDefinition.definitions);

          examples.add(cachedDefinition.examples);
          translations = cachedDefinition.translations;
          audioUrls = cachedDefinition.audioUrls;

          print('FETCHED FROM HIVE');
        } else {
          // Fetch from API if no cached data

          Response response = await DictApi.getData(url: '/$word');

          if (response.statusCode == 200) {
            final data = response.data;

            String? audioUrl;
            // await translations
            String translationOfWord =
                await translateText(word, isDictionary: true);

            // Initialize lists for definitions and examples
            Map<String, String?> definitionByPartOfSpeech = {
              'verb': null,
              'noun': null,
              'adjective': null,
              'adverb': null,
              'pronoun': null,
              'preposition': null,
              'conjunction': null,
              'interjection': null,
            };
            Map<String, List<String>> examplesByPartOfSpeech = {
              'verb': [],
              'noun': [],
              'adjective': [],
              'adverb': [],
              'pronoun': [],
              'preposition': [],
              'conjunction': [],
              'interjection': [],
            };

            // Loop through the entries in data
            for (var entry in data) {
              // Loop through meanings to find definitions and examples
              for (var meaning in entry['meanings']) {
                String partOfSpeech = meaning['partOfSpeech'] ?? '';

                // Check if part of speech is one we are interested in
                if (definitionByPartOfSpeech.containsKey(partOfSpeech)) {
                  // Capture the first definition, if available
                  if (definitionByPartOfSpeech[partOfSpeech] == null) {
                    definitionByPartOfSpeech[partOfSpeech] =
                        meaning['definitions'][0]['definition'];
                  }

                  // Capture examples, up to two
                  for (var def in meaning['definitions']) {
                    if (def.containsKey('example') &&
                        def['example'] != null &&
                        examplesByPartOfSpeech[partOfSpeech]!.length < 2) {
                      examplesByPartOfSpeech[partOfSpeech]!.add(def['example']);
                    }

                    // Stop if we have 2 examples for the current part of speech
                    if (examplesByPartOfSpeech[partOfSpeech]!.length >= 2) {
                      break;
                    }
                  }
                }
              }
            }

            // Extract the first available audio URL from phonetics
            if (data.isNotEmpty && data[0]['phonetics'].isNotEmpty) {
              for (var phonetic in data[0]['phonetics']) {
                if (phonetic['audio'] != null && phonetic['audio'].isNotEmpty) {
                  audioUrl = phonetic['audio'];
                  break; // Exit the loop once the first available audio URL is found
                }
              }
            }

            // Store results
            definitions.add(definitionByPartOfSpeech);
            examples.add(examplesByPartOfSpeech);
            audioUrls.add(audioUrl ??
                'No audio available'); // Assuming you have a list for audio URLs
            translations.add(
                translationOfWord ?? ' '); // I could get an empty translation
            // Save the data in Hive
            var box = Hive.box('userDefinitions');
            final definitionModel = DefinitionModel(
                word: word,
                definitions: definitionByPartOfSpeech,
                examples: examplesByPartOfSpeech,
                audioUrls: audioUrls,
                translations: translations);
            await box.put('${word}_${userModel!.id}', definitionModel);
          }
          print('FETCHEEEED FROM API BAYAAA');
          print('TRANSLATIONS LIST $translations');
        }
      }

      // Loop End
      // print('DEFINTIONS LENGTHHHH ${definitions.length}');
      // print('Translations LENGTHHHH ${translations.length}');
      // print('Examples LENGTHHHH ${examples.length}');
      // print('Audio LENGTHHHH ${audioUrls.length}');

      emit(FetchDefinitionsSuccessState());
    } catch (error) {
      print('ERROR $error');
      emit(FetchDefinitionsErrorState());
    }
  }

  // Update Learned Words

  void updateLearnedWords(Map<String, dynamic> learnedCounterAndList) async {
    //

    emit(UpdateLearnedWordsCounterLoadingState());
    try {
      Response response = await DioHelper.updateSingleResource(
          url: '/challenges/${goalModel!.id}/learned-words-counter',
          data: learnedCounterAndList,
          token: token);

      if (response.statusCode == 200) {
        print(
            'This is the list of learned words ------ ${goalModel!.acquiredWords}');
        emit(UpdateLearnedWordsCounterSuccessState());
      }
    } catch (error) {
      print(error);
      toastMessage(
          message: langCode == 'en'
              ? 'Unexpected Error. Try again later'
              : 'حدث خطأ غير متوقع، يرجى المحاولة لاحقًا');

      emit(UpdateLearnedWordsCounterErrorState());
    }
  }

  String selectedSegment = 'Studying';

  changeSelectedSegment(String selected) {
    selectedSegment = selected;
    emit(ChangeSelectedSegmentState());
  }
}

//

//*PDF OPERATIONS *//

//* SQL LOCAL DATABASE OPERATIONS *//

//1. Create Database
//2. Create Tables
//3. Open Database
//4. Insert Data
//5. Get Data
//5. Update Data
//6. Delete Data

// Database? localDatabase;

// void createDatabase() {
//   openDatabase('english_touch.db',
//       version:
//           1, // This is changed when you change db structure,like adding a new table
//       onCreate: (database, version) {
//     // This is called once when you create database.
//     // If database name is already there it automatically calls onOpen()
//     print('database created');
//     // Create table
//     database.execute(
//         'CREATE TABLE LearningCache (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
//   }, onOpen: (database) {
//     // This is called after creating db / immediately if db path is already there
//     print('database opened');
//   });
// }

///////********/ Firebase Operations -- GET CARDS START ************ ////////

// void controlGetCards() async {
//   if (uId.isEmpty) {
//     return;
//   }

//   CollectionReference learningCollection = FirebaseFirestore.instance
//       .collection('users')
//       .doc(uId)
//       .collection('learning');

//   // Get last saved time
//   String cacheSavedTime = CacheHelper.getData('lastUpdated_$uId') ?? '';
//   print("cacheSavedTime -------------- $cacheSavedTime");
//   // User has already saved some cards
//   if (cacheSavedTime.isNotEmpty) {
//     // Parse the string into a DateTime object
//     DateTime savedDateTime =
//         dt.DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS").parse(cacheSavedTime);

//     // This query will get me any newer documents after the savedDateTime
//     // limited it to one cause I only to check if there is newer docs or not after saved time.
//     QuerySnapshot querySnapshot = await learningCollection
//         .where('lastTouched',
//             isGreaterThan: Timestamp.fromDate(savedDateTime))
//         .orderBy('lastTouched', descending: true)
//         .limit(1)
//         .get();

//     print(
//         'THERE ARE DOCS AFTER SAVED TIME ------- ${querySnapshot.docs.length}');

//     // This query will check if there are documents or not in the collection
//     QuerySnapshot checkCollection = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(uId)
//         .collection('learning')
//         .limit(1)
//         .get();

//     print("checkCollection------ ${checkCollection.size}");

//     if (querySnapshot.docs.isNotEmpty || checkCollection.size == 0) {
//       // There are newer documents after the saved timestamp

//       // This will be called when:
//       // 1- User accessed his account via different device.
//       //(Saved time is not identical in both devices)
//       print(
//           'I already have added something.But there are some updates, or I deleted all docs');
//       // Fetch data from server
//       getCardsFromServer();
//     } else {
//       // No newer documents found
//       print('Getting your cards from cache -*_*_*_*');
//       // Fetch data from cache
//       getCardsFromCache();
//     }
//   } else {
//     //This will be called when
//     //1- a user is totally new, didn't add anything
//     //2- deleted storage from settings
//     print('I am new or deleted storage');
//     getCardsFromServer();
//   }
// }

// void getCardsFromServer() async {
//   // Remember : Cards will always start empty.

//   emit(GetCardsLoadingState());

//   FirebaseFirestore.instance
//       .collection('users')
//       .doc(uId)
//       .collection('learning')
//       .get()
//       .then((value) {
//     if (value.docs.isEmpty) {
//       print('I have no cards yet');
//       isCreateExamSelected = false;
//       cards = [];
//     } else {
//       print('--Getting cards from SERVER--');
//       cards = [];
//       // print('From Server And There is data in Firestoe ');
//       for (var element in value.docs) {
//         var data = element.data();
//         // Recieve timestamp, turn it into date time

//         data['lastTouched'] = DateTime.fromMillisecondsSinceEpoch(
//             data['lastTouched'].seconds * 1000);

//         data['docId'] = element.id;
//         cards.add(WordModel.fromJson(data));
//       }
//       // This will retrieve the latest time from server and save it in cache
//       // This way will be no need to get cards from server again

//       getMaxLastTouched();

//       emit(GetCardsSuccessState());
//     }
//   }).catchError((error) {
//     // print(error);
//     toastMessage(message: error.toString());
//     emit(GetCardsErrorState());
//   });
// }

// void getCardsFromCache() {
//   emit(GetCardsLoadingState());

//   FirebaseFirestore.instance
//       .collection('users')
//       .doc(uId)
//       .collection('learning')
//       .get(const GetOptions(source: Source.cache))
//       .then((value) {
//     print('CACHED DATA LENGTH IS ${value.docs.length}');
//     if (value.docs.isEmpty) {
//       isCreateExamSelected = false;
//       cards = [];
//     } else {
//       cards = [];

//       for (var element in value.docs) {
//         var data = element.data();
//         // Recieve timestamp, turn it into date t dts.add(data['lastTouched'].toDate());
//         data['lastTouched'] = DateTime.fromMillisecondsSinceEpoch(
//             data['lastTouched'].seconds * 1000);

//         data['docId'] = element.id;
//         cards.add(WordModel.fromJson(data));
//       }

//       // cachedCards = cards;
//       emit(GetCardsSuccessState());
//     }
//   }).catchError((error) {
//     // print(error);
//     toastMessage(message: error.toString());
//     emit(GetCardsErrorState());
//   });
// }

// // ignore: body_might_complete_normally_nullable
// Future<Timestamp?> getMaxLastTouched({bool? isFromDelete}) async {
//   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(uId)
//       .collection('learning')
//       .orderBy('lastTouched', descending: true)
//       .limit(1)
//       .get();

//   if (querySnapshot.docs.isNotEmpty) {
//     // First update the lastTouched for the card that has the latest lastTouched
//     // Because on delete there are no saved time. That's a problem when you sign in
//     // with a different device. Let's say you added 5 cards in both devices. then
//     // On one one device you deleted 4. Then you signed in with your other device
//     // You will get 5 cards . That's not good. It should save time in DB after deletion
//     if (isFromDelete != null) {
//       String latestDocId = querySnapshot.docs.first.id;

//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(uId)
//           .collection('learning')
//           .doc(latestDocId)
//           .update(
//         {
//           'lastTouched': DateTime.now(),
//         },
//       ).then((value) {
//         // String latestTime = dt.DateFormat("yyyy-MM-dd HH:mm:ss.SSS")
//         //     .format(querySnapshot.docs.first['lastTouched'].toDate())
//         //     .toString();
//         CacheHelper.saveData(
//             key: 'lastUpdated_$uId',
//             value: DateTime.now().toString().substring(0, 23));

//         String cacheSaved = CacheHelper.getData('lastUpdated_$uId');
//         print('This is cachedSaved $cacheSaved');
//       });
//     } else if (isFromDelete == null) {
//       String latestTime = dt.DateFormat("yyyy-MM-dd HH:mm:ss.SSS", 'en')
//           .format(querySnapshot.docs.first['lastTouched'].toDate())
//           .toString();
//       CacheHelper.saveData(key: 'lastUpdated_$uId', value: latestTime);
//       print('latest time is------ $latestTime');
//     }
//   } else {
//     print("NO CARDS ARE REMAINING");
//     return null;
//   }
// }

// void getCards() {
//   if (uId.isEmpty) {
//     return;
//   }
//   emit(GetCardsLoadingState());

//   if (cards.isNotEmpty && cachedCards == cards) {
//     //No need to retrieve data from firestore
//     //This means will get cars from firestore only when app launches
//     print('Getting Cards From Cache');
//     emit(GetCardsSuccessState());
//   } else {
//     print('Getting Cards From Firestore. On App Launch only');

//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(uId)
//         .collection('learning')
//         .get()
//         .then((value) {
//       if (value.docs.isEmpty) {
//         isCreateExamSelected = false;
//         cards = [];
//       } else {
//         cards = [];
//         for (var element in value.docs) {
//           var data = element.data();
//           // Recieve timestamp, turn it into date time

//           data['lastTouched'] = DateTime.fromMillisecondsSinceEpoch(
//               data['lastTouched'].seconds * 1000);

//           data['docId'] = element.id;
//           cards.add(WordModel.fromJson(data));
//         }
//         cachedCards = cards;
//         emit(GetCardsSuccessState());
//       }
//     }).catchError((error) {
//       // print(error);
//       toastMessage(message: error.toString());
//       emit(GetCardsErrorState());
//     });
//   }
// }
/////////// ********* FIREBASE GET CARDS END ******** ///////////

//// **** UPDATE FIREBASE START*** /////
// FirebaseFirestore.instance
//     .collection('users')
//     .doc(uId)
//     .collection('learning')
//     .doc(docId)
//     .update({
//   'documentAttributes': documentAttributes,
//   'editedWords': editedWords,
//   'sentence': sentence,
//   'source': source,
//   'transDocumentAttributes': transDocumentAttributes,
//   'translation': translation,
//   'lastTouched': lastTouched
// }).then((value) {
//   CacheHelper.saveData(
//           key: 'lastUpdated_$uId',
//           value: lastTouched.toString().substring(0, 23))
//       .then((value) {
//     cards
//         .removeWhere((element) => element.docId == docId); //first remove it

//     // Then add it as brand-new card but with same previous docId
//     // Already in add card you get doc id and then save in cards
//     cards.add(WordModel.fromJson({
//       'documentAttributes': documentAttributes,
//       'editedWords': editedWords,
//       'sentence': sentence,
//       'source': source,
//       'transDocumentAttributes': transDocumentAttributes,
//       'translation': translation,
//       'docId': docId
//     }));
//   });

//   cachedCards = cards;

//   emit(UpdateCardSuccessState());
// }).catchError((error) {
//   //print(error);
//   toastMessage(message: error.toString());
// });
/////////// ********* FIREBASE UPDATE CARDS END ******** ///////////

/////////// ********* FIREBASE DELETE CARD START ******** ///////////
//void deleteCard({required docId, DateTime? lastTouched}) {
// FirebaseFirestore.instance
//     .collection('users')
//     .doc(uId)
//     .collection('learning')
//     .doc(docId)
//     .delete()
//     .then((value) {
//   getMaxLastTouched(isFromDelete: true);
//   CacheHelper.saveData(
//           key: 'lastUpdated_$uId',
//           value: lastTouched.toString().substring(0, 23))
//       .then((value) {
//     cards.removeWhere((element) => element.docId == docId);
//     emit(DeleteCardSuccessState());
//   }).catchError((e) {
//     toastMessage(message: 'لم تتم عملية الحذف بنجاح. يرجى المحاولة لاحقًا');
//   });
// }).catchError((error) {
//   toastMessage(message: 'لم تتم عملية الحذف بنجاح. يرجى المحاولة لاحقًا');
// });
//  }

/////////// ********* FIREBASE DELETE CARDS END ******** ///////////
