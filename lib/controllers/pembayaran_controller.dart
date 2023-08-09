import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
              Get.back();
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

  deletePayment(String jenis) {
    try {
      listpaymentdata.removeWhere((element) => element.jenis == jenis);
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
        controller.index = 0;
      } else if (jenis == "Transfer") {
        choosedTransferMethod.value = listpaymentdata[idx].tipe;
        nominaltransfer.value.text =
            formatNumber(listpaymentdata[idx].value.toInt());
        controller.index = 1;
      } else if (jenis == "cn") {
        nominalCn.value.text = formatNumber(listpaymentdata[idx].value.toInt());
        controller.index = 2;
      } else {
        nomorcek.value.text = listpaymentdata[idx].nomor.toString();
        nmbank.value.text = listpaymentdata[idx].tipe.toString();
        jatuhtempotgl.value.text = listpaymentdata[idx].jatuhtempo.toString();
        nominalcek.value.text =
            formatNumber(listpaymentdata[idx].value.toInt());
        controller.index = 3;
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
