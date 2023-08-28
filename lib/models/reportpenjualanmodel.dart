import 'package:hive/hive.dart';

import 'cartdetail.dart';

part 'reportpenjualanmodel.g.dart'; // This will be generated by the build_runner

@HiveType(typeId: 6)
class ReportPenjualanModel extends HiveObject {
  @HiveField(0)
  String condition;

  @HiveField(1)
  String id;

  @HiveField(2)
  String jenis;

  @HiveField(3)
  String tanggal;

  @HiveField(4)
  String waktu;

  @HiveField(5)
  String notes;

  @HiveField(6)
  List<CartDetail> listItem;

  ReportPenjualanModel(this.condition, this.id, this.jenis, this.tanggal, this.waktu, this.listItem, this.notes);

  factory ReportPenjualanModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonList = json['listItem'];
    final List<CartDetail> cartDetails = jsonList.map((item) => CartDetail.fromJson(item)).toList();

    return ReportPenjualanModel(
      json['condition'] as String,
      json['id'] as String,
      json['jenis'] as String,
      json['tanggal'] as String,
      json['waktu'] as String,
      cartDetails,
      json['notes'] as String,
    );
  }
}

