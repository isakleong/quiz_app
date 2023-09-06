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
      print("try 1");
    } catch (e) {
      print("catch");
    }
  }
  
  closebox(){
    try {
      vendorBox.close();
      boxreportpenjualan.close();
      boxPembayaranReport.close();
    } catch (e) {
      
    }
  }

  getReportList() async {
    await getBox();
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
      await closebox();
      return;
    }
    var gkey = "$salesid|$cust|${vendorlist[idvendor].prefix}|${vendorlist[idvendor].baseApiUrl}";

    //fill report penjualan
    listReportPenjualanShow.clear();
    listReportPenjualan.clear();
    var dataPenjualanbox = boxreportpenjualan.get(gkey);
    if(dataPenjualanbox != null){
      listReportPenjualan.clear();
      var listdelindex = [];
      for (var i = 0; i < dataPenjualanbox.length; i++) {
        listReportPenjualan.add(dataPenjualanbox[i]);
        if(Utils().isDateNotToday(Utils().formatDate(listReportPenjualan[i].tanggal)) && listReportPenjualan[i].condition == "success"){
          listdelindex.add(i == 0 ? i : (i-1));
        }
      }
      for (var i = 0; i < listdelindex.length; i++) {
        listReportPenjualan.removeAt(listdelindex[i]);
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
        List<PaymentData> listPayment = [];
        var datalistpayment = json.decode(converteddatapembayaran['data'][i]['listpayment']);
        for (var j = 0; j < datalistpayment.length; j++) {
          listPayment.add(PaymentData(datalistpayment[j]['jenis'], datalistpayment[j]['nomor'], datalistpayment[j]['tipe'], datalistpayment[j]['jatuhtempo'],  datalistpayment[j]['value']));
        }
        listReportPembayaran.add(ReportPembayaranModel(converteddatapembayaran['data'][i]['id'], converteddatapembayaran['data'][i]['total'], converteddatapembayaran['data'][i]['tanggal'], converteddatapembayaran['data'][i]['waktu'],
         listPayment));
      }
    }

    //read filter condition
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
