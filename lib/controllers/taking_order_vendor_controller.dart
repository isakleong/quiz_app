import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sfa_tools/models/cartmodel.dart';
import 'package:sfa_tools/models/productdata.dart';

class TakingOrderVendorController extends GetxController with StateMixin {
  RxString selectedValue = "".obs;
  RxList<ProductData> selectedProduct = <ProductData>[].obs;
  RxList<ProductData> listProduct = <ProductData>[].obs;
  RxList<DropDownValueModel> listDropDown = <DropDownValueModel>[].obs;
  RxList<CartModel> cartList = <CartModel>[].obs;
  RxList<CartDetail> cartDetailList = <CartDetail>[].obs;
  late SingleValueDropDownController cnt;
  Rx<TextEditingController> qty1 = TextEditingController().obs;
  Rx<TextEditingController> qty2 = TextEditingController().obs;
  Rx<TextEditingController> qty3 = TextEditingController().obs;

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
    listProduct.add(
        ProductData('asc', dummyList[0], [DetailProductData('dos', 10000)]));
    listProduct.add(ProductData('desc', dummyList[1], [
      DetailProductData('kaleng', 10000),
      DetailProductData('biji', 10000)
    ]));
    listProduct.add(ProductData(
        'ccc', dummyList[2], [DetailProductData('inner plas', 10000)]));
    listProduct.add(ProductData('acc', dummyList[3],
        [DetailProductData('biji', 10000), DetailProductData('dos', 10000)]));
    listProduct.add(ProductData('cca', dummyList[4], [
      DetailProductData('dos', 10000),
      DetailProductData('inner plas', 10000),
      DetailProductData('biji', 10000)
    ]));
    listProduct.add(
        ProductData('cac', dummyList[5], [DetailProductData('dos', 10000)]));

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
    fillCartDetail();
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

  fillCartDetail() {
    cartDetailList.clear();
    for (var i = 0; i < cartList.length; i++) {
      if (cartDetailList.isEmpty) {
        print("added here ${cartList[i].kdProduct} 1");
        List<CartModel> _data = [
          CartModel(cartList[i].kdProduct, cartList[i].nmProduct,
              cartList[i].Qty, cartList[i].Satuan, cartList[i].hrgPerPieces)
        ];
        cartDetailList.add(
            CartDetail(cartList[i].kdProduct, cartList[i].nmProduct, _data));
      } else {
        for (var j = 0; j < cartDetailList.length; j++) {
          if (cartDetailList[j].kdProduct == cartList[i].kdProduct) {
            var _counter = 0;
            for (var l = 0; l < cartDetailList[j].itemOrder.length; l++) {
              if (cartDetailList[j].itemOrder[l].Satuan == cartList[i].Satuan) {
                _counter++;
                break;
              }
            }
            if (_counter == 0) {
              print("added here ${cartList[i].kdProduct} 2");
              cartDetailList[j].itemOrder.add(CartModel(
                  cartList[i].kdProduct,
                  cartList[i].nmProduct,
                  cartList[i].Qty,
                  cartList[i].Satuan,
                  cartList[i].hrgPerPieces));
            }
          } else if (cartDetailList[j].kdProduct != cartList[i].kdProduct) {
            var _counter = 0;
            for (var k = 0; k < cartDetailList.length; k++) {
              if (cartDetailList[k].kdProduct == cartList[i].kdProduct) {
                _counter++;
                break;
              }
            }
            if (_counter == 0) {
              print("added here ${cartList[i].kdProduct} 3");
              List<CartModel> _data = [
                CartModel(
                    cartList[i].kdProduct,
                    cartList[i].nmProduct,
                    cartList[i].Qty,
                    cartList[i].Satuan,
                    cartList[i].hrgPerPieces)
              ];
              cartDetailList.add(CartDetail(
                  cartList[i].kdProduct, cartList[i].nmProduct, _data));
            }
          }
        }
      }
    }
  }

  countTotalDetail(CartDetail _data) {
    var total = 0.0;
    print(_data.itemOrder.length);
    for (var i = 0; i < _data.itemOrder.length; i++) {
      print(
          "qty ${_data.itemOrder[i].Qty} hrg ${_data.itemOrder[i].hrgPerPieces}");
      total =
          total + (_data.itemOrder[i].Qty * _data.itemOrder[i].hrgPerPieces);
      print(total);
    }
    return total.toInt();
  }

  getDetailProduct() {
    List<ProductData> _list = <ProductData>[];
    for (var i = 0; i < listProduct.length; i++) {
      if (listProduct[i].kdProduct == cnt.dropDownValue!.value) {
        _list.add(listProduct[0]);
        selectedProduct.value = _list;
      }
    }
  }
}
