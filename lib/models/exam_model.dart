class ExamModel {
  String? question;
  List<String>? answers;
  String? correctAnswer;

  // Constructer to create an exam model instance
  ExamModel(
    this.question,
    this.answers,
    this.correctAnswer,
  );

  // Named constructer .. To get data from firestore
  ExamModel.fromJson(Map<String, dynamic> json) {
    question = json['question']['question'];
    answers = json['question']['answers'];
    correctAnswer = json['question']['correctAnswer'];
  }
}
