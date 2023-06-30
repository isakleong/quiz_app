import 'package:hive/hive.dart';

part 'config_box.g.dart'; // Generated file

@HiveType(typeId: 3)
class ConfigBox extends HiveObject {
  ConfigBox({required this.value});

  @HiveField(0)
  late String value;
}