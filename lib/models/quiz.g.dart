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
      questionID: fields[2] as String,
      question: fields[3] as String,
      category: fields[4] as String,
      answerSelected: fields[5] as int,
      answerList: (fields[6] as List).cast<String>(),
      correctAnswerList: (fields[7] as List).cast<String>(),
      correctAnswerIndex: fields[8] as int,
    )..quizID = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, Quiz obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.quizID)
      ..writeByte(2)
      ..write(obj.questionID)
      ..writeByte(3)
      ..write(obj.question)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.answerSelected)
      ..writeByte(6)
      ..write(obj.answerList)
      ..writeByte(7)
      ..write(obj.correctAnswerList)
      ..writeByte(8)
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
    )..quizID = json['QuizID'] as String;

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'QuizID': instance.quizID,
      'QuestionID': instance.questionID,
      'Question': instance.question,
      'Category': instance.category,
      'AnswerSelected': instance.answerSelected,
      'AnswerText': instance.answerList,
      'Correct': instance.correctAnswerList,
      'CorrectAnswerIndex': instance.correctAnswerIndex,
    };
