import 'package:hive/hive.dart';

part 'dictionary_model.g.dart'; // You need to run build_runner to generate this

@HiveType(typeId: 0)
class DefinitionModel extends HiveObject {
  @HiveField(0)
  final String word;

  @HiveField(1)
  final Map<String, String?> definitions;

  @HiveField(2)
  final Map<String, List<String>> examples;

  @HiveField(3)
  final List<String?> audioUrls;

  @HiveField(4)
  final List<String?> translations;

  DefinitionModel({
    required this.word,
    required this.definitions,
    required this.examples,
    required this.audioUrls,
    required this.translations,
  });
}
