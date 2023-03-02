
import 'package:json_annotation/json_annotation.dart';
import 'package:quiz_app/models/answer.dart';
part 'quiz.g.dart';

@JsonSerializable()
class Quiz {
  @JsonKey(name: "QuestionID")
  String questionID = "";
  
  @JsonKey(name: "Question")
  String question = "";

  @JsonKey(name: "Kategori")
  String category = "";

  @JsonKey(name: "AnswerSelected")
  int answerSelected = 0;

  @JsonKey(name: 'AnswerText')
  List<String> answerList = [];

  @JsonKey(name: 'Correct')
  List<String> correctAnswerList = [];

  Quiz({required this.questionID, required this.question, required this.category, required this.answerSelected, 
  required this.answerList, required this.correctAnswerList});

  factory Quiz.from(Map<String, dynamic> json) => _$QuizFromJson(json);

  Map<String, dynamic> toJson() => _$QuizToJson(this);

}