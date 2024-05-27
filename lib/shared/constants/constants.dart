import 'package:call_me/generated/l10n.dart';
import 'package:call_me/models/word_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

// ignore: constant_identifier_names
const GEMINIAPI = 'AIzaSyDgkGAPltN9ke9Mj290CHNzIHptyLO7mYc';

String prompt(List wordsOfTheExam) {
  // print('THESE ARE WORDS OF EXAM::::::::::::: $wordsOfTheExam');
  return '''Generate a JSON object 
representing an English exam with multiple-choice questions. Exam must be 10 or 15 Questions at least.
Each question object should have the following properties:
* question (string): The question itself, based on the list of these words/phrases $wordsOfTheExam  
* answers (list of strings): A list containing three answer choices (A, B, and C).
* correctAnswer (string): The letter (A, B, or C) corresponding to the correct answer.

**Here's an example with placeholders [IMPORTANT : questions below are just examples. Please do not use these questions unless they are part og this list of words: $wordsOfTheExam]:**
{
    "question 1":{
    "question": "What is the synonym of happy?",
    "answers": ["A) Sad", "B) Joyful", "C) Angry"],
    "correctAnswer": "B"
    },
    "question 2":{
    "question": "Which word has the same meaning as \"beautiful\"?",
    "answers": ["A) Ugly.", "B) Stunning.", "C) Dull."],
    "correctAnswer": "B" 
    }
}

**Please Prepare The Data Format To Be Saved In A Map<String,dynamic>.Remove Any Unexpected Charachters **

**Please use this list of words: $wordsOfTheExam to generate questions that ONLY FOCUS on testing English skills like vocabulary,synonyms,antonyms,grammar and sentence construction. Don't generate people-related questions**
**if any of these words/phrases $wordsOfTheExam contains mistakes. correct them, and then generate questions**
**You are a great English teacher. So generate good questions and accurate correct answer**
**NEVER generate fill in the blank type of questions.NEVER**
**Do not start your response with json word. Just generate the json format as if it was a text**
**Generate accurate questions and answers**
**Remember do not use example questions above. These are just to give you idea about questions nature**
''';
}

String arabicPrompt(List wordsOfTheExam) {
  // print('THESE ARE WORDS OF EXAM::::::::::::: $wordsOfTheExam');
  return '''
أنت تخاطب ناطقًا باللغة العربية، أريد منك أ تُنشئ لي Json Object يمثل اختبار من متعدد يختبر مهارات اللغة الإنجليزية شريطة أن تكون أسئلته باللغة العربية وأن يكون مكون من 10 أسئلة وكل سؤال له ثلاث خيارات. كل سؤال في الjson object يجب أن تكون له الخصائص التالية :

*question من نوع String : وهذا يمثل السؤال نفسه بناءً على هذه القائمة من الكلمات أو العبارات $wordsOfTheExam
*answers من نوع List of strings : وهذه قائمة تحوي ثلاث اختيارات للإجابة A - B - C
*correctAnswer من نوع String: وهذا هو حرف الإجابة الموافق للإجابة الصحيحة  A أو B أو C

**إليك مثال مزود بالعناصر النائبة (placeholders):

{
    "question 1":{
        "question":"ما مرادف كلمة سعيد باللغة الإنجليزية؟",
        "answers": [
            "A) Sad",
            "B) Joyful",
            "C) Angry"
        ],
        "correctAnswer": "B"
    },
    "question 2":{
        "question":"كيف تقول أريدك أن تسدي إليّ معروفًا بالإنجليزية؟",
        "answers": [
            "A) Can you give me a favor? .",
            "B) Can you make me a favor?.",
            "C) Can you do me a favor?."
        ],
        "correctAnswer": "C"
    }

التزم بنفس هذا التنسيق تماماً حتى في المسافات.. لا تكتب السؤال الأول مثلًا بدلاً من 
question 1
أو تكتب
question1
أو تكتب أرقام
التزم بنفس التنسيق 

** الإجابة الصحيحة يجب أن تكون صحيحة بالفعل، بمعنى ليس شرط أن الكلمات أو الجمل المعطاة هي الصحيحة**
** اعتبر نفسك خبيرًا في اللغة الإنجليزية **
** الرجاء استخدام قائمة الكلمات هذه: $wordsOfTheExam لإنشاء أسئلة تركز فقط على اختبار مهارات اللغة الإنجليزية مثل المفردات والمرادفات والمتضادات والقواعد وبناء الجملة. لا تطرح أسئلة متعلقة بالأشخاص**
** لا تقم أبدًا بإنشاء أسئلة من نوع أكمل الفراغ. أبدًا **
** لا تبدأ ردك بكلمة json. ما عليك سوى إنشاء تنسيق json كما لو كان نصًا**
** توليد أسئلة وأجوبة دقيقة **
**تذكر عدم استخدام الأسئلة النموذجية أعلاه. هذه فقط لإعطائك فكرة عن طبيعة الأسئلة**
''';
}

List answers = [];
bool isSelected = false;
bool isExamGenerated = false;
bool isCreateExamSelected = false;
String source = '';
String uId = '';
List<WordModel> cards = [];
List<dynamic> retrievedWords = [];
List<dynamic> retrievedSentences = [];
List<dynamic> examWords = [];
int? currentWordStart, currentWordEnd;
bool isSpeakOn = false;
bool isComingFromResults = false;
int wordsCounter = 0;
List<String> words = [];
Map<String, dynamic> myExamMap = {};
Map<String, dynamic> myArabicExamMap = {};
int currentQuestionNum = 1;
int numOfCorrectAnswers = 0;
bool isSwipedtoHalf = false;
bool isTextExtracted = false;
String extractedText = '';
bool isEnglishExam = false;
bool isArabicExam = false;
Document sentenceRetrievedDoc = Document();
Document translationRetrievedDoc = Document();
bool isDark = false;
bool isImagePicked = false;
List<String> cachedSources = [];
final regex = RegExp(r'^[a-zA-Z0-9\s]+$');
bool? isAppLanguageEnglish;
String langCode = '';

List<PopupMenuItem> sourceMenuItems(context) {
  return <PopupMenuItem>[
    // Book Item
    PopupMenuItem(
      value: S.of(context).book,
      child: Row(
        children: [
          const Icon(
            Icons.book,
            color: Colors.amber,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            S.of(context).book,
            style: const TextStyle(
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    ),
    // Movie Item
    PopupMenuItem(
      value: S.of(context).movie,
      child: Row(
        children: [
          const Icon(
            Icons.movie_creation_outlined,
            color: Colors.lightBlue,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            S.of(context).movie,
            style: const TextStyle(
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    ),
    //Friend Item
    PopupMenuItem(
      value: S.of(context).friend,
      child: Row(
        children: [
          const Icon(
            Icons.person_3_outlined,
            color: Colors.green,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            S.of(context).friend,
            style: TextStyle(
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    ),
    PopupMenuItem(
      value: S.of(context).school,
      child: Row(
        children: [
          const Icon(
            Icons.school,
            color: Colors.purpleAccent,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            S.of(context).school,
            style: const TextStyle(
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    ),
    PopupMenuItem(
      value: "DiffSource",
      child: Row(
        children: [
          const Icon(
            Icons.difference,
            color: Colors.redAccent,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            S.of(context).another_source,
            style: const TextStyle(
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    ),
  ];
}

// Main menu vertical items
final List<PopupMenuItem> mainItems = [
  const PopupMenuItem(
    value: "settings",
    child: Row(
      children: [
        Icon(
          Icons.settings,
          color: Colors.grey,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          'الإعدادات',
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
      ],
    ),
  ),
  const PopupMenuItem(
    value: "logout",
    child: Row(
      children: [
        Icon(
          Icons.logout,
          color: Colors.grey,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          'تسجيل خروج',
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
      ],
    ),
  ),
];
