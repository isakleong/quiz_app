import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:sfa_tools/models/paymentdata.dart';

import '../models/customer.dart';
import '../models/penjualanpostmodel.dart';
import '../models/reportpembayaranmodel.dart';
import '../models/reportpenjualanmodel.dart';
import '../models/shiptoaddress.dart';
import '../models/vendor.dart';
import '../tools/utils.dart';

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
  late Box<Customer> customerBox; 
  late Box boxreportpenjualan;

   getBox() async {
    try {
      customerBox = await Hive.openBox<Customer>('customerBox');
      boxreportpenjualan = await Hive.openBox('penjualanReport');
      print("try 1");
    } catch (e) {
      customerBox = await Hive.openBox('customerBox');
      // boxreportpenjualan = await Hive.openBox('penjualanReport');
      print("catch");
    }
  }
  
  getParameterData(String type) async {
    //SalesID;CustID;LocCheckIn
    String parameter = await Utils().readParameter();
    if (parameter != "") {
      var arrParameter = parameter.split(';');
      for (int i = 0; i < arrParameter.length; i++) {
        if (i == 0 && type == "sales") {
          return arrParameter[i];
        } else if (i == 1 && type == "cust") {
          return arrParameter[i];
        } else {
          return arrParameter[2];
        }
      }
    }
  }

  getReportList() async {
    await getBox();
    String salesid = await getParameterData("sales");
    String cust = await getParameterData("cust");
    if(cust != "01B05070012"){
      cust = "01B05070012";
    }
    var dataPenjualanbox = boxreportpenjualan.get("$salesid|$cust");
    // print(dataPenjualanbox[0].id);
    if(dataPenjualanbox != null){
      
      listReportPenjualan.clear();
      for (var i = 0; i < dataPenjualanbox.length; i++) {
        listReportPenjualan.add(dataPenjualanbox[i]);
      }
      
      listReportPenjualanShow.clear();
      listReportPenjualanShow.addAll(listReportPenjualan);

    } else {
      listReportPenjualanShow.clear();
      listReportPenjualan.clear();
    }
    // listReportPenjualan.add(data);
    // listReportPenjualanShow.clear();
    // listReportPenjualanShow.addAll(listReportPenjualan);
    // allReportlength.value = listReportPenjualanShow.length + listReportPembayaranshow.length;
    

    // listReportPenjualan.clear();
    // List<CartModel> data = [
    //   CartModel("asc", dummyList[0], 2, "dos", 10000),
    //   CartModel("asc", dummyList[0], 1, "biji", 20000)
    // ];
    // List<CartDetail> list = [CartDetail("asc", dummyList[0], data)];
    // listReportPenjualan.add(ReportPenjualanModel("GO-00AC1A0103-2307311034-001",
    //     "penjualan", "31-07-2023", "10:34", list, "test note pendek"));

    // List<CartModel> data2 = [
    //   CartModel("desc", dummyList[1], 12, "kaleng", 10000)
    // ];
    // List<CartModel> data3 = [
    //   CartModel("ccc", dummyList[dummyList.length - 1], 4, "inner plas", 12000),
    //   CartModel("ccc", dummyList[dummyList.length - 1], 11, "dos", 12000),
    // ];
    // List<CartDetail> list2 = [
    //   CartDetail("desc", dummyList[1], data2),
    //   CartDetail("ccc", dummyList[dummyList.length - 1], data3)
    // ];
    // listReportPenjualan.add(ReportPenjualanModel("GO-00AC1A0103-2307311045-001",
    //     "penjualan", "31-07-2023", "10:45", list2, ""));

    // List<CartModel> data4 = [
    //   CartModel("desc", dummyList[1], 12, "kaleng", 10000)
    // ];
    // List<CartModel> data5 = [
    //   CartModel("ccc", dummyList[dummyList.length - 1], 4, "inner plas", 12000),
    //   CartModel("ccc", dummyList[dummyList.length - 1], 11, "dos", 12000),
    // ];
    // List<CartModel> data6 = [
    //   CartModel("asc", dummyList[0], 2, "dos", 10000),
    //   CartModel("asc", dummyList[0], 1, "biji", 20000)
    // ];
    // List<CartDetail> list3 = [
    //   CartDetail("asc", dummyList[0], data6),
    //   CartDetail("desc", dummyList[1], data4),
    //   CartDetail("ccc", dummyList[dummyList.length - 1], data5)
    // ];
    // listReportPenjualan.add(ReportPenjualanModel(
    //     "GO-00AC1A0103-2308010914-001",
    //     "penjualan",
    //     "01-08-2023",
    //     "09:14",
    //     list3,
    //     "test note panjang fasbgwujkasbkfbuwahsfjkwiahfjkhuiwhfuia"));

    // listReportPenjualanShow.addAll(listReportPenjualan);

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
    listReportPembayaranshow.clear();
    listReportPembayaranshow.addAll(listReportPembayaran);
    allReportlength.value =
        listReportPenjualanShow.length + listReportPembayaranshow.length;
  }

  filteReport() async {
    await getReportList();
    if (choosedReport.value.contains("Semua")) {
      listReportPenjualanShow.value.clear();
      listReportPenjualanShow.value.addAll(listReportPenjualan);
      listReportPembayaranshow.clear();
      listReportPembayaranshow.value.addAll(listReportPembayaran);
      allReportlength.value =
        listReportPenjualanShow.length + listReportPembayaranshow.length;
    } else if (choosedReport.value == "Transaksi Penjualan") {
      listReportPenjualanShow.value.clear();
      listReportPembayaranshow.clear();
      listReportPenjualanShow.value.addAll(listReportPenjualan);
      allReportlength.value =
        listReportPenjualanShow.length ;
    } else if (choosedReport.value == "Transaksi Pembayaran") {
      listReportPenjualanShow.value.clear();
      listReportPembayaranshow.clear();
      listReportPembayaranshow.value.addAll(listReportPembayaran);
      allReportlength.value =
         listReportPembayaranshow.length;
    } else if (choosedReport.value == "Transaksi Retur") {
      listReportPenjualanShow.clear();
      listReportPembayaranshow.clear();
      allReportlength.value = 0;
    }
  }
}
