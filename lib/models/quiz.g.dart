// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizAdapter extends TypeAdapter<Quiz> {
  @override
  final int typeId = 0;

  @override
  Quiz read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quiz(
      questionID: fields[0] as String,
      question: fields[1] as String,
      category: fields[2] as String,
      answerSelected: fields[3] as int,
      answerList: (fields[4] as List).cast<String>(),
      correctAnswerList: (fields[5] as List).cast<String>(),
      correctAnswerIndex: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Quiz obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.questionID)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.answerSelected)
      ..writeByte(4)
      ..write(obj.answerList)
      ..writeByte(5)
      ..write(obj.correctAnswerList)
      ..writeByte(6)
      ..write(obj.correctAnswerIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quiz _$QuizFromJson(Map<String, dynamic> json) => Quiz(
      questionID: json['QuestionID'] as String,
      question: json['Question'] as String,
      category: json['Category'] as String,
      answerSelected: json['AnswerSelected'] as int,
      answerList: (json['AnswerText'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      correctAnswerList:
          (json['Correct'] as List<dynamic>).map((e) => e as String).toList(),
      correctAnswerIndex: json['CorrectAnswerIndex'] as int,
    );

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'QuestionID': instance.questionID,
      'Question': instance.question,
      'Category': instance.category,
      'AnswerSelected': instance.answerSelected,
      'AnswerText': instance.answerList,
      'Correct': instance.correctAnswerList,
      'CorrectAnswerIndex': instance.correctAnswerIndex,
    };
