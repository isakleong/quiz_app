import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
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
  late Box boxPembayaranReport;
  List<Vendor> vendorlist = <Vendor>[];
  var idvendor = -1;
  String activevendor= "";

  getBox() async {
    try {
      boxreportpenjualan = await Hive.openBox('penjualanReport');
      vendorBox = await Hive.openBox('vendorBox');
      boxPembayaranReport = await Hive.openBox('BoxPembayaranReport');
      //print("try 1");
    } catch (e) {
      //print("catch");
    }
  }
  
  closebox(){
    try {
      vendorBox.close();
      boxreportpenjualan.close();
      boxPembayaranReport.close();
    // ignore: empty_catches
    } catch (e) {
      
    }
  }

  getReportList(bool isclosebox) async {
    await getBox();
    //print("get report list");
    //getting key for box
    String salesid = await Utils().getParameterData("sales");
    String cust = await Utils().getParameterData("cust");
    if(!Hive.isBoxOpen('vendorBox')) vendorBox = await Hive.openBox('vendorBox');
    var datavendor = vendorBox.get("$salesid|$cust");
    vendorlist.clear();
    for (var i = 0; i < datavendor.length; i++) {
        vendorlist.add(datavendor[i]);
    }
    idvendor =  vendorlist.indexWhere((element) => element.name.toLowerCase() == activevendor);
    if(idvendor == -1){
      if(isclosebox){
        await closebox();
      }
      return;
    }
    var gkey = "$salesid|$cust|${vendorlist[idvendor].prefix}|${vendorlist[idvendor].baseApiUrl}";

    //fill report penjualan
    listReportPenjualanShow.clear();
    listReportPenjualan.clear();
    var dataPenjualanbox = boxreportpenjualan.get(gkey);
    if(dataPenjualanbox != null){
      for (var i = 0; i < dataPenjualanbox.length; i++) {
        if(Utils().isDateNotToday(Utils().formatDate(dataPenjualanbox[i].tanggal)) && dataPenjualanbox[i].condition == "success"){
          // listdelindex.add(i);
        } else {
          listReportPenjualan.add(dataPenjualanbox[i]);
        }
      }
      // await boxreportpenjualan.delete(gkey);
      // await boxreportpenjualan.put(gkey,listReportPenjualan);
    }

    //fill report pembayaran
    listReportPembayaran.clear();
    listReportPembayaranshow.clear();
    var datapembayaranreport = boxPembayaranReport.get(gkey);
    if(datapembayaranreport != null){
      var converteddatapembayaran = json.decode(datapembayaranreport);
      for (var i = 0; i < converteddatapembayaran['data'].length; i++) {
        if(Utils().isDateNotToday(Utils().formatDate(converteddatapembayaran['data'][i]['tanggal'])) && converteddatapembayaran['data'][i]['condition'] == "success"){
          //print("old report " + converteddatapembayaran['data'][i]['id']);
        } else {
          List<PaymentData> listPayment = [];
          var datalistpayment = converteddatapembayaran['data'][i]['listpayment'];
          for (var j = 0; j < datalistpayment.length; j++) {
            listPayment.add(PaymentData(datalistpayment[j]['jenis'], datalistpayment[j]['nomor'], datalistpayment[j]['tipe'], datalistpayment[j]['jatuhtempo'],  datalistpayment[j]['value']));
          }
          listReportPembayaran.add(ReportPembayaranModel(converteddatapembayaran['data'][i]['condition'],converteddatapembayaran['data'][i]['id'], converteddatapembayaran['data'][i]['total'], converteddatapembayaran['data'][i]['tanggal'], converteddatapembayaran['data'][i]['waktu'],
          listPayment));
        }
      }
    }

    //read filter condition
    if (choosedReport.value.contains("Semua") || choosedReport.value == "") {
      listReportPenjualanShow.clear();
      listReportPenjualanShow.addAll(listReportPenjualan);
      listReportPembayaranshow.clear();
      listReportPembayaranshow.addAll(listReportPembayaran);
      allReportlength.value = listReportPenjualanShow.length + listReportPembayaranshow.length;
    } 
    else if (choosedReport.value == "Transaksi Penjualan") {
      listReportPembayaranshow.clear();
      listReportPenjualanShow.clear();
      listReportPenjualanShow.addAll(listReportPenjualan);
      allReportlength.value = listReportPenjualanShow.length ;
    } 
    else if (choosedReport.value == "Transaksi Pembayaran") {
      listReportPenjualanShow.clear();
      listReportPembayaranshow.clear();
      listReportPembayaranshow.addAll(listReportPembayaran);
      allReportlength.value = listReportPembayaranshow.length;
    } 
    else if (choosedReport.value == "Transaksi Retur") {
      listReportPenjualanShow.clear();
      listReportPembayaranshow.clear();
      allReportlength.value = 0;
    }
    if(isclosebox){
      await closebox();
    }
  }

  filteReport() async {
    if (choosedReport.value.contains("Semua") || choosedReport.value == "") {
      listReportPenjualanShow.clear();
      listReportPenjualanShow.addAll(listReportPenjualan);
      listReportPembayaranshow.clear();
      listReportPembayaranshow.addAll(listReportPembayaran);
      allReportlength.value =
        listReportPenjualanShow.length + listReportPembayaranshow.length;
    } else if (choosedReport.value == "Transaksi Penjualan") {
      listReportPenjualanShow.clear();
      listReportPenjualanShow.addAll(listReportPenjualan);
      listReportPembayaranshow.clear();
      allReportlength.value = listReportPenjualanShow.length ;
    } else if (choosedReport.value == "Transaksi Pembayaran") {
      listReportPenjualanShow.clear();
      listReportPembayaranshow.clear();
      listReportPembayaranshow.addAll(listReportPembayaran);
      allReportlength.value =
         listReportPembayaranshow.length;
    } else if (choosedReport.value == "Transaksi Retur") {
      listReportPenjualanShow.clear();
      listReportPembayaranshow.clear();
      allReportlength.value = 0;
    }
    listReportPenjualanShow.refresh();
    listReportPembayaranshow.refresh();
    // getReportList(true);
  }

}
