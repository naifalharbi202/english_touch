import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class WordModel {
  String? sentence;
  String? translation;
  List<dynamic>? editedWords;
  String? source;
  int? docId;
  List<dynamic>? documentAttributes;
  List<dynamic>? transDocumentAttributes;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? userId;
  int? id;

// Constructer to create a word s    model instance
  WordModel(
    this.sentence,
    this.translation,
    this.editedWords,
    this.source,
    this.documentAttributes,
    this.transDocumentAttributes,
    this.createdAt,
    this.updatedAt,
    this.userId,
  );

  // Named constructer .. To get data from firestore
  WordModel.fromJson(Map<String, dynamic>? json) {
    sentence = json!['sentence'];
    translation = json['translation'];
    editedWords = jsonDecode(json['edited_words']);
    source = json['source'];
    docId = json['id'];
    documentAttributes = jsonDecode(json['document_attributes']);
    transDocumentAttributes = jsonDecode(json['trans_doc_attributes']);
    createdAt = json['created_at'] != null
        ? DateTime.tryParse(json['created_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? DateTime.tryParse(json['updated_at'])
        : null;
    userId = json['user_id'];
    id = json['id']; // No need to send it
  }

  // Func to send data as a map (to sentence collection in firestore)
  Map<String, dynamic> toJson() {
    return {
      'sentence': sentence,
      'translation': translation,
      'edited_words': jsonEncode(editedWords),
      'source': source,
      'document_attributes': jsonEncode(documentAttributes),
      'trans_doc_attributes': jsonEncode(transDocumentAttributes),
    };
  }

  // static List<String> _parseEditedWords(dynamic editedWordsJson) {
  //   if (editedWordsJson == null) {
  //     return [];
  //   }

  //   // Check if editedWordsJson is already List<String>
  //   if (editedWordsJson is List) {
  //     return editedWordsJson.map((e) => e.toString()).toList();
  //   }

  //   // Parse JSON string into List<String>
  //   try {
  //     List<dynamic> parsedList = jsonDecode(editedWordsJson);
  //     return parsedList.map((e) => e?.toString() ?? '').toList();
  //   } catch (e) {
  //     print('Error parsing edited_words: $e');
  //     return [];
  //   }
  // }
}
