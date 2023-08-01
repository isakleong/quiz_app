import 'package:sfa_tools/models/cartmodel.dart';

class ReportModel {
  String id;
  String jenis;
  String tanggal;
  String waktu;
  String notes;
  List<CartDetail> listItem;
  ReportModel(
      this.id, this.jenis, this.tanggal, this.waktu, this.listItem, this.notes);
}
