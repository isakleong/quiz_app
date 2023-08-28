import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sfa_tools/controllers/penjualan_controller.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/taking_order_vendor/payment/paymentlist.dart';
import 'package:sfa_tools/tools/utils.dart';

import '../common/app_config.dart';
import '../models/paymentdata.dart';
import '../models/reportpembayaranmodel.dart';
import '../models/vendor.dart';
import '../screens/taking_order_vendor/transaction/dialogdelete.dart';

class PembayaranController extends GetxController {
  //for payment page
  RxString choosedTunaiMethod = "".obs;
  RxString choosedTransferMethod = "".obs;
  Rx<TextEditingController> nominaltunai = TextEditingController().obs;
  Rx<TextEditingController> nominaltransfer = TextEditingController().obs;
  Rx<TextEditingController> nominalCn = TextEditingController().obs;
  Rx<TextEditingController> nominalcek = TextEditingController().obs;
  Rx<TextEditingController> nomorcek = TextEditingController().obs;
  Rx<TextEditingController> nmbank = TextEditingController().obs;
  Rx<TextEditingController> jatuhtempotgl = TextEditingController().obs;
  RxList<PaymentData> listpaymentdata = <PaymentData>[].obs;
  RxInt selectedTab = 0.obs;
  late TabController controller;
  final pembayaranListKey = GlobalKey<AnimatedListState>();
  RxInt showBanner = 1.obs;
  var tabvalueCn = 3;
  var tabvaluetunai = 0;
  var tabvaluetransfer = 1;
  var tabvaluecek = 2;
  late Box boxPembayaranReport;
  late Box vendorBox; 
  String globalkeybox = "";
  String activevendor = "";
  List<Vendor> vendorlist = <Vendor>[];
  
  Future<void> selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime next90Days = currentDate.add(const Duration(days: 90));

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: next90Days,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppConfig.mainCyan, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppConfig.mainCyan, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      jatuhtempotgl.value.text = formattedDate;
    }
  }

  handleDeleteItemPayment(String metode, String jenis) {
    Get.dialog(Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogDelete(
            nmProduct: metode,
            ontap: () async {
              await deletePayment(jenis);
            })));
  }

  insertRecord(String type) {
    try {
      if (type == "Tunai") {
        if (listpaymentdata.any((data) => data.jenis == 'Tunai')) {
          listpaymentdata.removeWhere((element) => element.jenis == type);
          listpaymentdata.add(PaymentData(type,"",choosedTunaiMethod.value,"",double.parse(nominaltunai.value.text.toString().replaceAll(',', ''))));
        } else {
          pembayaranListKey.currentState?.insertItem(listpaymentdata.length);
          listpaymentdata.add(PaymentData(type,"",choosedTunaiMethod.value,"",double.parse(nominaltunai.value.text.toString().replaceAll(',', ''))));
        }
      } else if (type == "Transfer") {
        if (listpaymentdata.any((data) => data.jenis == 'Transfer')) {
          listpaymentdata.removeWhere((element) => element.jenis == type);
          listpaymentdata.add(PaymentData(type,"",choosedTransferMethod.value,"",double.parse(nominaltransfer.value.text.toString().replaceAll(',', ''))));
        } else {
          pembayaranListKey.currentState?.insertItem(listpaymentdata.length);
          listpaymentdata.add(PaymentData(type,"",choosedTransferMethod.value,"",double.parse(nominaltransfer.value.text.toString().replaceAll(',', ''))));
        }
      } else if (type == "cn") {
        if (listpaymentdata.any((data) => data.jenis == 'cn')) {
          listpaymentdata.removeWhere((element) => element.jenis == type);
          listpaymentdata.add(PaymentData("cn","","","",double.parse(nominalCn.value.text.toString().replaceAll(',', ''))));
        } else {
          pembayaranListKey.currentState?.insertItem(listpaymentdata.length);
          listpaymentdata.add(PaymentData("cn","","","",double.parse(nominalCn.value.text.toString().replaceAll(',', ''))));
        }
      } else {
        if (listpaymentdata.any((data) => data.jenis == 'cek')) {
          listpaymentdata.removeWhere((element) => element.jenis == type);
          listpaymentdata.add(PaymentData("cek",nomorcek.value.text,nmbank.value.text,jatuhtempotgl.value.text,double.parse(nominalcek.value.text.toString().replaceAll(',', ''))));
        } else {
          pembayaranListKey.currentState?.insertItem(listpaymentdata.length);
          listpaymentdata.add(PaymentData("cek",nomorcek.value.text,nmbank.value.text,jatuhtempotgl.value.text,double.parse(nominalcek.value.text.toString().replaceAll(',', ''))));
        }
      }
    } catch (e) {
      print(e);
    }
  }

  deletePayment(String jenis) async {
    try {
      for (var i = 0; i < listpaymentdata.length; i++) {
        if (listpaymentdata[i].jenis == jenis) {
          print(i);
          Get.back();
          PaymentData dataTemp = listpaymentdata[i];
          // listpaymentdata.removeWhere((element) => element.jenis == jenis);
          pembayaranListKey.currentState!.removeItem(
              i,
              (context, animation) => SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1, 0),
                      end: const Offset(0, 0),
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                      reverseCurve: Curves.easeOut,
                    )),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 0.05 * Get.width,
                          top: 5,
                          right: 0.05 * Get.width),
                      child: PaymentList(
                        idx: (i + 1).toString(),
                        metode: dataTemp.jenis == "cn"
                            ? "Potongan CN"
                            : dataTemp.jenis == "cek"
                                ? "Cek / Giro / Slip - ${dataTemp.tipe} [${dataTemp.nomor}]"
                                : "${dataTemp.jenis} - ${dataTemp.tipe}",
                        jatuhtempo: dataTemp.jatuhtempo == ""
                            ? dataTemp.jatuhtempo
                            : "Jatuh Tempo : ${dataTemp.jatuhtempo}",
                        value: "Rp ${Utils().formatNumber(dataTemp.value.toInt())}",
                        jenis: dataTemp.jenis,
                      ),
                    ),
                  ),
              duration: const Duration(milliseconds: 500));

          await Future.delayed(const Duration(milliseconds: 500));
          listpaymentdata.removeWhere((element) => element.jenis == jenis);
          listpaymentdata.isEmpty ? showBanner.value = 1 : showBanner.value = 0;
          break;
        }
      }

      if (jenis == "Tunai") {
        choosedTunaiMethod.value = "";
        nominaltunai.value.clear();
      } else if (jenis == "Transfer") {
        choosedTransferMethod.value = "";
        nominaltransfer.value.clear();
      } else if (jenis == "cn") {
        nominalCn.value.clear();
      } else {
        nominalcek.value.clear();
        nomorcek.value.clear();
        nmbank.value.clear();
        jatuhtempotgl.value.clear();
      }
    } catch (e) {
      print(e);
    }
  }

  handleeditpayment(String jenis) {
    try {
      var idx = 0;
      for (var i = 0; i < listpaymentdata.length; i++) {
        if (listpaymentdata[i].jenis == jenis) {
          idx = i;
          break;
        }
      }
      if (jenis == "Tunai") {
        choosedTunaiMethod.value = listpaymentdata[idx].tipe;
        nominaltunai.value.text = Utils().formatNumber(listpaymentdata[idx].value.toInt());
        controller.index = tabvaluetunai;
      } else if (jenis == "Transfer") {
        choosedTransferMethod.value = listpaymentdata[idx].tipe;
        nominaltransfer.value.text = Utils().formatNumber(listpaymentdata[idx].value.toInt());
        controller.index = tabvaluetransfer;
      } else if (jenis == "cn") {
        nominalCn.value.text = Utils().formatNumber(listpaymentdata[idx].value.toInt());
        controller.index = tabvalueCn;
      } else if (jenis == "cek") {
        nomorcek.value.text = listpaymentdata[idx].nomor.toString();
        nmbank.value.text = listpaymentdata[idx].tipe.toString();
        jatuhtempotgl.value.text = listpaymentdata[idx].jatuhtempo.toString();
        nominalcek.value.text = Utils().formatNumber(listpaymentdata[idx].value.toInt());
        controller.index = tabvaluecek;
      }
    } catch (e) {
      print(e);
    }
  }

  savepaymendata() async {
    String salesid = await Utils().getParameterData("sales");
    String custid = await Utils().getParameterData("cust");
    if(!Hive.isBoxOpen('vendorBox')) vendorBox = await Hive.openBox('vendorBox');
    var datavendor = vendorBox.get("$salesid|$custid");
    vendorBox.close();
    vendorlist.clear();
    for (var i = 0; i < datavendor.length; i++) {
      vendorlist.add(datavendor[i]);
    }
    var idvendor =  vendorlist.indexWhere((element) => element.name.toLowerCase() == activevendor);
    globalkeybox = "$salesid|$custid|${vendorlist[idvendor].prefix}|${vendorlist[idvendor].baseApiUrl}";
    if(!Hive.isBoxOpen('BoxPembayaranReport')) boxPembayaranReport = await Hive.openBox('BoxPembayaranReport');
    var datapembayaranreport = await boxPembayaranReport.get(globalkeybox);
    if(datapembayaranreport != null){
      List<ReportPembayaranModel> listReportPembayaran = <ReportPembayaranModel>[];
      var converteddatapembayaran = json.decode(datapembayaranreport);
      // print(converteddatapembayaran['data'].length);
      List<Map<String, dynamic>> listpaymentdatamap = listpaymentdata.map((datalist) {
      return {
        'jenis': datalist.jenis,
        'nomor': datalist.nomor,
        'value': datalist.value,
        'jatuhtempo': datalist.jatuhtempo,
        'tipe': datalist.tipe
      };
    }).toList();
      String jsonpembayaran = jsonEncode(listpaymentdatamap);
      // print(jsonpembayaran);
      var totalpayment = 0.0;
      for (var i = 0; i < listpaymentdata.length; i++) {
        totalpayment = totalpayment + listpaymentdata[i].value;
      }
      var length = converteddatapembayaran['data'].length + 1;
      var inc = "0";
      if(length < 10){
        inc = "00$length";
      } else if (length < 100) {
        inc = "0$length";
      } else {
        inc = length.toString();
      }
      DateTime now = DateTime.now();
      String noorder = "GP-$salesid-${DateFormat('yyMMddHHmm').format(now)}-$inc";
      String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
      String time = DateFormat('HH:mm').format(now);
      var jsondata = {
          'id': noorder,
          'total' : totalpayment,
          'tanggal' :date,
          'waktu' : time,
          'listpayment' :jsonpembayaran
        };
      var datapembayaranlist = [];
      for (var i = 0; i < converteddatapembayaran['data'].length; i++) {
        datapembayaranlist.add(converteddatapembayaran['data'][i]);
      }
      datapembayaranlist.add(jsondata);
      var joinedjson = {
         "data" : datapembayaranlist
      };
      // print(jsonEncode(joinedjson));
      boxPembayaranReport.delete(globalkeybox);
      boxPembayaranReport.put(globalkeybox, jsonEncode(joinedjson));
      boxPembayaranReport.close();
    }else {
      print("else");
      List<Map<String, dynamic>> listpaymentdatamap = listpaymentdata.map((datalist) {
      return {
        'jenis': datalist.jenis,
        'nomor': datalist.nomor,
        'value': datalist.value,
        'jatuhtempo': datalist.jatuhtempo,
        'tipe': datalist.tipe
      };
    }).toList();
      String jsonpembayaran = jsonEncode(listpaymentdatamap);
      print(jsonpembayaran);
      var totalpayment = 0.0;
      for (var i = 0; i < listpaymentdata.length; i++) {
        totalpayment = totalpayment + listpaymentdata[i].value;
      }
      DateTime now = DateTime.now();
      String noorder = "GP-$salesid-${DateFormat('yyMMddHHmm').format(now)}-001";
      String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
      String time = DateFormat('HH:mm').format(now);
      var jsondata = {
         "data" : [{
          'id': noorder,
          'total' : totalpayment,
          'tanggal' :date,
          'waktu' : time,
          'listpayment' :jsonpembayaran
        }]
      };
      boxPembayaranReport.delete(globalkeybox);
      boxPembayaranReport.put(globalkeybox, jsonEncode(jsondata));
    }
    boxPembayaranReport.close();
    clearvariable();
  }

  clearvariable(){
    choosedTransferMethod.value = "";
    choosedTunaiMethod.value = "";
    showBanner.value = 1;
    listpaymentdata.clear();
    nominaltunai.value.clear();
    nominalCn.value.clear();
    nominalcek.value.clear();
    nominaltransfer.value.clear();
    nomorcek.value.clear();
    nmbank.value.clear();
    jatuhtempotgl.value.clear();
  }

}
