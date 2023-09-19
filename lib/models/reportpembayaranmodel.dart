import 'package:sfa_tools/models/paymentdata.dart';

class ReportPembayaranModel {
  String condition;
  String id;
  double total;
  String tanggal;
  String waktu;
  List<PaymentData> paymentList;
  ReportPembayaranModel(
      this.condition, this.id, this.total, this.tanggal, this.waktu, this.paymentList);
}
