import 'package:json_annotation/json_annotation.dart';
part 'answer.g.dart';

@JsonSerializable()
class Answer {
  @JsonKey(name: 'AnswerText')
  String answerText = "";

  @JsonKey(name: 'Correct')
  int correct = 0;

  Answer({required this.answerText, required this.correct});

  factory Answer.from(Map<String, dynamic> json) => _$AnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);

}