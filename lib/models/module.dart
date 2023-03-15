import 'package:json_annotation/json_annotation.dart';
part 'module.g.dart';

@JsonSerializable()
class Module {
  
  @JsonKey(name: "ModuleID")
  String moduleID = "";

  @JsonKey(name: "Version")
  String version = "";

  @JsonKey(name: "OrderNumber")
  String orderNumber = "";

  Module({required this.moduleID, required this.version, required this.orderNumber});

  factory Module.from(Map<String, dynamic> json) => _$ModuleFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleToJson(this);

}