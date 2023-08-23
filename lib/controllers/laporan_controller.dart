import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/models/paymentdata.dart';
import '../models/customer.dart';
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
    var datavendor = vendorBox.get("$salesid|$cust");
    vendorlist.clear();
    for (var i = 0; i < datavendor.length; i++) {
        vendorlist.add(datavendor[i]);
    }
    SplashscreenController _splashscreenController = callcontroller("splashscreencontroller");
    idvendor =  vendorlist.indexWhere((element) => element.name.toLowerCase() == _splashscreenController.selectedVendor.value.toLowerCase());
    var dataPenjualanbox = boxreportpenjualan.get("$salesid|$cust|${vendorlist[idvendor].prefix}");
    if(dataPenjualanbox != null){
      listReportPenjualan.clear();
      for (var i = 0; i < dataPenjualanbox.length; i++) {
        listReportPenjualan.add(dataPenjualanbox[i]);
      }
    } else {
      listReportPenjualanShow.clear();
      listReportPenjualan.clear();
    }

    for (var i = 0; i < listReportPenjualan.length; i++) {
      print(listReportPenjualan[i].id + " " + listReportPenjualan[i].condition);
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

  callcontroller(String controllername){
     if (controllername.toLowerCase() == "splashscreencontroller".toLowerCase()){
      final isControllerRegistered = GetInstance().isRegistered<SplashscreenController>();
      if(!isControllerRegistered){
          final SplashscreenController _controller =  Get.put(SplashscreenController());
          return _controller;
      } else {
          final SplashscreenController _controller = Get.find();
          return _controller;
      }    
    }
    
  }

}
