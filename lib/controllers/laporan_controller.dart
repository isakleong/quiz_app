import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sfa_tools/controllers/penjualan_controller.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/models/paymentdata.dart';
import '../models/reportpembayaranmodel.dart';
import '../models/reportpenjualanmodel.dart';
import '../models/vendor.dart';
import '../tools/utils.dart';

class LaporanController extends GetxController {
  RxString choosedReport = "".obs;
  List<ReportPenjualanModel> listReportPenjualan = <ReportPenjualanModel>[];
  RxList<ReportPembayaranModel> listReportPembayaranshow = <ReportPembayaranModel>[].obs;
  RxList<ReportPenjualanModel> listReportPenjualanShow = <ReportPenjualanModel>[].obs;
  List<ReportPembayaranModel> listReportPembayaran = <ReportPembayaranModel>[];
  RxInt allReportlength = 0.obs;
  late Box boxreportpenjualan;
  late Box vendorBox; 
  List<Vendor> vendorlist = <Vendor>[];
  var idvendor = -1;
  String activevendor= "";

  getBox() async {
    try {
      boxreportpenjualan = await Hive.openBox('penjualanReport');
      vendorBox = await Hive.openBox('vendorBox');
      print("try 1");
    } catch (e) {
      print("catch");
    }
  }
  
  closebox(){
    try {
      vendorBox.close();
      boxreportpenjualan.close();
    } catch (e) {
      
    }
  }

  getReportList() async {
    await getBox();
    String salesid = await Utils().getParameterData("sales");
    String cust = await Utils().getParameterData("cust");
    
    var datavendor = vendorBox.get("$salesid|$cust");
    vendorlist.clear();
    for (var i = 0; i < datavendor.length; i++) {
        vendorlist.add(datavendor[i]);
    }
    idvendor =  vendorlist.indexWhere((element) => element.name.toLowerCase() == activevendor);
    var gkey = "$salesid|$cust|${vendorlist[idvendor].prefix}|${vendorlist[idvendor].baseApiUrl}";
    var dataPenjualanbox = boxreportpenjualan.get(gkey);
    if(dataPenjualanbox != null){
      listReportPenjualan.clear();
      var listdelindex = [];
      for (var i = 0; i < dataPenjualanbox.length; i++) {
        listReportPenjualan.add(dataPenjualanbox[i]);
        if(Utils().isDateNotToday(Utils().formatDate(listReportPenjualan[i].tanggal))){
          listdelindex.add(i == 0 ? i : (i-1));
        }
      }
      for (var i = 0; i < listdelindex.length; i++) {
        listReportPenjualan.removeAt(listdelindex[i]);
      }
      await boxreportpenjualan.delete(gkey);
      await boxreportpenjualan.put(gkey,listReportPenjualan);
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
    listReportPembayaran.add(ReportPembayaranModel("GP-00AC1A0103-2308021435-001",1150000.0,"02-08-2023","14:35",payment1));
     if (choosedReport.value.contains("Semua") || choosedReport.value == "") {
      print("semua");
      listReportPenjualanShow.value.clear();
      listReportPenjualanShow.value.addAll(listReportPenjualan);
      listReportPembayaranshow.clear();
      listReportPembayaranshow.value.addAll(listReportPembayaran);
      allReportlength.value = listReportPenjualanShow.length + listReportPembayaranshow.length;
    } 
    else if (choosedReport.value == "Transaksi Penjualan") {
      listReportPenjualanShow.value.clear();
      listReportPembayaranshow.clear();
      listReportPenjualanShow.value.addAll(listReportPenjualan);
      allReportlength.value = listReportPenjualanShow.length ;
    } 
    else if (choosedReport.value == "Transaksi Pembayaran") {
      listReportPenjualanShow.value.clear();
      listReportPembayaranshow.clear();
      listReportPembayaranshow.value.addAll(listReportPembayaran);
      allReportlength.value = listReportPembayaranshow.length;
    } 
    else if (choosedReport.value == "Transaksi Retur") {
      listReportPenjualanShow.clear();
      listReportPembayaranshow.clear();
      allReportlength.value = 0;
    }
    await closebox();
    listReportPenjualanShow.refresh();
    listReportPembayaranshow.refresh();
  }

  filteReport() async {
    await getReportList();
    if (choosedReport.value.contains("Semua") || choosedReport.value == "") {
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
    listReportPenjualanShow.refresh();
    listReportPembayaranshow.refresh();
  }

}
