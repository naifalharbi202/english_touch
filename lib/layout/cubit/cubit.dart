import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/models/word_model.dart';
import 'package:call_me/modules/courses/courses_screen.dart';
import 'package:call_me/modules/homepage/home_screen.dart';
import 'package:call_me/modules/setting/settings_screen.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

// current inext of bottom nav bar
  int currentIndex = 0;

// List of screens to move to based on currentIndex value
  List<Widget> screens = [
    const HomeScreen(),
    const CoursesScreen(),
    const SettingsScreen(),
  ];

  void changeBottomNaveIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
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

  static bool isCursorOnSentence = false;

  static bool isToolBarShown = true;
  static final Document sentenceDoc = Document();
  static final Document translationDoc = Document();
  //On Text Change Quill Editor
  void changeToolbar() {
    {
      emit(ChangeToolBarState());
    }
  }

  void hideToolbar(
    bool val,
  ) {
    isToolBarShown = val;
  }

  QuillController fieldController({
    required document,
  }) {
    if (document == AppCubit.sentenceDoc) {
      emit(ChangeToolBarState());
      return QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0),
          onSelectionChanged: (value) {
            isCursorOnSentence = true;
          });
    } else {
      emit(ChangeToolBarState());
      return QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0),
          onSelectionChanged: (value) {
            isCursorOnSentence = false;
          });
    }
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
      toastMessage(message: error.toString());
      emit(GetVoiceErrorState());
    });
  }

  void setVoice(Map voices) {
    flutterTts.setVoice({'name': voices['name'], 'locale': voices['locale']});
  }

  // Firebase Operations -- ADD NEW CARD
  WordModel? wordModel;
  void addCard({
    required String sentence,
    String? translation,
    List<String>? editedWords,
    String? pickedSource,
  }) {
    emit(AddCardLoadingState());
    wordModel = WordModel(
      sentence,
      translation,
      editedWords,
      pickedSource,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('learning')
        .add(wordModel!.toJson())
        .then((value) {
      getCards();
    }).catchError((error) {
      toastMessage(message: error.toString());
      emit(AddCardErrorState());
    });
  }

  // Firebase Operations -- GET CARDS
  void getCards() {
    emit(GetCardsLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('learning')
        .get()
        .then((value) {
      for (var element in value.docs) {
        cards.add(WordModel.fromJson(element.data()));
      }

      emit(GetCardsSuccessState());
    }).catchError((error) {
      toastMessage(message: error.toString());
      emit(GetCardsErrorState());
    });
  }

  // Firebase Operations -- DELETE A CARD

  void deleteCard() {}
}
