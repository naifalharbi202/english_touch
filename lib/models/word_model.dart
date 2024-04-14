﻿class WordModel {
  String? sentence;
  String? translation;
  List<dynamic>? editedWords;
  String? source;

// Constructer to create a word s    model instance
  WordModel(
    this.sentence,
    this.translation,
    this.editedWords,
    this.source,
  );

  // Named constructer .. To get data from firestore
  WordModel.fromJson(Map<String, dynamic>? json) {
    sentence = json!['sentence'];
    translation = json['translation'];
    editedWords = json['editedWords'];
    source = json['source'];
  }

  // Func to send data as a map (to sentence collection in firestore)
  Map<String, dynamic> toJson() {
    return {
      'sentence': sentence,
      'translation': translation,
      'editedWords': editedWords,
      'source': source,
    };
  }
}
