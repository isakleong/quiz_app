import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/penjualan_controller.dart';
import 'package:sfa_tools/models/cartdetail.dart';
import 'package:sfa_tools/models/tukarwarnamodel.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/dialogdeletetukarwarna.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/dialogdelete.dart';

import '../models/cartmodel.dart';
import '../models/productdata.dart';
import '../models/tarikbarangmodel.dart';
import '../screens/taking_order_vendor/returitem/bottomsheettukarwarna.dart';
import '../screens/taking_order_vendor/returitem/dialogcheckoutgb.dart';
import '../screens/taking_order_vendor/returitem/dialogcheckoutsm.dart';
import '../screens/taking_order_vendor/returitem/dialogcheckouttb.dart';

class ReturController extends GetxController {
  RxList<bool> selectedsegment = [true, false, false, false, false].obs;
  RxInt indexSegment = 0.obs;
  //
  Rx<TextEditingController> tarikbarangfield = TextEditingController().obs;
  Rx<TextEditingController> tukarwarnafield = TextEditingController().obs;
  Rx<TextEditingController> gantikemasanfield = TextEditingController().obs;
  Rx<TextEditingController> servismebelfield = TextEditingController().obs;
  Rx<TextEditingController> gantibarangfield = TextEditingController().obs;
  Rx<TextEditingController> produkpenggantifield = TextEditingController().obs;
  //
  RxBool tukarwarnahorizontal = false.obs;
  RxBool tarikbaranghorizontal = false.obs;
  RxBool gantikemasanhorizontal = false.obs;
  RxBool servismebelhorizontal = false.obs;
  RxBool gantibaranghorizontal = false.obs;
  //
  RxString selectedKdProducttarikbarang = "".obs;
  RxString selectedKdProductgantikemasan = "".obs;
  RxString selectedKdProductservismebel = "".obs;
  RxString selectedKdProductgantibarang = "".obs;
  RxString selectedKdProductTukarWarna = "".obs;
  RxString selectedKdProductProdukPengganti = "".obs;
  //
  RxList<ProductData> selectedProducttarikbarang = <ProductData>[].obs;
  RxList<ProductData> selectedProductgantikemasan = <ProductData>[].obs;
  RxList<ProductData> selectedProductservismebel = <ProductData>[].obs;
  RxList<ProductData> selectedProductgantibarang = <ProductData>[].obs;
  RxList<ProductData> selectedProductTukarWarna = <ProductData>[].obs;
  RxList<ProductData> selectedProductProdukPengganti = <ProductData>[].obs;
  //
  RxList<int> listQtytb = [0].obs;
  RxList<int> listQtygk = [0].obs;
  RxList<int> listQtysm = [0].obs;
  RxList<int> listQtygb = [0].obs;
  RxList<int> listQtytw = [0].obs;
  RxList<int> listQtypp = [0].obs;
  //
  RxString selectedAlasantb = "".obs;
  RxString selectedAlasangk = "".obs;
  //
  RxList<TarikBarangModel> listTarikBarang = <TarikBarangModel>[].obs;
  RxList<TarikBarangModel> listgantikemasan = <TarikBarangModel>[].obs;
  RxList<TarikBarangModel> listServisMebel = <TarikBarangModel>[].obs;
  RxList<TarikBarangModel> listGantiBarang = <TarikBarangModel>[].obs;
  RxList<TukarWarnaModel> listTukarWarna = <TukarWarnaModel>[].obs;
  RxList<TarikBarangModel> listProdukPengganti = <TarikBarangModel>[].obs;
  RxList<TarikBarangModel> listitemforProdukPengganti = <TarikBarangModel>[].obs;
  //
  RxBool isOverfow = false.obs;
  //
  RxList listSisa = [].obs;
  final PenjualanController _penjualanController = Get.find();

  handleProductSearchTb(String val) async {
    selectedKdProducttarikbarang.value = val;
    selectedAlasantb.value = "";
    listQtytb.clear();
    for (var i = 0; i < 10; i++) {
      listQtytb.add(0);
    }
    if (listTarikBarang.isNotEmpty && listTarikBarang.any((data) => data.kdProduct == val)) {
      for (var i = 0; i < listTarikBarang.length; i++) {
        if (val == listTarikBarang[i].kdProduct) {
          handleEditTarikBarangItem(listTarikBarang[i]);
        }
      }
    } else {
      await getDetailProduct(val, "tb");
    }
    tarikbarangfield.value.clear();
  }

  handleProductSearchGk(String val) async {
    selectedKdProductgantikemasan.value = val;
    selectedAlasangk.value = "";
    listQtygk.clear();
    for (var i = 0; i < 10; i++) {
      listQtygk.add(0);
    }
    if (listgantikemasan.isNotEmpty && listgantikemasan.any((data) => data.kdProduct == val)) {
      for (var i = 0; i < listgantikemasan.length; i++) {
        if (val == listgantikemasan[i].kdProduct) {
          handleEditGantiKemasanItem(listgantikemasan[i]);
        }
      }
    } else {
      await getDetailProduct(val, "gk");
    }
    gantikemasanfield.value.clear();
  }

  handleProductSearchSm(String val) async {
    selectedKdProductservismebel.value = val;
    listQtysm.clear();
    for (var i = 0; i < 10; i++) {
      listQtysm.add(0);
    }
    if (listServisMebel.isNotEmpty && listServisMebel.any((data) => data.kdProduct == val)) {
      for (var i = 0; i < listServisMebel.length; i++) {
        if (val == listServisMebel[i].kdProduct) {
          handleEditServisMebelItem(listServisMebel[i]);
        }
      }
    } else {
      await getDetailProduct(val, "sm");
    }
    servismebelfield.value.clear();
  }

  handleProductSearchGb(String val) async {
    selectedKdProductgantibarang.value = val;
    listQtygb.clear();
    for (var i = 0; i < 10; i++) {
      listQtygb.add(0);
    }
    if (listGantiBarang.isNotEmpty && listGantiBarang.any((data) => data.kdProduct == val)) {
      for (var i = 0; i < listGantiBarang.length; i++) {
        if (val == listGantiBarang[i].kdProduct) {
          handleEditGantiBarangItem(listGantiBarang[i]);
        }
      }
    } else {
      await getDetailProduct(val, "gb");
    }
    gantibarangfield.value.clear();
  }

  handleProductSearchTw(String val) async {
    selectedKdProductTukarWarna.value = val;
    listQtytw.clear();
    for (var i = 0; i < 10; i++) {
      listQtytw.add(0);
    }
    if (listTukarWarna.isNotEmpty &&
        listTukarWarna.any((data) => data.kdProduct == val)) {
      for (var i = 0; i < listTukarWarna.length; i++) {
        if (val == listTukarWarna[i].kdProduct) {
          handleEditTukarWarnaItem(listTukarWarna[i]);
        }
      }
    } else {
      await getDetailProduct(val, "tw");
    }
    tukarwarnafield.value.clear();
  }

  handleProductSearchPp(String val) async {
    isOverfow.value = false;
    selectedKdProductProdukPengganti.value = val;
    listQtypp.clear();
    for (var i = 0; i < 10; i++) {
      listQtypp.add(0);
    }
    if (listProdukPengganti.isNotEmpty &&
        listProdukPengganti.any((data) => data.kdProduct == val)) {
      for (var i = 0; i < listProdukPengganti.length; i++) {
        if (val == listProdukPengganti[i].kdProduct) {
          handleEditProdukPenggantiItem(listProdukPengganti[i]);
        }
      }
    } else {
      await getDetailProduct(val, "pp");
    }
    produkpenggantifield.value.clear();
  }

  getDetailProduct(String kdProduct, String from) async {
    var list = await getDetailProductList(kdProduct);
    if (from == "gk") {
      selectedProductgantikemasan.value = list;
    } else if (from == "tb") {
      selectedProducttarikbarang.value = list;
    } else if (from == "sm") {
      selectedProductservismebel.value = list;
    } else if (from == "gb") {
      selectedProductgantibarang.value = list;
    } else if (from == "tw") {
      selectedProductTukarWarna.value = list;
    } else if (from == "pp") {
      selectedProductProdukPengganti.value = list;
    }
  }

  getDetailProductList(String kdProduct) {
    List<ProductData> list = <ProductData>[];
    for (var i = 0; i < _penjualanController.listProduct.length; i++) {
      if (_penjualanController.listProduct[i].kdProduct == kdProduct) {
        list.add(_penjualanController.listProduct[i]);
        return list;
      }
    }
  }

  handleEditTarikBarangItem(TarikBarangModel data) {
    selectedKdProducttarikbarang.value = data.kdProduct.toString();
    listQtytb.clear();
    for (var i = 0; i < 10; i++) {
      listQtytb.add(0);
    }
    selectedAlasantb.value = data.alasan;
    for (var k = 0; k < _penjualanController.listProduct.length; k++) {
      if (_penjualanController.listProduct[k].kdProduct == data.kdProduct) {
        for (var i = 0; i < data.itemOrder.length; i++) {
          for (var j = 0;j < _penjualanController.listProduct[k].detailProduct.length;j++) {
            if( _penjualanController.listProduct[k].detailProduct[j].satuan == data.itemOrder[i].Satuan){
                listQtytb[j] = data.itemOrder[i].Qty;
            }
          }
        }
      }
    }

    getDetailProduct(data.kdProduct, "tb");
  }

  handleEditGantiKemasanItem(TarikBarangModel data) {
    selectedKdProductgantikemasan.value = data.kdProduct.toString();
    listQtygk.clear();
    for (var i = 0; i < 10; i++) {
      listQtygk.add(0);
    }
    selectedAlasangk.value = data.alasan;
    for (var k = 0; k < _penjualanController.listProduct.length; k++) {
      if (_penjualanController.listProduct[k].kdProduct == data.kdProduct) {
        for (var i = 0; i < data.itemOrder.length; i++) {
          for (var j = 0;j < _penjualanController.listProduct[k].detailProduct.length;j++) {
            if( _penjualanController.listProduct[k].detailProduct[j].satuan == data.itemOrder[i].Satuan){
                listQtygk[j] = data.itemOrder[i].Qty;
            }
          }
        }
      }
    }

    getDetailProduct(data.kdProduct, "gk");
  }

  handleEditServisMebelItem(TarikBarangModel data) {
    selectedKdProductservismebel.value = data.kdProduct.toString();
    listQtysm.clear();
    for (var i = 0; i < 10; i++) {
      listQtysm.add(0);
    }
    for (var k = 0; k < _penjualanController.listProduct.length; k++) {
      if (_penjualanController.listProduct[k].kdProduct == data.kdProduct) {
        for (var i = 0; i < data.itemOrder.length; i++) {
          for (var j = 0; j < _penjualanController.listProduct[k].detailProduct.length; j++) {
            if( _penjualanController.listProduct[k].detailProduct[j].satuan == data.itemOrder[i].Satuan){
                listQtysm[j] = data.itemOrder[i].Qty;
            }
          }
        }
      }
    }

    getDetailProduct(data.kdProduct, "sm");
  }

  handleEditGantiBarangItem(TarikBarangModel data) {
    selectedKdProductgantibarang.value = data.kdProduct.toString();
    listQtygb.clear();
    for (var i = 0; i < 10; i++) {
      listQtygb.add(0);
    }
    for (var k = 0; k < _penjualanController.listProduct.length; k++) {
      if (_penjualanController.listProduct[k].kdProduct == data.kdProduct) {
        for (var i = 0; i < data.itemOrder.length; i++) {
          for (var j = 0; j < _penjualanController.listProduct[k].detailProduct.length; j++) {
            if(_penjualanController.listProduct[k].detailProduct[j].satuan == data.itemOrder[i].Satuan){
              listQtygb[j] = data.itemOrder[i].Qty;
            }
          }
        }
      }
    }

    getDetailProduct(data.kdProduct, "gb");
  }

  handleEditTukarWarnaItem(TukarWarnaModel data) {
    selectedKdProductTukarWarna.value = data.kdProduct.toString();
    listQtytw.clear();
    for (var i = 0; i < 10; i++) {
      listQtytw.add(0);
    }
    for (var k = 0; k < _penjualanController.listProduct.length; k++) {
      if (_penjualanController.listProduct[k].kdProduct == data.kdProduct) {
        listitemforProdukPengganti.clear();
        listitemforProdukPengganti.add(TarikBarangModel(data.kdProduct, data.nmProduct, data.listqtyheader, "",data.id));
        for (var i = 0; i < data.listqtyheader.length; i++) {
          for (var j = 0;j < _penjualanController.listProduct[k].detailProduct.length;j++) {
            if (_penjualanController.listProduct[k].detailProduct[j].satuan == data.listqtyheader[i].Satuan) {
              listQtytw[i] = data.listqtyheader[i].Qty;
            } 
          }
        }
      }
    }

    getDetailProduct(data.kdProduct, "tw");
  }

  handleEditProdukPenggantiItem(TarikBarangModel data) {
    isOverfow.value = false;
    selectedKdProductProdukPengganti.value = data.kdProduct.toString();
    listQtypp.clear();
    for (var i = 0; i < 10; i++) {
      listQtypp.add(0);
    }
    for (var k = 0; k < _penjualanController.listProduct.length; k++) {
      if (_penjualanController.listProduct[k].kdProduct == data.kdProduct) {
        for (var i = 0; i < data.itemOrder.length; i++) {
          for (var j = 0; j < _penjualanController.listProduct[k].detailProduct.length; j++) {
            if (_penjualanController.listProduct[k].detailProduct[j].satuan == data.itemOrder[i].Satuan) {
              listQtypp[j] = data.itemOrder[i].Qty;
            }
          }
        }
      }
    }

    getDetailProduct(data.kdProduct, "pp");
  }

  addToCartTb() {
    if (selectedAlasantb.value == "" || selectedAlasantb.value == "Pilih Alasan Retur") {
      Get.snackbar("Error", "pilih alasan terlebih dahulu !",backgroundColor: Colors.red.withOpacity(0.5));
      return;
    }
    var flag = "null";
    for (var i = 0; i < listTarikBarang.length; i++) {
      if (selectedProducttarikbarang[0].kdProduct == listTarikBarang[i].kdProduct) {
        flag = i.toString();
        break;
      }
    }
    if (flag == "null") {
      List<CartModel> items = <CartModel>[];
      for (var i = 0; i < selectedProducttarikbarang[0].detailProduct.length; i++) {
        //print(" isi listqty ${listQtytb[i]}");
        if (listQtytb[i] != 0 ) {
          items.add(CartModel(
              selectedProducttarikbarang[0].kdProduct,
              selectedProducttarikbarang[0].nmProduct,
              listQtytb[i],
              selectedProducttarikbarang[0].detailProduct[i].satuan,
              0,
              selectedProducttarikbarang[0].id,"",'0'));
        }
      }
      if (items.isNotEmpty) {
        listTarikBarang.add(TarikBarangModel(
            selectedProducttarikbarang[0].kdProduct,
            selectedProducttarikbarang[0].nmProduct,
            items,
            selectedAlasantb.value,
            selectedProducttarikbarang[0].id));
      }

      selectedKdProducttarikbarang.value = "";
      selectedAlasantb.value = "";
      selectedProducttarikbarang.clear();
      tarikbarangfield.value.clear();
    } else {
      List<CartModel> items = <CartModel>[];
      for (var i = 0; i < selectedProducttarikbarang[0].detailProduct.length; i++) {
        if (listQtytb[i] != 0) {
          items.add(CartModel(
              selectedProducttarikbarang[0].kdProduct,
              selectedProducttarikbarang[0].nmProduct,
              listQtytb[i],
              selectedProducttarikbarang[0].detailProduct[i].satuan,
              0,
              selectedProducttarikbarang[0].id,"",'0'));
        }
      }
      if (items.isNotEmpty) {
        listTarikBarang[int.parse(flag)].kdProduct = selectedProducttarikbarang[0].kdProduct;
        listTarikBarang[int.parse(flag)].nmProduct = selectedProducttarikbarang[0].nmProduct;
        listTarikBarang[int.parse(flag)].itemOrder = items;
        listTarikBarang[int.parse(flag)].alasan = selectedAlasantb.value;
      } else {
        listTarikBarang.removeAt(int.parse(flag));
        if (listTarikBarang.isEmpty) {
          tarikbaranghorizontal.value = false;
        }
      }
      selectedKdProducttarikbarang.value = "";
      selectedAlasantb.value = "";
      selectedProducttarikbarang.clear();
      tarikbarangfield.value.clear();
    }
    if (listTarikBarang.isEmpty && selectedProducttarikbarang.isEmpty) {
      tarikbaranghorizontal.value = false;
    } else if (listTarikBarang.isEmpty && selectedProducttarikbarang.isNotEmpty) {
      tarikbaranghorizontal.value = true;
    }
  }

  addToCartGk() {
    if (selectedAlasangk.value == "" || selectedAlasangk.value == "Pilih Alasan Retur") {
      Get.snackbar("Error", "pilih alasan terlebih dahulu !",backgroundColor: Colors.red.withOpacity(0.5));
      return;
    }
    var flag = "null";
    for (var i = 0; i < listgantikemasan.length; i++) {
      if (selectedProductgantikemasan[0].kdProduct == listgantikemasan[i].kdProduct) {
        flag = i.toString();
        break;
      }
    }
    if (flag == "null") {
      List<CartModel> items = <CartModel>[];
      for (var i = 0; i < selectedProductgantikemasan[0].detailProduct.length; i++) {
        if (listQtygk[i] != 0 ) {
          items.add(CartModel(
              selectedProductgantikemasan[0].kdProduct,
              selectedProductgantikemasan[0].nmProduct,
              listQtygk[i],
              selectedProductgantikemasan[0].detailProduct[i].satuan,
              0,
              selectedProductgantikemasan[0].id,"",'0'));
        }
      }
      if (items.isNotEmpty) {
        listgantikemasan.add(TarikBarangModel(
            selectedProductgantikemasan[0].kdProduct,
            selectedProductgantikemasan[0].nmProduct,
            items,
            selectedAlasangk.value,
            selectedProductgantikemasan[0].id));
      }

      selectedKdProductgantikemasan.value = "";
      selectedAlasangk.value = "";
      selectedProductgantikemasan.clear();
      gantikemasanfield.value.clear();
    } else {
      List<CartModel> items = <CartModel>[];
      for (var i = 0; i < selectedProductgantikemasan[0].detailProduct.length; i++) {
        if (listQtygk[i] != 0) {
          items.add(CartModel(
              selectedProductgantikemasan[0].kdProduct,
              selectedProductgantikemasan[0].nmProduct,
              listQtygk[i],
              selectedProductgantikemasan[0].detailProduct[i].satuan,
              0,
              selectedProductgantikemasan[0].id,"",'0'));
        }
      }
      if (items.isNotEmpty) {
        listgantikemasan[int.parse(flag)].kdProduct = selectedProductgantikemasan[0].kdProduct;
        listgantikemasan[int.parse(flag)].nmProduct = selectedProductgantikemasan[0].nmProduct;
        listgantikemasan[int.parse(flag)].itemOrder = items;
        listgantikemasan[int.parse(flag)].alasan = selectedAlasangk.value;
      } else {
        listgantikemasan.removeAt(int.parse(flag));
        if (listgantikemasan.isEmpty) {
          gantikemasanhorizontal.value = false;
        }
      }
      selectedKdProductgantikemasan.value = "";
      selectedAlasangk.value = "";
      selectedProductgantikemasan.clear();
      gantikemasanfield.value.clear();
    }
    if (listgantikemasan.isEmpty && selectedProductgantikemasan.isEmpty) {
      gantikemasanhorizontal.value = false;
    } else if (listgantikemasan.isEmpty && selectedProductgantikemasan.isNotEmpty) {
      gantikemasanhorizontal.value = true;
    }
  }

  addToCartSm() {
    var flag = "null";
    for (var i = 0; i < listServisMebel.length; i++) {
      if (selectedProductservismebel[0].kdProduct == listServisMebel[i].kdProduct) {
        flag = i.toString();
        break;
      }
    }
    if (flag == "null") {
      List<CartModel> items = <CartModel>[];
      for (var i = 0; i < selectedProductservismebel[0].detailProduct.length; i++) {
        if (listQtysm[i] != 0 ) {
          items.add(CartModel(
              selectedProductservismebel[0].kdProduct,
              selectedProductservismebel[0].nmProduct,
              listQtysm[i],
              selectedProductservismebel[0].detailProduct[i].satuan,
              0,
              selectedProductservismebel[0].id,"",'0'));
        }
      }
      if (items.isNotEmpty) {
        listServisMebel.add(TarikBarangModel(
            selectedProductservismebel[0].kdProduct,
            selectedProductservismebel[0].nmProduct,
            items,
            "",
            selectedProductservismebel[0].id));
      }

      selectedKdProductservismebel.value = "";
      selectedProductservismebel.clear();
      servismebelfield.value.clear();
    } else {
      List<CartModel> items = <CartModel>[];
      for (var i = 0; i < selectedProductservismebel[0].detailProduct.length; i++) {
         if (listQtysm[i] != 0 ) {
          items.add(CartModel(
              selectedProductservismebel[0].kdProduct,
              selectedProductservismebel[0].nmProduct,
              listQtysm[i],
              selectedProductservismebel[0].detailProduct[i].satuan,
              0,
              selectedProductservismebel[0].id,"",'0'));
        }
      }
      if (items.isNotEmpty) {
        listServisMebel[int.parse(flag)].kdProduct = selectedProductservismebel[0].kdProduct;
        listServisMebel[int.parse(flag)].nmProduct = selectedProductservismebel[0].nmProduct;
        listServisMebel[int.parse(flag)].itemOrder = items;
        listServisMebel[int.parse(flag)].alasan = "";
      } else {
        listServisMebel.removeAt(int.parse(flag));
        if (listServisMebel.isEmpty) {
          servismebelhorizontal.value = false;
        }
      }
      selectedKdProductservismebel.value = "";
      selectedProductservismebel.clear();
      servismebelfield.value.clear();
    }
    if (listServisMebel.isEmpty && selectedProductservismebel.isEmpty) {
      servismebelhorizontal.value = false;
    } else if (listServisMebel.isEmpty &&
        selectedProductservismebel.isNotEmpty) {
      servismebelhorizontal.value = true;
    }
  }

  addToCartGb() {
    var flag = "null";
    for (var i = 0; i < listGantiBarang.length; i++) {
      if (selectedProductgantibarang[0].kdProduct == listGantiBarang[i].kdProduct) {
        flag = i.toString();
        break;
      }
    }
    if (flag == "null") {
      List<CartModel> items = <CartModel>[];
      for (var i = 0; i < selectedProductgantibarang[0].detailProduct.length; i++) {
         if (listQtygb[i] != 0 ) {
          items.add(CartModel(
              selectedProductgantibarang[0].kdProduct,
              selectedProductgantibarang[0].nmProduct,
              listQtygb[i],
              selectedProductgantibarang[0].detailProduct[i].satuan,
              0,
              selectedProductgantibarang[0].id,"",'0'));
        }
      }
      if (items.isNotEmpty) {
        listGantiBarang.add(TarikBarangModel(
            selectedProductgantibarang[0].kdProduct,
            selectedProductgantibarang[0].nmProduct,
            items,
            "",
            selectedProductgantibarang[0].id));
      }

      selectedKdProductgantibarang.value = "";
      selectedProductgantibarang.clear();
      gantibarangfield.value.clear();
    } else {
      List<CartModel> items = <CartModel>[];
      for (var i = 0; i < selectedProductgantibarang[0].detailProduct.length; i++) {
        if (listQtygb[i] != 0 ) {
          items.add(CartModel(
              selectedProductgantibarang[0].kdProduct,
              selectedProductgantibarang[0].nmProduct,
              listQtygb[i],
              selectedProductgantibarang[0].detailProduct[i].satuan,
              0,
              selectedProductgantibarang[0].id,"",'0'));
        }
      }
      if (items.isNotEmpty) {
        listGantiBarang[int.parse(flag)].kdProduct = selectedProductgantibarang[0].kdProduct;
        listGantiBarang[int.parse(flag)].nmProduct = selectedProductgantibarang[0].nmProduct;
        listGantiBarang[int.parse(flag)].itemOrder = items;
        listGantiBarang[int.parse(flag)].alasan = "";
      } else {
        listGantiBarang.removeAt(int.parse(flag));
        if (listGantiBarang.isEmpty) {
          gantibaranghorizontal.value = false;
        }
      }
      selectedKdProductgantibarang.value = "";
      selectedProductgantibarang.clear();
      gantibarangfield.value.clear();
    }
    if (listGantiBarang.isEmpty && selectedProductgantibarang.isEmpty) {
      gantibaranghorizontal.value = false;
    } else if (listGantiBarang.isEmpty && selectedProductgantibarang.isNotEmpty) {
      gantibaranghorizontal.value = true;
    }
  }

  addToCartPp() {
    var itemtotal = countTotalpengganti();
    List<CartModel> list = <CartModel>[];
    for (var i = 0; i < selectedProductProdukPengganti[0].detailProduct.length; i++) {
      if (listQtypp[i] != 0) {
        list.add(CartModel(
            selectedProductProdukPengganti[0].kdProduct,
            selectedProductProdukPengganti[0].nmProduct,
            listQtypp[i],
            selectedProductProdukPengganti[0].detailProduct[i].satuan,
            selectedProductProdukPengganti[0].detailProduct[i].hrg,
            selectedProductProdukPengganti[0].id,"",'0'));
      }
    }
    for (var i = 0; i < list.length; i++) {
      if ("dos" == list[i].Satuan) {
        itemtotal = itemtotal - (list[i].Qty * 8);
      } else if ("biji" == list[i].Satuan) {
        itemtotal = itemtotal - list[i].Qty;
      } else if ("kaleng" == list[i].Satuan) {
        itemtotal = itemtotal - list[i].Qty;
      } else if ("inner plas" == list[i].Satuan) {
        itemtotal = itemtotal - (list[i].Qty * 4);
      }
    }
    for (var i = 0; i < listProdukPengganti.length; i++) {
      if (listProdukPengganti[i].kdProduct != selectedProductProdukPengganti[0].kdProduct) {
        for (var j = 0; j < listProdukPengganti[i].itemOrder.length; j++) {
          if ("dos" == listProdukPengganti[i].itemOrder[j].Satuan) {
            itemtotal = itemtotal - (listProdukPengganti[i].itemOrder[j].Qty * 8);
          } else if ("biji" == listProdukPengganti[i].itemOrder[j].Satuan) {
            itemtotal = itemtotal - listProdukPengganti[i].itemOrder[j].Qty;
          } else if ("kaleng" == listProdukPengganti[i].itemOrder[j].Satuan) {
            itemtotal = itemtotal - listProdukPengganti[i].itemOrder[j].Qty;
          } else if ("inner plas" == listProdukPengganti[i].itemOrder[j].Satuan) {
            itemtotal =  itemtotal - (listProdukPengganti[i].itemOrder[j].Qty * 4);
          }
        }
      }
    }
    if (itemtotal < 0) {
      isOverfow.value = true;
      return;
    }

    if (listProdukPengganti.isNotEmpty && listProdukPengganti.any((data) => data.kdProduct == selectedProductProdukPengganti[0].kdProduct)) {
      for (var i = 0; i < listProdukPengganti.length; i++) {
        if (listProdukPengganti[i].kdProduct == selectedProductProdukPengganti[0].kdProduct) {
          listProdukPengganti[i].itemOrder.clear();
          if (list.isNotEmpty) {
            listProdukPengganti[i].itemOrder.addAll(list);
          } else {
            listProdukPengganti.removeAt(i);
          }
          break;
        }
      }
    } else {
      if (list.isNotEmpty) {
        listProdukPengganti.add(TarikBarangModel(
            selectedProductProdukPengganti[0].kdProduct,
            selectedProductProdukPengganti[0].nmProduct,
            list,
            "",
            selectedProductgantibarang[0].id));
      }
    }
    selectedProductProdukPengganti.clear();
    selectedKdProductProdukPengganti.value = "";
    produkpenggantifield.value.clear();
    isOverfow.value = false;
    countSisaPengganti();
  }

  handleDeleteItemRetur(TarikBarangModel data, String from) {
    Get.dialog(Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogDelete(
            nmProduct: data.nmProduct,
            ontap: () async {
              if (from == "gantikemasan") {
                await deleteGantiKemasanItem(data);
              } else if (from == "tarikbarang") {
                await deleteTarikBarangItem(data);
              } else if (from == "servismebel") {
                await deleteServisMebelItem(data);
              } else if (from == "gantibarang") {
                await deleteGantiBarangItem(data);
              } else if (from == "produkpengganti") {
                await deleteProdukPenggantiItem(data);
              }
              Get.back();
            })));
  }

  deleteTarikBarangItem(TarikBarangModel data) {
    listTarikBarang.removeWhere((element) => element.kdProduct == data.kdProduct);
    if (listTarikBarang.isEmpty && selectedProducttarikbarang.isEmpty) {
      tarikbaranghorizontal.value = false;
    } else if (listTarikBarang.isEmpty && selectedProducttarikbarang.isNotEmpty) {
      tarikbaranghorizontal.value = true;
    }
  }

  deleteGantiKemasanItem(TarikBarangModel data) {
    listgantikemasan.removeWhere((element) => element.kdProduct == data.kdProduct);
    if (listgantikemasan.isEmpty && selectedProductgantikemasan.isEmpty) {
      gantikemasanhorizontal.value = false;
    } else if (listgantikemasan.isEmpty && selectedProductgantikemasan.isNotEmpty) {
      gantikemasanhorizontal.value = true;
    }
  }

  deleteServisMebelItem(TarikBarangModel data) {
    listServisMebel.removeWhere((element) => element.kdProduct == data.kdProduct);
    if (listServisMebel.isEmpty && selectedProductservismebel.isEmpty) {
      servismebelhorizontal.value = false;
    } else if (listServisMebel.isEmpty && selectedProductservismebel.isNotEmpty) {
      servismebelhorizontal.value = true;
    }
  }

  deleteGantiBarangItem(TarikBarangModel data) {
    listGantiBarang.removeWhere((element) => element.kdProduct == data.kdProduct);
    if (listGantiBarang.isEmpty && selectedProductgantibarang.isEmpty) {
      gantibaranghorizontal.value = false;
    } else if (listGantiBarang.isEmpty && selectedProductgantibarang.isNotEmpty) {
      gantibaranghorizontal.value = true;
    }
  }

  deleteProdukPenggantiItem(TarikBarangModel data) {
    listProdukPengganti.removeWhere((element) => element.kdProduct == data.kdProduct);
    countSisaPengganti();
  }

  deleteItemTukarWarna(TukarWarnaModel data) {
    listTukarWarna.removeWhere((element) => element.kdProduct == data.kdProduct);
    if (listTukarWarna.isEmpty && selectedProductTukarWarna.isEmpty) {
      tukarwarnahorizontal.value = false;
    } else if (listTukarWarna.isEmpty && selectedProductTukarWarna.isNotEmpty) {
      tukarwarnahorizontal.value = true;
    }
  }

  handleSaveGantiBarang() {
    Get.dialog(Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogCheckoutGb()));
  }

  handleSaveServisMebel() {
    Get.dialog(Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogCheckoutSm()));
  }

  handleSaveTarikBarang() {
    Get.dialog(Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogCheckOutTb()));
  }

  handlesaveprodukpengganti(BuildContext context) {
    List<CartModel> list = <CartModel>[];
    for (var i = 0; i < listitemforProdukPengganti[0].itemOrder.length; i++) {
      CartModel data = listitemforProdukPengganti[0].itemOrder[i];
      list.add(CartModel(data.kdProduct, data.nmProduct, data.Qty, data.Satuan,data.hrgPerPieces,data.iduom,data.iditem,'0'));
    }
    List<CartDetail> listdetail = <CartDetail>[];
    for (var i = 0; i < listProdukPengganti.length; i++) {
      listdetail.add(CartDetail(listProdukPengganti[i].kdProduct,listProdukPengganti[i].nmProduct, listProdukPengganti[i].itemOrder,listProdukPengganti[i].id));
    }
    if (listTukarWarna.isEmpty) {
      listTukarWarna.add(TukarWarnaModel(selectedProductTukarWarna[0].kdProduct,selectedProductTukarWarna[0].nmProduct, list, listdetail, selectedProductTukarWarna[0].id));
    } else {
      if (listTukarWarna.any(
          (data) => data.kdProduct == selectedProductTukarWarna[0].kdProduct)) {
        for (var i = 0; i < listTukarWarna.length; i++) {
          if (listTukarWarna[i].kdProduct ==
              selectedProductTukarWarna[0].kdProduct) {
            listTukarWarna[i].listqtyheader.clear();
            listTukarWarna[i].listitemdetail.clear();
            listTukarWarna[i].listqtyheader.addAll(list);
            listTukarWarna[i].listitemdetail.addAll(listdetail);
          }
        }
      } else {
        listTukarWarna.add(TukarWarnaModel(
            selectedProductTukarWarna[0].kdProduct,
            selectedProductTukarWarna[0].nmProduct,
            list,
            listdetail,
            selectedProductTukarWarna[0].id));
      }
    }
    selectedKdProductTukarWarna.value = "";
    selectedProductTukarWarna.clear();
    tukarwarnafield.value.clear();
    Navigator.pop(context);
  }

  handleDeleteItemTukarWarna(TukarWarnaModel data) {
    Get.dialog(Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogDelete(
            nmProduct: data.nmProduct,
            ontap: () async {
              await deleteItemTukarWarna(data);
              Get.back();
            })));
  }

  showProdukPengganti(BuildContext context) {
    selectedKdProductProdukPengganti.value = "";
    selectedProductProdukPengganti.clear();
    listProdukPengganti.clear();
    produkpenggantifield.value.clear();
    listitemforProdukPengganti.clear();
    List<CartModel> list = <CartModel>[];
    for (var i = 0; i < _penjualanController.listProduct.length; i++) {
      if (_penjualanController.listProduct[i].kdProduct == selectedProductTukarWarna[0].kdProduct) {
        for (var k = 0; k < _penjualanController.listProduct[i].detailProduct.length; k++) {
          if (listQtytw[k] != 0) {
            list.add(CartModel(
                _penjualanController.listProduct[i].kdProduct,
                _penjualanController.listProduct[i].nmProduct,
                listQtytw[k],
                _penjualanController.listProduct[i].detailProduct[k].satuan,
                _penjualanController.listProduct[i].detailProduct[k].hrg,
                _penjualanController.listProduct[i].id,"",'0'));
          }
        }
        break;
      }
    }
    if (list.isEmpty) {
      selectedProductTukarWarna.clear();
      selectedKdProductTukarWarna.value = "";
      tukarwarnafield.value.clear();
    } else {
      listitemforProdukPengganti.add(TarikBarangModel(
          selectedProductTukarWarna[0].kdProduct,
          selectedProductTukarWarna[0].nmProduct,
          list,
          "",
          selectedProductTukarWarna[0].id));
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        elevation: 8.0,
        builder: (context) {
          return BottomSheetTukarWarna(
            nmProduct: selectedProductTukarWarna[0].nmProduct,
          );
        },
      );
    }
  }

  showEditProdukPengganti(BuildContext context) {
    var previtem = 0;
    for (var i = 0; i < listTukarWarna.length; i++) {
      if (selectedProductTukarWarna[0].kdProduct == listTukarWarna[i].kdProduct) {
        for (var l = 0; l < listTukarWarna[i].listqtyheader.length; l++) {
          if (listTukarWarna[i].listqtyheader[l].Satuan == "dos") {
            previtem = previtem + (listTukarWarna[i].listqtyheader[l].Qty * 8);
          } else if (listTukarWarna[i].listqtyheader[l].Satuan == "biji" || listTukarWarna[i].listqtyheader[l].Satuan == "kaleng") {
            previtem = previtem + (listTukarWarna[i].listqtyheader[l].Qty);
          } else if (listTukarWarna[i].listqtyheader[l].Satuan == "inner plas") {
            previtem = previtem + (listTukarWarna[i].listqtyheader[l].Qty * 4);
          }
        }
        break;
      }
    }
    List<CartModel> list = <CartModel>[];
    for (var i = 0; i < selectedProductTukarWarna[0].detailProduct.length; i++) {
      if(listQtytw[i] != 0){
        list.add(CartModel(
            selectedProductTukarWarna[0].kdProduct,
            selectedProductTukarWarna[0].nmProduct,
            listQtytw[i],
            selectedProductTukarWarna[0].detailProduct[i].satuan,
            selectedProductTukarWarna[0].detailProduct[i].hrg,
            selectedProductTukarWarna[0].id,"",'0'));
      }
    }
    var curritem = 0;
    for (var i = 0; i < list.length; i++) {
      if (list[i].Satuan == "dos") {
        curritem = curritem + (list[i].Qty * 8);
      } else if (list[i].Satuan == "biji" || list[i].Satuan == "kaleng") {
        curritem = curritem + (list[i].Qty);
      } else if (list[i].Satuan == "inner plas") {
        curritem = curritem + (list[i].Qty * 4);
      }
    }
    if (curritem < previtem && curritem != 0) {
      showDeleteDialogTukarWarna(context);
      return;
    } else if (curritem == 0) {
      selectedProductTukarWarna.clear();
      tukarwarnafield.value.clear();
      selectedKdProductTukarWarna.value = "";
      // print("no input");
      return;
    }
    listitemforProdukPengganti.clear();
    listitemforProdukPengganti.add(TarikBarangModel(
        selectedProductTukarWarna[0].kdProduct,
        selectedProductTukarWarna[0].nmProduct,
        list,
        "",
        selectedProductTukarWarna[0].id));
    listProdukPengganti.clear();
    for (var i = 0; i < listTukarWarna.length; i++) {
      if (selectedProductTukarWarna[0].kdProduct == listTukarWarna[i].kdProduct) {
        for (var l = 0; l < listTukarWarna[i].listitemdetail.length; l++) {
          listProdukPengganti.add(TarikBarangModel(
              listTukarWarna[i].listitemdetail[l].itemOrder[0].kdProduct,
              listTukarWarna[i].listitemdetail[l].itemOrder[0].nmProduct,
              listTukarWarna[i].listitemdetail[l].itemOrder,
              "",
              listTukarWarna[i].listitemdetail[l].itemOrder[0].iditem));
        }
        break;
      }
    }
    countSisaPengganti();
    selectedProductProdukPengganti.clear();
    selectedKdProductProdukPengganti.value = "";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      elevation: 8.0,
      builder: (context) {
        return BottomSheetTukarWarna(
          nmProduct: selectedProductTukarWarna[0].nmProduct,
        );
      },
    );
  }

  countTotalpengganti() {
    var items = 0;
    for (var i = 0; i < listitemforProdukPengganti[0].itemOrder.length; i++) {
      if ("dos" == listitemforProdukPengganti[0].itemOrder[i].Satuan) {
        items = items + (listitemforProdukPengganti[0].itemOrder[i].Qty * 8);
      } else if ("biji" == listitemforProdukPengganti[0].itemOrder[i].Satuan) {
        items = items + listitemforProdukPengganti[0].itemOrder[i].Qty;
      } else if ("kaleng" == listitemforProdukPengganti[0].itemOrder[i].Satuan) {
        items = items + listitemforProdukPengganti[0].itemOrder[i].Qty;
      } else if ("inner plas" == listitemforProdukPengganti[0].itemOrder[i].Satuan) {
        items = items + (listitemforProdukPengganti[0].itemOrder[i].Qty * 4);
      }
    }
    return items;
  }

  countSisaPengganti() {
    var itemtotal = countTotalpengganti();
    for (var i = 0; i < listProdukPengganti.length; i++) {
      for (var j = 0; j < listProdukPengganti[i].itemOrder.length; j++) {
        if ("dos" == listProdukPengganti[i].itemOrder[j].Satuan) {
          itemtotal = itemtotal - (listProdukPengganti[i].itemOrder[j].Qty * 8);
        } else if ("biji" == listProdukPengganti[i].itemOrder[j].Satuan) {
          itemtotal = itemtotal - listProdukPengganti[i].itemOrder[j].Qty;
        } else if ("kaleng" == listProdukPengganti[i].itemOrder[j].Satuan) {
          itemtotal = itemtotal - listProdukPengganti[i].itemOrder[j].Qty;
        } else if ("inner plas" == listProdukPengganti[i].itemOrder[j].Satuan) {
          itemtotal = itemtotal - (listProdukPengganti[i].itemOrder[j].Qty * 4);
        }
      }
    }
    if (itemtotal <= 0) {
      listSisa.clear();
      return 0;
    } else {
      listSisa.clear();
      while (itemtotal != 0) {
        if (itemtotal >= 8) {
          int qty = (itemtotal / 8).toInt();
          itemtotal = itemtotal - (8 * qty);
          listSisa.add("$qty dos");
        } else if (itemtotal >= 4) {
          int qty = (itemtotal / 4).toInt();
          itemtotal = itemtotal - (4 * qty);
          listSisa.add("$qty inner plas");
        } else {
          listSisa.add("$itemtotal biji");
          itemtotal = itemtotal - itemtotal;
        }
      }
      return listSisa.length;
    }
  }

  showDeleteDialogTukarWarna(BuildContext context) {
    Get.dialog(Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogDeleteTukarWarna(
          ontapbatal: () {
            Get.back();
          },
          ontapconfirm: () async {
            await showProdukPengganti(context);
            Get.back();
          },
        )));
  }
}
