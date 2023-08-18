import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sfa_tools/screens/taking_order_vendor/payment/paymentlist.dart';

import '../common/app_config.dart';
import '../models/paymentdata.dart';
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
          listpaymentdata.add(PaymentData(
              type,
              "",
              choosedTunaiMethod.value,
              "",
              double.parse(
                  nominaltunai.value.text.toString().replaceAll(',', ''))));
        } else {
          pembayaranListKey.currentState?.insertItem(listpaymentdata.length);
          listpaymentdata.add(PaymentData(
              type,
              "",
              choosedTunaiMethod.value,
              "",
              double.parse(
                  nominaltunai.value.text.toString().replaceAll(',', ''))));
        }
      } else if (type == "Transfer") {
        if (listpaymentdata.any((data) => data.jenis == 'Transfer')) {
          listpaymentdata.removeWhere((element) => element.jenis == type);
          listpaymentdata.add(PaymentData(
              type,
              "",
              choosedTransferMethod.value,
              "",
              double.parse(
                  nominaltransfer.value.text.toString().replaceAll(',', ''))));
        } else {
          pembayaranListKey.currentState?.insertItem(listpaymentdata.length);
          listpaymentdata.add(PaymentData(
              type,
              "",
              choosedTransferMethod.value,
              "",
              double.parse(
                  nominaltransfer.value.text.toString().replaceAll(',', ''))));
        }
      } else if (type == "cn") {
        if (listpaymentdata.any((data) => data.jenis == 'cn')) {
          listpaymentdata.removeWhere((element) => element.jenis == type);
          listpaymentdata.add(PaymentData(
              "cn",
              "",
              "",
              "",
              double.parse(
                  nominalCn.value.text.toString().replaceAll(',', ''))));
        } else {
          pembayaranListKey.currentState?.insertItem(listpaymentdata.length);
          listpaymentdata.add(PaymentData(
              "cn",
              "",
              "",
              "",
              double.parse(
                  nominalCn.value.text.toString().replaceAll(',', ''))));
        }
      } else {
        if (listpaymentdata.any((data) => data.jenis == 'cek')) {
          listpaymentdata.removeWhere((element) => element.jenis == type);
          listpaymentdata.add(PaymentData(
              "cek",
              nomorcek.value.text,
              nmbank.value.text,
              jatuhtempotgl.value.text,
              double.parse(
                  nominalcek.value.text.toString().replaceAll(',', ''))));
        } else {
          pembayaranListKey.currentState?.insertItem(listpaymentdata.length);
          listpaymentdata.add(PaymentData(
              "cek",
              nomorcek.value.text,
              nmbank.value.text,
              jatuhtempotgl.value.text,
              double.parse(
                  nominalcek.value.text.toString().replaceAll(',', ''))));
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
          PaymentData _dataTemp = listpaymentdata[i];
          // listpaymentdata.removeWhere((element) => element.jenis == jenis);
          pembayaranListKey.currentState!.removeItem(
              i,
              (context, animation) => SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(-1, 0),
                      end: Offset(0, 0),
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
                        metode: _dataTemp.jenis == "cn"
                            ? "Potongan CN"
                            : _dataTemp.jenis == "cek"
                                ? "Cek / Giro / Slip - ${_dataTemp.tipe} [${_dataTemp.nomor}]"
                                : "${_dataTemp.jenis} - ${_dataTemp.tipe}",
                        jatuhtempo: _dataTemp.jatuhtempo == ""
                            ? _dataTemp.jatuhtempo
                            : "Jatuh Tempo : ${_dataTemp.jatuhtempo}",
                        value: "Rp ${formatNumber(_dataTemp.value.toInt())}",
                        jenis: _dataTemp.jenis,
                      ),
                    ),
                  ),
              duration: Duration(milliseconds: 500));

          await Future.delayed(Duration(milliseconds: 500));
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

  String formatNumber(int number) {
    final NumberFormat numberFormat = NumberFormat('#,##0');
    return numberFormat.format(number);
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
        nominaltunai.value.text =
            formatNumber(listpaymentdata[idx].value.toInt());
        controller.index = tabvaluetunai;
      } else if (jenis == "Transfer") {
        choosedTransferMethod.value = listpaymentdata[idx].tipe;
        nominaltransfer.value.text =
            formatNumber(listpaymentdata[idx].value.toInt());
        controller.index = tabvaluetransfer;
      } else if (jenis == "cn") {
        nominalCn.value.text = formatNumber(listpaymentdata[idx].value.toInt());
        controller.index = tabvalueCn;
      } else if (jenis == "cek") {
        nomorcek.value.text = listpaymentdata[idx].nomor.toString();
        nmbank.value.text = listpaymentdata[idx].tipe.toString();
        jatuhtempotgl.value.text = listpaymentdata[idx].jatuhtempo.toString();
        nominalcek.value.text =
            formatNumber(listpaymentdata[idx].value.toInt());
        controller.index = tabvaluecek;
      }
    } catch (e) {
      print(e);
    }
  }

  formatMoneyTextField(TextEditingController ctrl) {
    try {
      ctrl.text =
          formatNumber(int.parse(ctrl.text.toString().replaceAll(',', '')));
    } catch (e) {}
  }
}
