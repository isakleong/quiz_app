
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'quiz.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class Quiz {
  @HiveField(1)
  @JsonKey(name: "QuizID")
  String quizID = "";

  @HiveField(1)
  @JsonKey(name: "QuestionID")
  String questionID = "";
  
  @HiveField(2)
  @JsonKey(name: "Question")
  String question = "";

  @HiveField(3)
  @JsonKey(name: "Category")
  String category = "";

  @HiveField(4)
  @JsonKey(name: "AnswerSelected")
  int answerSelected = 0;

  @HiveField(5)
  @JsonKey(name: 'AnswerText')
  List<String> answerList = [];

  @HiveField(6)
  @JsonKey(name: 'Correct')
  List<String> correctAnswerList = [];

  @HiveField(7)
  @JsonKey(name: "CorrectAnswerIndex")
  int correctAnswerIndex = 0;

  Quiz({required this.questionID, required this.question, required this.category, required this.answerSelected, required this.answerList, required this.correctAnswerList, required this.correctAnswerIndex});

  factory Quiz.from(Map<String, dynamic> json) => _$QuizFromJson(json);

  Map<String, dynamic> toJson() => _$QuizToJson(this);

}