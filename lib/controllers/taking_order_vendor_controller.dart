import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sfa_tools/models/cartmodel.dart';
import 'package:sfa_tools/models/productdata.dart';

class TakingOrderVendorController extends GetxController with StateMixin {
  RxString selectedValue = "".obs;
  RxList<ProductData> listProduct = <ProductData>[].obs;
  RxList<DropDownValueModel> listDropDown = <DropDownValueModel>[].obs;
  RxList<CartModel> cartList = <CartModel>[].obs;
  late SingleValueDropDownController cnt;
  Rx<TextEditingController> qty1 = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    cnt = SingleValueDropDownController();
    getListItem();
  }

  getListItem() {
    var dummyList = [
      'Aries Bling Emulsion SW - 18 KG',
      'ABSOLUTE Roof 30 - 2.5 LT',
      'AVIAN Cling Synthetic SWM - 3.4 LT',
      'AVIAN Cling Synthetic 11 - 17 LT',
      'Acura Sb 120 Sonoma Oak',
      'AVIAN Cling Zinc Chromate 901 - 1 KG'
    ];
    listProduct.clear();
    listProduct.add(ProductData('asc', dummyList[0]));
    listProduct.add(ProductData('desc', dummyList[1]));
    listProduct.add(ProductData('ccc', dummyList[2]));
    listProduct.add(ProductData('acc', dummyList[3]));
    listProduct.add(ProductData('cca', dummyList[4]));
    listProduct.add(ProductData('cac', dummyList[5]));

    for (var i = 0; i < listProduct.length; i++) {
      listDropDown.add(DropDownValueModel(
          value: listProduct[i].kdProduct, name: listProduct[i].nmProduct));
    }
  }

  handleAddMinusBtn(TextEditingController ctrl, var action) {
    if (action == '+') {
      if (ctrl.text != "") {
        var newqty = int.parse(ctrl.text) + 1;
        ctrl.text = newqty.toString();
      }
    } else {
      if (ctrl.text != "" && ctrl.text != "0") {
        var newqty = int.parse(ctrl.text) - 1;
        ctrl.text = newqty.toString();
      }
    }
  }

  addToCart(String kdProduct, String nmProduct, double price, int qty,
      String satuan) {
    cartList.add(CartModel(kdProduct, nmProduct, qty, satuan, price));
    selectedValue.value = "";
    cnt.clearDropDown();
  }

  countProductTotal() {
    var listProductinCart = [];
    for (var i = 0; i < cartList.length; i++) {
      if (!listProductinCart.contains(cartList[i].kdProduct)) {
        listProductinCart.add(cartList[i].kdProduct);
      }
    }
    return listProductinCart.length;
  }

  countPriceTotal() {
    var total = 0.0;
    for (var i = 0; i < cartList.length; i++) {
      total = total +
          (double.parse(cartList[i].Qty.toString()) * cartList[i].hrgPerPieces);
    }
    return total.toInt();
  }

  String formatNumber(int number) {
    final NumberFormat numberFormat = NumberFormat('#,##0');
    return numberFormat.format(number);
  }
}
