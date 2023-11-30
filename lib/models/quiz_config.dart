
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'quiz_config.g.dart';

@JsonSerializable()
@HiveType(typeId: 12)
class QuizConfig {
  @HiveField(1)
  @JsonKey(name: "BranchCode")
  String branchCode = "";

  @HiveField(2)
  @JsonKey(name: "Name")
  String name = "";

  @HiveField(3)
  @JsonKey(name: "Description")
  String description = "";

  @HiveField(4)
  @JsonKey(name: "Value")
  String value = "";
  
  QuizConfig({required this.branchCode, required this.name, required this.description, required this.value});

  factory QuizConfig.from(Map<String, dynamic> json) => _$QuizConfigFromJson(json);

  Map<String, dynamic> toJson() => _$QuizConfigToJson(this);

}