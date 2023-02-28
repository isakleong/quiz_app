// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quiz _$QuizFromJson(Map<String, dynamic> json) => Quiz(
      questionID: json['QuestionID'] as String,
      question: json['Question'] as String,
      category: json['Kategori'] as String,
      // answerList: (json["AnswerText"] as List)
      //       ?.map((e) => 
      //         e == null ? null : Answer.fromJson(e as Map<String, dynamic>))
      //       ?.toList() ??
      //     [],
      // answerList: json["AnswerText"].map((i) => Answer.from(i as Map<String, dynamic>)).toList(),
      answerList: (json['AnswerText'] as List<dynamic>)
          .map((e) => Answer.from(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'QuestionID': instance.questionID,
      'Question': instance.question,
      'Kategori': instance.category,
      'AnswerText': instance.answerList,
    };
