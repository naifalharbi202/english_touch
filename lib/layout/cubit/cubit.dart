import 'dart:convert';
import 'dart:io';

import 'package:call_me/generated/l10n.dart';
import 'package:call_me/layout/cubit/states.dart';

import 'package:call_me/models/exam_model.dart';
import 'package:call_me/models/user_model.dart';
import 'package:call_me/models/word_model.dart';
import 'package:call_me/modules/exam/exam_screen.dart';
import 'package:call_me/modules/homepage/home_screen.dart';
import 'package:call_me/modules/setting/settings_screen.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/local/cachehelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  void translateText(String text) {
    emit(TranslationLoadingState());
    text.translate(from: 'auto', to: 'ar').then((value) {
      translatedText = value.text;

      emit(TranslationSuccessState());
    }).catchError((error) {
      toastMessage(message: error);
      emit(TranslationErrorState());
    });
  }

  UserModel? userModel;
  //Get One User
  void getUser() async {
    if (uId.isEmpty) {
      return; // Because a document path must be a non-empty string
    }
    // First go and get userData saved in cache by his unuqie uId
    final userCache = CacheHelper.getUserData('userModel_$uId');
    if (userCache != null) {
      userModel = UserModel.fromJson(userCache);
      print('$userModel FROM CACHE. No FIRESTORE');
      emit(GetUserSuccessState());
    } else {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uId).get();
      userModel = UserModel.fromJson(userDoc.data());
      CacheHelper.saveUserData('userModel_$uId', userDoc.data()!).then((value) {
        print('$userModel FROM FIRESTORE. But SAVED IN CACHE');
        emit(GetUserSuccessState());
      }).catchError((error) {
        emit(GetUserErrorState());
      });
    }
  }

  //Forgot password
  void forgetPassword({required email}) {
    emit(SendPasswordResetLoadingState());

    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      emit(SendPasswordResetSuccessState());
    }).catchError((error) {
      toastMessage(message: 'حدث خطأ');
      emit(SendPasswordResetErrorState());
    });
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
    required document,
  }) {
    if (document == sentenceDoc || document == sentenceRetrievedDoc) {
      return QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0),
          onSelectionChanged: (value) {
            // print('Sentence Doc');
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
    // Already filled
    if (retrievedWords.isNotEmpty ||
        retrievedSentences.isNotEmpty && cards.isNotEmpty) {
      print('CAAAACCCCHEEE');
      print('RETRIEVED WORDS IS NOT EMPTY : $retrievedWords');
      print('RETRIEVED SENTENCE ::::: $retrievedSentences ');
      if (isEnglishExam) {
        print('It is ENGLISH EXAM');
        // Priority: Exam about higlighted words
        generateQuestion();
      } else {
        print('It is ARABIC EXAM');
        // Priority: Exam about higlighted words
        generateArabicQuestion();
      }
    }

    // Not filled yet. Go get them from server
    if (retrievedWords.isEmpty && retrievedSentences.isEmpty) {
      print('FIRESTORE GETGETGETGETGET');
      // Get it for the first time
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('learning')
          .get()
          .then((value) {
        retrievedWords = [];
        retrievedSentences = [];
        for (var element in value.docs) {
          WordModel model = WordModel.fromJson(element.data());

          retrievedWords += model.editedWords!;

          retrievedSentences.add(model.sentence); // Will always have value
        }
        if (isEnglishExam) {
          if (retrievedWords.isNotEmpty) {
            // Priority: Exam about higlighted words
            generateQuestion();
          } else if (retrievedWords.isEmpty && retrievedSentences.isNotEmpty) {
            generateQuestion();
          } else {
            isExamGenerated = false;
            emit(GetEditedWordsEmptyState());
          }
        } else {
          if (retrievedWords.isNotEmpty) {
            // Priority: Exam about higlighted words
            generateArabicQuestion();
          } else if (retrievedWords.isEmpty && retrievedSentences.isNotEmpty) {
            generateArabicQuestion();
          } else {
            isExamGenerated = false;

            emit(GetEditedWordsEmptyState());
          }
        }
      }).catchError((error) {
        //  print("ERROR GETTING WORDS");
      });
    }
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

  // Firebase Operations //-- ADD NEW CARD
  WordModel? wordModel;
  void addCard({
    required String sentence,
    String? translation,
    List<String>? editedWords,
    String? pickedSource,
    List<Map<String, dynamic>>? docAttributrs,
    List<Map<String, dynamic>>? transDocAttributrs,
  }) {
    emit(AddCardLoadingState());
    wordModel = WordModel(
      sentence,
      translation,
      editedWords,
      pickedSource,
      docAttributrs,
      transDocAttributrs,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('learning')
        .add(wordModel!.toJson())
        .then((value) {
      currentIndex = 0;
      isCreateExamSelected = false;
    }).catchError((error) {
      toastMessage(message: error.toString());
      emit(AddCardErrorState());
    });
  }

  // Firebase Operations -- GET CARDS
  void getCards() {
    if (uId.isEmpty) {
      return;
    }
    emit(GetCardsLoadingState());

    // ListenSource.cache brings data from cache
    // Let's say I added new card from firebas

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('learning')
        .snapshots()
        .listen((value) {
      if (value.docs.isEmpty) {
        isCreateExamSelected = false;
        cards = [];
      } else {
        cards = [];
        for (var element in value.docs) {
          var data = element.data();
          data['docId'] = element.id;
          cards.add(WordModel.fromJson(data));
        }

        emit(GetCardsSuccessState());
      }
    }).onError((error) {
      // print(error);
      toastMessage(message: error.toString());
      emit(GetCardsErrorState());
    });
  }

  // Firebase Operations -- DELETE A CARD
  void deleteCard({required docId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('learning')
        .doc(docId)
        .delete()
        .then((value) {
      emit(DeleteCardSuccessState());
      getCards();
    }).catchError((error) {
      toastMessage(message: 'لم تتم عملية الحذف بنجاح. يرجى المحاولة لاحقًا');
    });
  }

  // Firebase Operations -- UPDATE A CARD
  void updateCard({
    required docId,
    documentAttributes,
    editedWords,
    sentence,
    source,
    transDocumentAttributes,
    translation,
  }) {
    emit(UpdateCardLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('learning')
        .doc(docId)
        .update({
      'documentAttributes': documentAttributes,
      'editedWords': editedWords,
      'sentence': sentence,
      'source': source,
      'transDocumentAttributes': transDocumentAttributes,
      'translation': translation,
    }).then((value) {
      emit(UpdateCardSuccessState());
    }).catchError((error) {
      //print(error);
      toastMessage(message: error.toString());
    });
  }

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

// Handling Lost Data On Low Memory
  // Future<void> getLostData() async {
  //   final LostDataResponse response = await picker.retrieveLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   final List<XFile>? files = response.files;
  //   if (files != null) {
  //     image = File(files.first.path);

  //   } else {
  //     print('Exception Exception _______');
  //   }
  // }

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

// Sign Out //

  void signOut(context, Widget destination) async {
    await FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData('uId').then((value) {
        navigateAndFinish(context, destination);
        emit(SignOutSuccessState());
      });
    }).catchError((error) {
      toastMessage(message: 'حدث خطأ عند تسجيل الخروج');
      emit(SignOutErrorState());
    });
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

  // Cache the initial data
  testReads() {
    cardsDataStream =
        FirebaseFirestore.instance.collection('users').doc(uId).snapshots();
    print(cardsDataStream);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((snapshot) {
      cachedData = snapshot;
      print('cachedData ------ $cachedData');

      // emit state
    });
  }

  //* SQL LOCAL DATABASE OPERATIONS *//

  //1. Create Database
  //2. Create Tables
  //3. Open Database
  //4. Insert Data
  //5. Get Data
  //5. Update Data
  //6. Delete Data

  Database? localDatabase;

  void createDatabase() {
    openDatabase('english_touch.db',
        version:
            1, // This is changed when you change db structure,like adding a new table
        onCreate: (database, version) {
      // This is called once when you create database.
      // If database name is already there it automatically calls onOpen()
      print('database created');
      // Create table
      database.execute(
          'CREATE TABLE LearningCache (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
    }, onOpen: (database) {
      // This is called after creating db / immediately if db path is already there
      print('database opened');
    });
  }
}
