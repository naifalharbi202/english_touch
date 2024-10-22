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
String token = ''; //Switched to Laravel
String deadlineStr = '';
int wordsGoalCount = 0;
DateTime deadlineDt = DateTime.now();
dynamic challenge;
bool isTimerFinished = false;
String cacheSavedTime = '';
List<WordModel> cards = [];
List<WordModel> cachedCards = [];
List<WordModel> searchedCards = [];
List<dynamic> retrievedWords = [];
List<dynamic> retrievedSentences = [];
List<dynamic> highlightedWords = [];
List<dynamic> examWords = [];
int? currentWordStart, currentWordEnd;
bool isSpeakOn = false;
bool isComingFromResults = false;
bool isCardsEmpty = true;
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
bool isSearching = false;
double fontSelectedSize = 16;

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
          Text(S.of(context).book,
              style: Theme.of(context).textTheme.bodyLarge),
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
          Text(S.of(context).movie,
              style: Theme.of(context).textTheme.bodyLarge),
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
          Text(S.of(context).friend,
              style: Theme.of(context).textTheme.bodyLarge),
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
            style: Theme.of(context).textTheme.bodyLarge,
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
          Text(S.of(context).another_source,
              style: Theme.of(context).textTheme.bodyLarge),
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

String longText = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla nec nisi quam. Ut consectetur tortor risus, id efficitur magna lacinia sit amet. Nullam nec odio id arcu dapibus eleifend. Integer sed mi luctus, lacinia velit ac, condimentum sapien. Vivamus nec leo a turpis posuere aliquet nec non nisi. Cras sit amet metus feugiat, tincidunt turpis nec, bibendum nisi. Aliquam nec justo est. Vivamus consequat sapien id urna consectetur, sed bibendum velit fermentum. Vivamus id velit fringilla, consequat risus sit amet, malesuada urna. Proin eu ex rutrum, vestibulum nisi in, ultricies enim. Phasellus dapibus elit non ultrices malesuada. In hac habitasse platea dictumst. Sed eu arcu vel neque facilisis fringilla in ac velit. Morbi porttitor, sapien sed sollicitudin elementum, justo elit venenatis neque, et volutpat metus augue non lacus. Mauris efficitur nunc et libero volutpat, nec dapibus dui finibus. Duis eleifend efficitur elit, eget venenatis libero mollis et.

Integer vitae consectetur mi. Donec a mi eu neque dictum facilisis nec nec nulla. Vestibulum et feugiat leo. Sed vel mi eu quam fermentum dignissim. Donec laoreet consequat justo non commodo. Suspendisse sit amet justo odio. Pellentesque et augue orci. Suspendisse potenti. Ut congue tempor sem, id lacinia nisi pulvinar a. Curabitur dapibus bibendum orci, id varius leo tristique ut. Ut ut magna non est dictum varius. Fusce luctus risus id diam aliquet auctor. Sed accumsan nisi eu dui facilisis, quis rhoncus nisl lacinia. Sed vestibulum risus at ipsum tincidunt, sed convallis justo sagittis. Nam non sapien id libero elementum malesuada.

Sed vitae interdum metus. Cras hendrerit, nulla ut vulputate efficitur, nisi libero scelerisque nunc, in sagittis velit justo sit amet risus. Curabitur id ligula nunc. Donec rhoncus, sem a luctus lacinia, mi metus vehicula metus, in tincidunt justo ligula sed tortor. Nullam ut dictum tortor. Aliquam feugiat dolor ac ipsum suscipit, vel euismod nisi dictum. Curabitur a libero ligula. Nulla facilisi. Phasellus feugiat felis eget enim malesuada egestas. Mauris ut leo nec urna malesuada pharetra. Curabitur suscipit ante vel elit euismod, vitae hendrerit purus egestas. Quisque ac odio id felis viverra eleifend. Nam id sapien dolor. Integer commodo ex at nunc sollicitudin lacinia.

Morbi scelerisque quam vitae lorem luctus, et ultricies odio efficitur. In nec nisl at quam congue vestibulum. Nullam auctor nunc quis semper ullamcorper. Nam id eleifend nibh. Cras eu turpis nec velit luctus gravida. Nullam quis purus orci. Vestibulum fermentum efficitur faucibus. Vestibulum quis elit scelerisque, tristique erat eget, egestas orci. In consectetur tortor sit amet quam rhoncus, in tempus mi congue. Pellentesque ut justo nec leo tempus laoreet at at risus. Sed pellentesque nisi eget eros facilisis, id tincidunt metus tempor. Sed laoreet volutpat enim, nec laoreet eros eleifend sit amet. Sed eu purus dolor. Ut in nulla ipsum.

Fusce venenatis vehicula ante, eget euismod nisi eleifend at. Nulla id mauris sit amet augue convallis dapibus. Ut ut semper urna. Phasellus vehicula elit a odio lacinia, vitae placerat justo aliquam. Proin laoreet tempor enim nec suscipit. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Pellentesque non augue a dui malesuada vestibulum. Donec scelerisque nisl a nisi dapibus, eget placerat nulla dictum. Duis posuere enim nec ante accumsan, vel pellentesque dui ullamcorper. Duis id purus a metus pharetra commodo a vel turpis. Integer hendrerit metus id urna venenatis, ut lacinia dui gravida. Phasellus eget odio at quam dictum rhoncus. Suspend

''';
