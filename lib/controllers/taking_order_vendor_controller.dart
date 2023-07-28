import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/models/cartmodel.dart';
import 'package:sfa_tools/models/productdata.dart';
import 'package:sfa_tools/screens/takingordervendor/checkoutlist.dart';
import 'package:sfa_tools/widgets/customelevatedbutton.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../screens/takingordervendor/cartlist.dart';

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
        ProductData('asc', dummyList[0], [DetailProductData('dos', 15000)]));
    listProduct.add(ProductData('desc', dummyList[1], [
      DetailProductData('kaleng', 10000),
      DetailProductData('biji', 20000)
    ]));
    listProduct.add(ProductData(
        'ccc', dummyList[2], [DetailProductData('inner plas', 25000)]));
    listProduct.add(ProductData('acc', dummyList[3],
        [DetailProductData('biji', 30000), DetailProductData('dos', 35000)]));
    listProduct.add(ProductData('cca', dummyList[4], [
      DetailProductData('dos', 50000),
      DetailProductData('inner plas', 100000),
      DetailProductData('biji', 120000)
    ]));
    listProduct.add(
        ProductData('cac', dummyList[5], [DetailProductData('dos', 200000)]));

    for (var i = 0; i < listProduct.length; i++) {
      listDropDown.add(DropDownValueModel(
          value: listProduct[i].kdProduct, name: listProduct[i].nmProduct));
    }
  }

  handleAddMinusBtn(TextEditingController ctrl, var action) {
    print(action);
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
    print(ctrl.text);
  }

  addToCart() {
    for (var i = 0; i < selectedProduct.value[0].detailProduct.length; i++) {
      if (i == 0 && qty1.value.text != "" && int.parse(qty1.value.text) != 0) {
        cartList.add(CartModel(
            selectedProduct.value[0].kdProduct,
            selectedProduct.value[0].nmProduct,
            int.parse(qty1.value.text),
            selectedProduct.value[0].detailProduct[i].satuan,
            selectedProduct.value[0].detailProduct[i].hrg));
      } else if (i == 1 &&
          qty2.value.text != "" &&
          int.parse(qty2.value.text) != 0) {
        cartList.add(CartModel(
            selectedProduct.value[0].kdProduct,
            selectedProduct.value[0].nmProduct,
            int.parse(qty2.value.text),
            selectedProduct.value[0].detailProduct[i].satuan,
            selectedProduct.value[0].detailProduct[i].hrg));
      } else if (i == 2 &&
          qty3.value.text != "" &&
          int.parse(qty3.value.text) != 0) {
        cartList.add(CartModel(
            selectedProduct.value[0].kdProduct,
            selectedProduct.value[0].nmProduct,
            int.parse(qty3.value.text),
            selectedProduct.value[0].detailProduct[i].satuan,
            selectedProduct.value[0].detailProduct[i].hrg));
      }
    }
    selectedValue.value = "";
    selectedProduct.clear();
    cnt.clearDropDown();
    fillCartDetail();
  }

  updateCart() {
    cartList.removeWhere(
        (element) => element.kdProduct == selectedProduct[0].kdProduct);
    addToCart();
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

  getDetailProduct(String kdProduct) {
    List<ProductData> _list = <ProductData>[];
    // print(cnt.dropDownValue!.value);
    for (var i = 0; i < listProduct.length; i++) {
      if (listProduct[i].kdProduct == kdProduct) {
        _list.add(listProduct[i]);
        selectedProduct.value = _list;
      }
    }
    // print(selectedProduct.value[0].detailProduct[0].satuan);
  }

  handleDeleteItem(CartDetail data) {
    Get.dialog(Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: SizedBox(
        width: Get.width * 0.5,
        height: 0.4 * Get.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Get.height * 0.03,
            ),
            TextView(
              text: "Konfirmasi Hapus",
              headings: 'H3',
              fontSize: 17,
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Lottie.asset('assets/lottie/delete.json', width: Get.width * 0.25),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Container(
              width: Get.width * 0.4,
              child: TextView(
                text: "Yakin ingin menghapus ${data.nmProduct}?",
                headings: 'H4',
                textAlign: TextAlign.center,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomElevatedButton("BATAL", () {
                  Get.back();
                }, 0.18 * Get.width, 0.045 * Get.height, 8, Colors.white,
                    AppConfig.mainCyan, 0, AppConfig.mainCyan, 'H2'),
                CustomElevatedButton("YA, HAPUS", () async {
                  await deleteItem(data);
                  Get.back();
                }, 0.18 * Get.width, 0.045 * Get.height, 8, AppConfig.mainCyan,
                    Colors.white, 2, AppConfig.mainCyan, 'H2')
              ],
            )
          ],
        ),
      ),
    ));
  }

  deleteItem(CartDetail data) {
    cartList.removeWhere((element) => element.kdProduct == data.kdProduct);
    fillCartDetail();
  }

  handleEditItem(CartDetail data) {
    selectedValue.value = data.kdProduct.toString();
    qty1.value.text = '0';
    qty2.value.text = '0';
    qty3.value.text = '0';
    for (var i = 0; i < data.itemOrder.length; i++) {
      if (i == 0) {
        qty1.value.text = data.itemOrder[i].Qty.toString();
      } else if (i == 1) {
        qty2.value.text = data.itemOrder[i].Qty.toString();
      } else if (i == 2) {
        qty3.value.text = data.itemOrder[i].Qty.toString();
      }
    }
    getDetailProduct(data.kdProduct);
  }

  handleProductSearchButton(String val) {
    selectedValue.value = val;
    qty1.value.text = "0";
    qty2.value.text = "0";
    qty3.value.text = "0";
    getDetailProduct(val);
    if (cartList.isNotEmpty) {
      if (cartList
          .any((data) => data.kdProduct == selectedProduct[0].kdProduct)) {
        for (var i = 0; i < cartDetailList.length; i++) {
          if (cartDetailList[i].kdProduct == selectedProduct[0].kdProduct) {
            for (var j = 0; j < cartDetailList[i].itemOrder.length; j++) {
              if (j == 0) {
                qty1.value.text = cartDetailList[i].itemOrder[j].Qty.toString();
              } else if (j == 1) {
                qty2.value.text = cartDetailList[i].itemOrder[j].Qty.toString();
              } else if (j == 2) {
                qty3.value.text = cartDetailList[i].itemOrder[j].Qty.toString();
              }
            }
          }
        }
      }
    }
  }

  previewCheckOut() {
    Get.dialog(Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: SizedBox(
        width: Get.width * 0.9,
        height: 0.85 * Get.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height * 0.03,
              ),
              TextView(
                text: "Penjualan - Adek Abang",
                headings: 'H3',
                fontSize: 17,
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              TextView(
                text: "Alamat Pengiriman",
                headings: 'H3',
                fontSize: 15,
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Container(
                width: 0.8 * Get.width,
                height: 0.05 * Get.height,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.home,
                        color: AppConfig.mainCyan,
                        size:
                            16), // Use any desired icon from flutter_icons package
                    SizedBox(
                        width: 8), // Adjust the space between icon and text
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value:
                              'Pemancar Lamtemen Timur', // Set the currently selected value here
                          onChanged: (String? newValue) {
                            // Handle dropdown value change here
                          },
                          items: <String>[
                            'Pemancar Lamtemen Timur',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: TextView(
                                text: value,
                                textAlign: TextAlign.left,
                                fontSize: 14,
                                headings: 'H4',
                              ), // Align text to the left
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Container(
                width: 0.9 * Get.width,
                height: 10,
                color: Colors.grey.shade200,
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 0.45 * Get.width,
                    height: 0.1 * Get.height,
                    child: TextFormField(
                      // controller: _textEditingController,
                      decoration: InputDecoration(
                        labelText: 'Catatan / Keterangan',
                        icon: Image.asset(
                          'assets/images/notes.png',
                          width: 45,
                          height: 45,
                          fit: BoxFit.fill,
                        ),
                      ),
                      maxLength: 150,
                      maxLines: null,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 14),
                      onChanged: (text) {
                        // Handle text changes here
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade500, width: 1),
                        backgroundColor: Colors.white,
                        elevation: 2,
                        fixedSize: Size(0.27 * Get.width, 0.07 * Get.height),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.all(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextView(
                            text: 'Ganti Barang',
                            color: Colors.black,
                            headings: 'H4',
                            fontSize: 14,
                          ),
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green.shade700),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  Icons.manage_search,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ],
                      ))
                ],
              ),
              Container(
                width: 0.85 * Get.width,
                height: Get.height * 0.4,
                child: ListView.builder(
                  itemCount: cartDetailList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 0.05 * Get.width,
                          top: 5,
                          right: 0.05 * Get.width),
                      child: CheckoutList(
                          idx: (index + 1).toString(),
                          data: cartDetailList[index]),
                    );
                  },
                  physics: BouncingScrollPhysics(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 0.75 * Get.width,
                height: 0.06 * Get.height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    borderRadius: BorderRadius.circular(8)),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextView(
                          text: "${cartDetailList.length}",
                          headings: 'H2',
                          fontSize: 15,
                          color: Colors.amber.shade900,
                        ),
                        TextView(
                          text: "Produk",
                          headings: 'H4',
                          fontSize: 13,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 1.5,
                    height: 0.06 * Get.height,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    'assets/images/custorder.png',
                    width: 35,
                    height: 35,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextView(
                          text: formatNumber(countPriceTotal()),
                          headings: 'H2',
                          fontSize: 15,
                          color: Colors.amber.shade900,
                        ),
                        TextView(
                          text: "Perkiraan Pesanan",
                          headings: 'H4',
                          fontSize: 13,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 1.5,
                    height: 0.06 * Get.height,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Image.asset(
                    'assets/images/komisi.png',
                    width: 35,
                    height: 35,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextView(
                          text: formatNumber(2500),
                          headings: 'H2',
                          fontSize: 15,
                          color: Colors.amber.shade900,
                        ),
                        TextView(
                          text: "Perkiraan Komisi",
                          headings: 'H4',
                          fontSize: 13,
                        )
                      ],
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: 0.02 * Get.height,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomElevatedButton("BATAL", () {
                    Get.back();
                  }, 0.18 * Get.width, 0.04 * Get.height, 4, Colors.white,
                      AppConfig.mainCyan, 0, AppConfig.mainCyan, 'H2'),
                  CustomElevatedButton("SIMPAN", () async {
                    Get.back();
                  }, 0.18 * Get.width, 0.04 * Get.height, 4, AppConfig.mainCyan,
                      Colors.white, 2, AppConfig.mainCyan, 'H2')
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
