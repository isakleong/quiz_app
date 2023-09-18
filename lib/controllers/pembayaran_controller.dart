import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/models/reportpembayaranmodel.dart';
import 'package:sfa_tools/screens/taking_order_vendor/payment/paymentlist.dart';
import 'package:sfa_tools/tools/utils.dart';
import '../common/app_config.dart';
import '../models/masteritemvendor.dart';
import '../models/paymentdata.dart';
import '../models/penjualanpostmodel.dart';
import '../models/vendor.dart';
import '../screens/taking_order_vendor/transaction/dialogdelete.dart';
import 'package:http/http.dart' as http;

import 'laporan_controller.dart';

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
  var idvendor = -1;
  late Box boxPembayaranReport;
  late Box boxPembayaranState;
  late Box vendorBox; 
  late Box masteritemvendorbox;
  late Box postpembayaranbox;
  String globalkeybox = "";
  String activevendor = "";
  List<Vendor> vendorlist = <Vendor>[];

  tojsondata(List<ReportPembayaranModel> listreport){
    List<Map<String, dynamic>> listreportmap = listreport.map((clist) {
      var _pdata = [];
      for (var i = 0; i < clist.paymentList.length; i++) {
        _pdata.add({
          'jenis' : clist.paymentList[i].jenis,
          'nomor' : clist.paymentList[i].nomor,
          'tipe' : clist.paymentList[i].tipe,
          'jatuhtempo' : clist.paymentList[i].jatuhtempo,
          'value' : clist.paymentList[i].value
        });
      }
      return {
          'condition' : clist.condition,
          'id': clist.id,
          'total' : clist.total,
          'tanggal' :clist.tanggal,
          'waktu' : clist.waktu,
          'listpayment' : _pdata
      };
    }).toList();
    var datamerge = {
         "data" : listreportmap
    };
    return jsonEncode(datamerge);
  }

  getbox() async {
    try {
      boxPembayaranState = await Hive.openBox('boxPembayaranState');
      vendorBox = await Hive.openBox('vendorBox');
      boxPembayaranReport = await Hive.openBox('BoxPembayaranReport');
      masteritemvendorbox = await Hive.openBox("masteritemvendorbox");
      postpembayaranbox = await Hive.openBox("postpembayaranbox");
    } catch (e) {
      
    }
  }

  closebox(){
    try {
      boxPembayaranState.close();
      boxPembayaranReport.close();
      vendorBox.close();
      masteritemvendorbox.close();
      postpembayaranbox.close();
    } catch (e) {
      
    }
  }
  
  savepembayaranstate() async {
    if(listpaymentdata.isEmpty) await deletepembayaranstate();
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

    if (!Hive.isBoxOpen("boxPembayaranState")) boxPembayaranState = await Hive.openBox('boxPembayaranState');
    await boxPembayaranState.delete(globalkeybox);
    await boxPembayaranState.put(globalkeybox, jsonpembayaran);
    await boxPembayaranState.close();
  }

  deletepembayaranstate() async{
    if (!Hive.isBoxOpen("boxPembayaranState")) boxPembayaranState = await Hive.openBox('boxPembayaranState');
    await boxPembayaranState.delete(globalkeybox);
    await boxPembayaranState.close();
  }

  loadpembayaranstate() async{
      if(globalkeybox == "") await getGlobalKeyBox();
      if (!Hive.isBoxOpen("boxPembayaranState")) boxPembayaranState = await Hive.openBox('boxPembayaranState');
      var databox = boxPembayaranState.get(globalkeybox);
      await boxPembayaranState.close();
      if(databox != null){
        var dataconvjson = jsonDecode(databox);
        // print(dataconvjson);
        for (var i = 0; i < dataconvjson.length; i++) {
          listpaymentdata.add(PaymentData(dataconvjson[i]['jenis'], dataconvjson[i]['nomor'], dataconvjson[i]['tipe'], dataconvjson[i]['jatuhtempo'], dataconvjson[i]['value']));
        }
        for (var i = 0; i < listpaymentdata.length; i++) {
          await handleeditpayment(listpaymentdata[i].jenis);
        }
      }
  }

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

  insertRecord(String type) async {
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
          // choosedTransferMethod.value
          listpaymentdata.add(PaymentData(type,"", "" ,"",double.parse(nominaltransfer.value.text.toString().replaceAll(',', ''))));
        } else {
          // choosedTransferMethod.value
          pembayaranListKey.currentState?.insertItem(listpaymentdata.length);
          listpaymentdata.add(PaymentData(type,"","","",double.parse(nominaltransfer.value.text.toString().replaceAll(',', ''))));
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
      if(globalkeybox == "") await getGlobalKeyBox();
      savepembayaranstate();
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

      if(globalkeybox == "") await getGlobalKeyBox();
      savepembayaranstate();
    } catch (e) {
      print(e);
    }
  }

  handleeditpayment(String jenis) async {
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
      if(globalkeybox == "") await getGlobalKeyBox();
      savepembayaranstate();
    } catch (e) {
      print(e);
    }
  }

  getGlobalKeyBox() async {
    try {
      String salesid = await Utils().getParameterData("sales");
      String custid = await Utils().getParameterData("cust");
      if(!Hive.isBoxOpen('vendorBox')) vendorBox = await Hive.openBox('vendorBox');
      var datavendor = vendorBox.get("$salesid|$custid");
      vendorBox.close();
      vendorlist.clear();
      for (var i = 0; i < datavendor.length; i++) {
        vendorlist.add(datavendor[i]);
      }
      idvendor =  vendorlist.indexWhere((element) => element.name.toLowerCase() == activevendor);
      globalkeybox = "$salesid|$custid|${vendorlist[idvendor].prefix}|${vendorlist[idvendor].baseApiUrl}";
    } catch (e) {
      await closebox();
    }
  }

  savepaymentdata() async {
    await getbox();
    String salesid = await Utils().getParameterData("sales");
    String custid = await Utils().getParameterData("cust");

    if(globalkeybox == "") await getGlobalKeyBox();

    if(!Hive.isBoxOpen('BoxPembayaranReport')) boxPembayaranReport = await Hive.openBox('BoxPembayaranReport');
    var datapembayaranreport = await boxPembayaranReport.get(globalkeybox);

    if(datapembayaranreport != null){
      var converteddatapembayaran = json.decode(datapembayaranreport);
      List<Map<String, dynamic>> listpaymentdatamap = listpaymentdata.map((datalist) {
      return {
        'jenis': datalist.jenis,
        'nomor': datalist.nomor,
        'value': datalist.value,
        'jatuhtempo': datalist.jatuhtempo,
        'tipe': datalist.tipe
      };
    }).toList();
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
          'condition' : 'pending',
          'id': noorder,
          'total' : totalpayment,
          'tanggal' :date,
          'waktu' : time,
          'listpayment' :listpaymentdatamap
        };
      var datapembayaranlist = [];
      for (var i = 0; i < converteddatapembayaran['data'].length; i++) {
        datapembayaranlist.add(converteddatapembayaran['data'][i]);
      }
      datapembayaranlist.add(jsondata);
      var joinedjson = {
         "data" : datapembayaranlist
      };
      boxPembayaranReport.delete(globalkeybox);
      boxPembayaranReport.put(globalkeybox, jsonEncode(joinedjson));
      await closebox();
      await savepaymentdatatoapi(noorder, date, custid, salesid);
    }else {
      List<Map<String, dynamic>> listpaymentdatamap = listpaymentdata.map((datalist) {
      return {
        'jenis': datalist.jenis,
        'nomor': datalist.nomor,
        'value': datalist.value,
        'jatuhtempo': datalist.jatuhtempo,
        'tipe': datalist.tipe
      };
    }).toList();
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
          'condition' : 'pending',
          'id': noorder,
          'total' : totalpayment,
          'tanggal' :date,
          'waktu' : time,
          'listpayment' :listpaymentdatamap
        }]
      };
      boxPembayaranReport.delete(globalkeybox);
      boxPembayaranReport.put(globalkeybox, jsonEncode(jsondata));
      await closebox();
      await savepaymentdatatoapi(noorder, date, custid, salesid);
    }
  }

  savepaymentdatatoapi(String noorder , String datetimes, String custid, String salesid) async {
    await getbox();
    var databox = masteritemvendorbox.get(globalkeybox);
    if (databox != null){
      var data = MasterItemVendor.fromJson(databox);
      
      List<Map<String, dynamic>> datajson = [];
      for (var i = 0; i < listpaymentdata.length; i++) {
        String bankdata = '';
        String paymentid = '';
        String serialNum = '';
        if(listpaymentdata[i].jenis == "cek"){
          bankdata = listpaymentdata[i].tipe;
          serialNum = listpaymentdata[i].nomor;
        }
        for (var k = 0; k < data.paymentMethods!.length; k++) {
          if(listpaymentdata[i].jenis == "Tunai"){
            if(data.paymentMethods![k].name!.toLowerCase() == listpaymentdata[i].tipe.toLowerCase()){
              paymentid = data.paymentMethods![k].id.toString();
            }
          } else if (listpaymentdata[i].jenis == "Transfer"){
            if(data.paymentMethods![k].name!.toLowerCase() == listpaymentdata[i].jenis.toLowerCase()){
              paymentid = data.paymentMethods![k].id.toString();
            }
          } else if (listpaymentdata[i].jenis == "cek"){
            if(data.paymentMethods![k].name!.toLowerCase() == "Cek/Giro/Slip".toLowerCase()){
              paymentid = data.paymentMethods![k].id.toString();
            }
          }
        }
          datajson.add(
            {
              'extDocId' : noorder,
              'entryDate' : datetimes,
              'customerNo' : custid,
              'amount' : listpaymentdata[i].value,
              'bankId' : listpaymentdata[i].jenis.toString() == "Transfer" ? data.banks![0].id : '',
              'paymentMethodId' : paymentid,
              'serialNum' : serialNum,
              'bankName' : bankdata,
              'dueDate' : listpaymentdata[i].jatuhtempo,
              'salespersonCode' : salesid,
            }
          );
      }
      var listpostpembayaranbox = await postpembayaranbox.get(globalkeybox);
      List<PenjualanPostModel> listpost = <PenjualanPostModel>[];
      if (listpostpembayaranbox == null){
          listpost.add(PenjualanPostModel(datajson));
      } else {
        for (var i = 0; i < listpostpembayaranbox.length; i++) {
          listpost.add(listpostpembayaranbox[i]);
        }
        listpost.add(PenjualanPostModel(datajson));
      }
      await postpembayaranbox.delete(globalkeybox);
      await postpembayaranbox.put(globalkeybox,listpost);
      await closebox();
      clearvariable();
      deletepembayaranstate();
      sendPaymentToApi(datajson,listpost);
    }

  }

  sendPaymentToApi(List<Map<String, dynamic>> data,List<PenjualanPostModel> listpostdata) async {
    // print(data);
    String noorder = data[0]['extDocId'];
    LaporanController controllerLaporan = callcontroller("laporancontroller");
    await getbox();

    var datareportpembayaran = json.decode(await boxPembayaranReport.get(globalkeybox));
    List<ReportPembayaranModel> dataconvert = [];

    for (var i = 0; i < datareportpembayaran['data'].length; i++) {
      List<PaymentData> _data = <PaymentData>[];
      var detail = datareportpembayaran['data'][i]['listpayment'];
      for (var k = 0; k < detail.length; k++) {
        _data.add(PaymentData(detail[k]['jenis'], detail[k]['nomor'], detail[k]['tipe'], detail[k]['jatuhtempo'], detail[k]['value']));
      }
      dataconvert.add(ReportPembayaranModel(datareportpembayaran['data'][i]['condition'], datareportpembayaran['data'][i]['id'], datareportpembayaran['data'][i]['total'], datareportpembayaran['data'][i]['tanggal'], datareportpembayaran['data'][i]['waktu'], _data));
    }

    var idx = dataconvert.indexWhere((element) => element.id == noorder);
    var idxpost = -1;
    for (var i = 0; i < listpostdata.length; i++) {
      if(listpostdata[i].dataList[0]['extDocId'] == noorder){
          idxpost = i;
          break;
      }
    }

    final url = Uri.parse('${vendorlist[idvendor].baseApiUrl}payments/store');
    final request = http.MultipartRequest('POST', url);
      for (var i = 0; i < data.length; i++) {
        request.fields['data[$i][extDocId]'] = data[i]['extDocId'];
        request.fields['data[$i][customerNo]'] = data[i]['customerNo'];
        request.fields['data[$i][amount]'] = data[i]['amount'].toString();
        request.fields['data[$i][salespersonCode]'] = data[i]['salespersonCode'];
        request.fields['data[$i][entryDate]'] = data[i]['entryDate'];
        request.fields['data[$i][bankId]'] = data[i]['bankId'].toString();
        request.fields['data[$i][paymentMethodId]'] = data[i]['paymentMethodId'].toString();
        request.fields['data[$i][bankName]'] = data[i]['bankName'];
        request.fields['data[$i][dueDate]'] = data[i]['dueDate'];
        request.fields['data[$i][serialNum]'] = data[i]['serialNum'];
      }
      
      try {
        print(request.fields);
        final response = await request.send();
        final responseString = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(responseString);
          print(responseString);
          if(jsonResponse["success"] == true){
            print("success 1");
            if(jsonResponse["data"][0]["success"] == true){
                print("success 2");
                dataconvert[idx].condition = "success";
                listpostdata.removeAt(idxpost);
                await postpembayaranbox.delete(globalkeybox);
                if(listpostdata.isNotEmpty) {
                  await postpembayaranbox.put(globalkeybox,listpostdata);
                }
                await boxPembayaranReport.delete(globalkeybox);
                await boxPembayaranReport.put(globalkeybox,await tojsondata(dataconvert));
            } else {
                print("else 1");
              var flag = 0;
                for (var i = 0; i < jsonResponse["data"][0]["errors"].length; i++) {
                  if(jsonResponse["data"][0]["errors"][i]['code'] == AppConfig().orderalreadyexistvendor){
                      dataconvert[idx].condition = "success";
                      listpostdata.removeAt(idxpost);
                      await postpembayaranbox.delete(globalkeybox);
                      if(listpostdata.isNotEmpty) {
                        await postpembayaranbox.put(globalkeybox,listpostdata);
                      }
                      await boxPembayaranReport.delete(globalkeybox);
                      await boxPembayaranReport.put(globalkeybox,await tojsondata(dataconvert));
                      flag = 1;
                  }
                }
                if(flag == 0){
                  dataconvert[idx].condition = "pending";
                  await boxPembayaranReport.delete(globalkeybox);
                  await boxPembayaranReport.put(globalkeybox,await tojsondata(dataconvert));
                }
            }
          } else {
                print("else 2");
            dataconvert[idx].condition = "pending";
            await boxPembayaranReport.delete(globalkeybox);
            await boxPembayaranReport.put(globalkeybox,await tojsondata(dataconvert));
          }
        } else {
                print("else 3");
          dataconvert[idx].condition = "pending";
          await boxPembayaranReport.delete(globalkeybox);
          await boxPembayaranReport.put(globalkeybox,await tojsondata(dataconvert));
          print(responseString);
        }
      } on SocketException {
          dataconvert[idx].condition = "pending";
          await boxPembayaranReport.delete(globalkeybox);
          await boxPembayaranReport.put(globalkeybox,await tojsondata(dataconvert));
          print("socketexception");
      } catch (e) {
          dataconvert[idx].condition = "pending";
          await boxPembayaranReport.delete(globalkeybox);
          await boxPembayaranReport.put(globalkeybox,await tojsondata(dataconvert));
          print("$e abnormal ");
      }  finally{
          await closebox();
          controllerLaporan.getReportList(true);
      }
  }
  
  callcontroller(String controllername){
    if(controllername.toLowerCase() == "LaporanController".toLowerCase()){
      final isControllerRegistered = GetInstance().isRegistered<LaporanController>();
      if(!isControllerRegistered){
          final LaporanController controller =  Get.put(LaporanController());
          return controller;
      } else {
          final LaporanController controller = Get.find();
          return controller;
      }
    } else if (controllername.toLowerCase() == "splashscreencontroller".toLowerCase()){
      final isControllerRegistered = GetInstance().isRegistered<SplashscreenController>();
      if(!isControllerRegistered){
          final SplashscreenController controller =  Get.put(SplashscreenController());
          return controller;
      } else {
          final SplashscreenController controller = Get.find();
          return controller;
      }    
    }
    
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
