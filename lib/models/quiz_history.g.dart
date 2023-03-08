// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizHistory _$QuizHistoryFromJson(Map<String, dynamic> json) => QuizHistory(
      salesID: json['SalesID'] as String,
      name: json['Name'] as String,
      tanggal: json['Tanggal'] as String,
      passed: json['Passed'] as String,
    );

Map<String, dynamic> _$QuizHistoryToJson(QuizHistory instance) =>
    <String, dynamic>{
      'SalesID': instance.salesID,
      'Name': instance.name,
      'Tanggal': instance.tanggal,
      'Passed': instance.passed,
    };
