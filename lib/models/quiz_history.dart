import 'package:json_annotation/json_annotation.dart';
part 'quiz_history.g.dart';

@JsonSerializable()
class QuizHistory {
  
  @JsonKey(name: "SalesID")
  String salesID = "";

  @JsonKey(name: "Name")
  String name = "";

  @JsonKey(name: "Tanggal")
  String tanggal = "";

  @JsonKey(name: "Passed")
  String passed = "";

  QuizHistory({required this.salesID, required this.name, required this.tanggal, required this.passed});

  factory QuizHistory.from(Map<String, dynamic> json) => _$QuizHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$QuizHistoryToJson(this);

}