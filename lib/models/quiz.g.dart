// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quiz _$QuizFromJson(Map<String, dynamic> json) => Quiz(
      questionID: json['QuestionID'] as String,
      question: json['Question'] as String,
      category: json['Kategori'] as String,
      answerSelected: json['AnswerSelected'] as int,
      answerList: (json['AnswerText'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      correctAnswerList:
          (json['Correct'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'QuestionID': instance.questionID,
      'Question': instance.question,
      'Kategori': instance.category,
      'AnswerSelected': instance.answerSelected,
      'AnswerText': instance.answerList,
      'Correct': instance.correctAnswerList,
    };
