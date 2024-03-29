import 'package:get/get.dart';
import 'package:sfa_tools/models/paymentdata.dart';

import '../models/cartmodel.dart';
import '../models/reportpembayaranmodel.dart';
import '../models/reportpenjualanmodel.dart';

class LaporanController extends GetxController {
  RxString choosedReport = "".obs;
  List<ReportPenjualanModel> listReportPenjualan = <ReportPenjualanModel>[];
  RxList<ReportPembayaranModel> listReportPembayaranshow =
      <ReportPembayaranModel>[].obs;
  RxList<ReportPenjualanModel> listReportPenjualanShow =
      <ReportPenjualanModel>[].obs;
  List<ReportPembayaranModel> listReportPembayaran = <ReportPembayaranModel>[];
  RxInt allReportlength = 0.obs;
  var dummyList = [
    'Aries Bling Emulsion SW - 18 KG',
    'ABSOLUTE Roof 30 - 2.5 LT',
    'AVIAN Cling Synthetic SWM - 3.4 LT',
    'AVIAN Cling Synthetic 11 - 17 LT',
    'Acura Sb 120 Sonoma Oak',
    'AVIAN Cling Zinc Chromate 901 - 1 KG'
  ];

  getReportList() {
    listReportPenjualan.clear();
    List<CartModel> data = [
      CartModel("asc", dummyList[0], 2, "dos", 10000),
      CartModel("asc", dummyList[0], 1, "biji", 20000)
    ];
    List<CartDetail> list = [CartDetail("asc", dummyList[0], data)];
    listReportPenjualan.add(ReportPenjualanModel("GO-00AC1A0103-2307311034-001",
        "penjualan", "31-07-2023", "10:34", list, "test note pendek"));

    List<CartModel> data2 = [
      CartModel("desc", dummyList[1], 12, "kaleng", 10000)
    ];
    List<CartModel> data3 = [
      CartModel("ccc", dummyList[dummyList.length - 1], 4, "inner plas", 12000),
      CartModel("ccc", dummyList[dummyList.length - 1], 11, "dos", 12000),
    ];
    List<CartDetail> list2 = [
      CartDetail("desc", dummyList[1], data2),
      CartDetail("ccc", dummyList[dummyList.length - 1], data3)
    ];
    listReportPenjualan.add(ReportPenjualanModel("GO-00AC1A0103-2307311045-001",
        "penjualan", "31-07-2023", "10:45", list2, ""));

    List<CartModel> data4 = [
      CartModel("desc", dummyList[1], 12, "kaleng", 10000)
    ];
    List<CartModel> data5 = [
      CartModel("ccc", dummyList[dummyList.length - 1], 4, "inner plas", 12000),
      CartModel("ccc", dummyList[dummyList.length - 1], 11, "dos", 12000),
    ];
    List<CartModel> data6 = [
      CartModel("asc", dummyList[0], 2, "dos", 10000),
      CartModel("asc", dummyList[0], 1, "biji", 20000)
    ];
    List<CartDetail> list3 = [
      CartDetail("asc", dummyList[0], data6),
      CartDetail("desc", dummyList[1], data4),
      CartDetail("ccc", dummyList[dummyList.length - 1], data5)
    ];
    listReportPenjualan.add(ReportPenjualanModel(
        "GO-00AC1A0103-2308010914-001",
        "penjualan",
        "01-08-2023",
        "09:14",
        list3,
        "test note panjang fasbgwujkasbkfbuwahsfjkwiahfjkhuiwhfuia"));

    listReportPenjualanShow.addAll(listReportPenjualan);

    listReportPembayaran.clear();
    List<PaymentData> payment1 = [
      PaymentData("Tunai", "", "Setor di Cabang", "", 50000),
      PaymentData("Transfer", "", "BCA", "", 100000),
      PaymentData("cek", "uvusadeawdssa", "MANDIRI", "02-08-2023", 750000),
      PaymentData("cn", "", "", "", 250000),
    ];
    listReportPembayaran.add(ReportPembayaranModel(
        "GP-00AC1A0103-2308021435-001",
        1150000.0,
        "02-08-2023",
        "14:35",
        payment1));
    listReportPembayaranshow.addAll(listReportPembayaran);
    allReportlength.value =
        listReportPenjualanShow.length + listReportPembayaranshow.length;
  }

  filteReport() {
    if (choosedReport.value.contains("Semua")) {
      listReportPenjualanShow.value.clear();
      listReportPenjualanShow.value.addAll(listReportPenjualan);
      listReportPembayaranshow.clear();
      listReportPembayaranshow.value.addAll(listReportPembayaran);
    } else if (choosedReport.value == "Transaksi Penjualan") {
      listReportPenjualanShow.value.clear();
      listReportPembayaranshow.clear();
      listReportPenjualanShow.value.addAll(listReportPenjualan);
    } else if (choosedReport.value == "Transaksi Pembayaran") {
      listReportPenjualanShow.value.clear();
      listReportPembayaranshow.clear();
      listReportPembayaranshow.value.addAll(listReportPembayaran);
    } else if (choosedReport.value == "Transaksi Retur") {
      listReportPenjualanShow.clear();
      listReportPembayaranshow.clear();
    }
  }
}
