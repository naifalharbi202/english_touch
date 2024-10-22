class GoalModel {
  int? id; // Assuming this is the primary key
  int? userId; // Foreign key
  int? numberOfWords;
  DateTime? startDate;
  DateTime? endDate;
  int? learnedWordsCounter;

  // Constructor to create a GoalModel instance
  GoalModel(this.id, this.userId, this.numberOfWords, this.startDate,
      this.endDate, this.learnedWordsCounter);

  // Named constructor to get data from Firestore (or any JSON source)
  GoalModel.fromJson(Map<String, dynamic>? json) {
    id = json!['id'];
    userId = json['user_id'];
    numberOfWords = json['number_of_words'];
    startDate = DateTime.tryParse(json['start_date']);
    endDate = DateTime.tryParse(json['end_date']);
    learnedWordsCounter = json['learned_words_counter'];
  }

  // Function to send data as a map (to Firestore or any API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'number_of_words': numberOfWords,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'learned_words_counter': learnedWordsCounter
    };
  }
}
