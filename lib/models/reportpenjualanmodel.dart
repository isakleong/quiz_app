import 'package:sfa_tools/models/cartmodel.dart';

class ReportPenjualanModel {
  String id;
  String jenis;
  String tanggal;
  String waktu;
  String notes;
  List<CartDetail> listItem;
  ReportPenjualanModel(
      this.id, this.jenis, this.tanggal, this.waktu, this.listItem, this.notes);
}
