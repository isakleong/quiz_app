import 'package:hive/hive.dart';

part 'servicebox.g.dart'; // Generated file

@HiveType(typeId: 2)
class ServiceBox extends HiveObject {
  ServiceBox({required this.value});

  @HiveField(0)
  late String value;
}