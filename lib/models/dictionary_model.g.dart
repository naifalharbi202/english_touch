// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DefinitionModelAdapter extends TypeAdapter<DefinitionModel> {
  @override
  final int typeId = 0;

  @override
  DefinitionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DefinitionModel(
      word: fields[0] as String,
      definitions: (fields[1] as Map).cast<String, String?>(),
      examples: (fields[2] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<String>())),
      audioUrls: (fields[3] as List).cast<String?>(),
      translations: (fields[4] as List).cast<String?>(),
    );
  }

  @override
  void write(BinaryWriter writer, DefinitionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.definitions)
      ..writeByte(2)
      ..write(obj.examples)
      ..writeByte(3)
      ..write(obj.audioUrls)
      ..writeByte(4)
      ..write(obj.translations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefinitionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
