import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'module.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class Module {
  
  @HiveField(1)
  @JsonKey(name: "ModuleID")
  String moduleID = "";

  @HiveField(2)
  @JsonKey(name: "Version")
  String version = "";

  @HiveField(3)
  @JsonKey(name: "OrderNumber")
  String orderNumber = "";

  Module({required this.moduleID, required this.version, required this.orderNumber});

  factory Module.from(Map<String, dynamic> json) => _$ModuleFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleToJson(this);

}