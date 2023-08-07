import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sfa_tools/controllers/laporan_controller.dart';
import 'package:sfa_tools/controllers/pembayaran_controller.dart';
import 'package:sfa_tools/controllers/penjualan_controller.dart';
import 'package:sfa_tools/models/cartmodel.dart';
import 'package:sfa_tools/models/paymentdata.dart';
import 'package:sfa_tools/models/productdata.dart';
import 'package:sfa_tools/models/reportpembayaranmodel.dart';
import 'package:sfa_tools/models/reportpenjualanmodel.dart';
import 'package:sfa_tools/models/tukarwarnamodel.dart';
import 'package:sfa_tools/screens/transaction/payment/dialogconfirm.dart';
import 'package:sfa_tools/screens/transaction/returitem/bottomsheettukarwarna.dart';
import 'package:sfa_tools/screens/transaction/returitem/dialogcheckoutgb.dart';
import 'package:sfa_tools/screens/transaction/returitem/dialogcheckoutsm.dart';
import 'package:sfa_tools/screens/transaction/returitem/dialogcheckouttb.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/dialogcheckout.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/dialogdelete.dart';
import '../common/app_config.dart';
import '../models/tarikbarangmodel.dart';

class TakingOrderVendorController extends GetxController
    with GetTickerProviderStateMixin {
  final PembayaranController _pembayaranController =
      Get.put(PembayaranController());
  final LaporanController _laporanController = Get.put(LaporanController());
  final PenjualanController _penjualanController =
      Get.put(PenjualanController());

  @override
  void onInit() {
    super.onInit();
    _pembayaranController.controller =
        TabController(vsync: this, length: 4, initialIndex: 0);
    // cnt = SingleValueDropDownController();
    _penjualanController.getListItem();
    _laporanController.getReportList();
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

  handleSaveConfirm(String msg, String title) {
    Get.dialog(Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogConfirm(message: msg, title: title)));
  }

  // for penjualan page
  RxList<ProductData> get listProduct => _penjualanController.listProduct;
  RxList<CartDetail> get cartDetailList => _penjualanController.cartDetailList;
  RxList<CartModel> get cartList => _penjualanController.cartList;
  RxString get selectedValue => _penjualanController.selectedValue;
  RxList<ProductData> get selectedProduct =>
      _penjualanController.selectedProduct;
  Rx<TextEditingController> get cnt => _penjualanController.cnt;
  Rx<TextEditingController> get qty1 => _penjualanController.qty1;
  Rx<TextEditingController> get qty2 => _penjualanController.qty2;
  Rx<TextEditingController> get qty3 => _penjualanController.qty3;
  RxString get choosedAddress => _penjualanController.choosedAddress;

  countPriceTotal() {
    return _penjualanController.countPriceTotal();
  }

  String formatNumber(int number) {
    return _penjualanController.formatNumber(number);
  }

  previewCheckOut() {
    _penjualanController.previewCheckOut();
  }

  addToCart() {
    _penjualanController.addToCart();
  }

  updateCart() {
    _penjualanController.updateCart();
  }

  handleProductSearchButton(String val) async {
    await _penjualanController.handleProductSearchButton(val);
  }

  countTotalDetail(CartDetail data) {
    return _penjualanController.countTotalDetail(data);
  }

  handleEditItem(CartDetail data) {
    _penjualanController.handleEditItem(data);
  }

  handleDeleteItem(CartDetail data) {
    _penjualanController.handleDeleteItem(data);
  }

  //for laporan page
  RxString get choosedReport => _laporanController.choosedReport;
  RxList<ReportPembayaranModel> get listReportPembayaranshow =>
      _laporanController.listReportPembayaranshow;
  RxList<ReportPenjualanModel> get listReportPenjualanShow =>
      _laporanController.listReportPenjualanShow;
  RxInt get allReportlength => _laporanController.allReportlength;

  filteReport() {
    _laporanController.filteReport();
  }

  //for payment page
  Rx<TextEditingController> get nomorcek => _pembayaranController.nomorcek;
  Rx<TextEditingController> get nominalcek => _pembayaranController.nominalcek;
  Rx<TextEditingController> get nmbank => _pembayaranController.nmbank;
  Rx<TextEditingController> get jatuhtempotgl =>
      _pembayaranController.jatuhtempotgl;
  RxList<PaymentData> get listpaymentdata =>
      _pembayaranController.listpaymentdata;
  TabController get controller => _pembayaranController.controller;
  Rx<TextEditingController> get nominalCn => _pembayaranController.nominalCn;
  Rx<TextEditingController> get nominaltransfer =>
      _pembayaranController.nominaltransfer;
  RxString get choosedTransferMethod =>
      _pembayaranController.choosedTransferMethod;
  RxString get choosedTunaiMethod => _pembayaranController.choosedTunaiMethod;
  Rx<TextEditingController> get nominaltunai =>
      _pembayaranController.nominaltunai;

  formatMoneyTextField(TextEditingController ctrl) {
    _pembayaranController.formatMoneyTextField(ctrl);
  }

  selectDate(BuildContext context) {
    _pembayaranController.selectDate(context);
  }

  insertRecord(String type) {
    _pembayaranController.insertRecord(type);
  }

  handleeditpayment(String jenis) {
    _pembayaranController.handleeditpayment(jenis);
  }

  handleDeleteItemPayment(String metode, String jenis) {
    _pembayaranController.handleDeleteItemPayment(metode, jenis);
  }

  //for retur page
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
  Rx<TextEditingController> qty1tb = TextEditingController().obs;
  Rx<TextEditingController> qty2tb = TextEditingController().obs;
  Rx<TextEditingController> qty3tb = TextEditingController().obs;
  Rx<TextEditingController> qty1gk = TextEditingController().obs;
  Rx<TextEditingController> qty2gk = TextEditingController().obs;
  Rx<TextEditingController> qty3gk = TextEditingController().obs;
  Rx<TextEditingController> qty1sm = TextEditingController().obs;
  Rx<TextEditingController> qty2sm = TextEditingController().obs;
  Rx<TextEditingController> qty3sm = TextEditingController().obs;
  Rx<TextEditingController> qty1gb = TextEditingController().obs;
  Rx<TextEditingController> qty2gb = TextEditingController().obs;
  Rx<TextEditingController> qty3gb = TextEditingController().obs;
  Rx<TextEditingController> qty1tw = TextEditingController().obs;
  Rx<TextEditingController> qty2tw = TextEditingController().obs;
  Rx<TextEditingController> qty3tw = TextEditingController().obs;
  Rx<TextEditingController> qty1pp = TextEditingController().obs;
  Rx<TextEditingController> qty2pp = TextEditingController().obs;
  Rx<TextEditingController> qty3pp = TextEditingController().obs;
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
  RxList<TarikBarangModel> listitemforProdukPengganti =
      <TarikBarangModel>[].obs;
  //
  RxBool isOverfow = false.obs;
  //
  RxList listSisa = [].obs;

  handleProductSearchTb(String val) async {
    selectedKdProducttarikbarang.value = val;
    selectedAlasantb.value = "";
    qty1tb.value.text = "0";
    qty2tb.value.text = "0";
    qty3tb.value.text = "0";
    if (listTarikBarang.isNotEmpty &&
        listTarikBarang.any((data) => data.kdProduct == val)) {
      for (var i = 0; i < listTarikBarang.length; i++) {
        if (val == listTarikBarang[i].kdProduct) {
          handleEditTarikBarangItem(listTarikBarang[i]);
        }
      }
    } else {
      await getDetailProductTb(val);
    }
  }

  handleProductSearchGk(String val) async {
    selectedKdProductgantikemasan.value = val;
    selectedAlasangk.value = "";
    qty1gk.value.text = "0";
    qty2gk.value.text = "0";
    qty3gk.value.text = "0";
    if (listgantikemasan.isNotEmpty &&
        listgantikemasan.any((data) => data.kdProduct == val)) {
      for (var i = 0; i < listgantikemasan.length; i++) {
        if (val == listgantikemasan[i].kdProduct) {
          handleEditGantiKemasanItem(listgantikemasan[i]);
        }
      }
    } else {
      await getDetailProductGk(val);
    }
  }

  handleProductSearchSm(String val) async {
    selectedKdProductservismebel.value = val;
    qty1sm.value.text = "0";
    qty2sm.value.text = "0";
    qty3sm.value.text = "0";
    if (listServisMebel.isNotEmpty &&
        listServisMebel.any((data) => data.kdProduct == val)) {
      for (var i = 0; i < listServisMebel.length; i++) {
        if (val == listServisMebel[i].kdProduct) {
          handleEditServisMebelItem(listServisMebel[i]);
        }
      }
    } else {
      await getDetailProductSm(val);
    }
  }

  handleProductSearchGb(String val) async {
    selectedKdProductgantibarang.value = val;
    qty1gb.value.text = "0";
    qty2gb.value.text = "0";
    qty3gb.value.text = "0";
    if (listGantiBarang.isNotEmpty &&
        listGantiBarang.any((data) => data.kdProduct == val)) {
      for (var i = 0; i < listGantiBarang.length; i++) {
        if (val == listGantiBarang[i].kdProduct) {
          handleEditGantiBarangItem(listGantiBarang[i]);
        }
      }
    } else {
      await getDetailProductGb(val);
    }
  }

  handleProductSearchTw(String val) async {
    selectedKdProductTukarWarna.value = val;
    qty1tw.value.text = "0";
    qty2tw.value.text = "0";
    qty3tw.value.text = "0";
    if (listTukarWarna.isNotEmpty &&
        listTukarWarna.any((data) => data.kdProduct == val)) {
      for (var i = 0; i < listTukarWarna.length; i++) {
        if (val == listTukarWarna[i].kdProduct) {
          handleEditTukarWarnaItem(listTukarWarna[i]);
        }
      }
    } else {
      await getDetailProductTw(val);
    }
  }

  handleProductSearchPp(String val) async {
    isOverfow.value = false;
    selectedKdProductProdukPengganti.value = val;
    qty1pp.value.text = "0";
    qty2pp.value.text = "0";
    qty3pp.value.text = "0";
    if (listProdukPengganti.isNotEmpty &&
        listProdukPengganti.any((data) => data.kdProduct == val)) {
      for (var i = 0; i < listProdukPengganti.length; i++) {
        if (val == listProdukPengganti[i].kdProduct) {
          handleEditProdukPenggantiItem(listProdukPengganti[i]);
        }
      }
    } else {
      await getDetailProductPp(val);
    }
  }

  getDetailProductGk(String kdProduct) {
    List<ProductData> list = <ProductData>[];
    for (var i = 0; i < _penjualanController.listProduct.length; i++) {
      if (_penjualanController.listProduct[i].kdProduct == kdProduct) {
        list.add(_penjualanController.listProduct[i]);
        selectedProductgantikemasan.value = list;
      }
    }
  }

  getDetailProductTb(String kdProduct) {
    List<ProductData> list = <ProductData>[];
    for (var i = 0; i < _penjualanController.listProduct.length; i++) {
      if (_penjualanController.listProduct[i].kdProduct == kdProduct) {
        list.add(_penjualanController.listProduct[i]);
        selectedProducttarikbarang.value = list;
      }
    }
  }

  getDetailProductSm(String kdProduct) {
    List<ProductData> list = <ProductData>[];
    for (var i = 0; i < _penjualanController.listProduct.length; i++) {
      if (_penjualanController.listProduct[i].kdProduct == kdProduct) {
        list.add(_penjualanController.listProduct[i]);
        selectedProductservismebel.value = list;
      }
    }
  }

  getDetailProductGb(String kdProduct) {
    List<ProductData> list = <ProductData>[];
    for (var i = 0; i < _penjualanController.listProduct.length; i++) {
      if (_penjualanController.listProduct[i].kdProduct == kdProduct) {
        list.add(_penjualanController.listProduct[i]);
        selectedProductgantibarang.value = list;
      }
    }
  }

  getDetailProductTw(String kdProduct) {
    List<ProductData> list = <ProductData>[];
    for (var i = 0; i < _penjualanController.listProduct.length; i++) {
      if (_penjualanController.listProduct[i].kdProduct == kdProduct) {
        list.add(_penjualanController.listProduct[i]);
        selectedProductTukarWarna.value = list;
      }
    }
  }

  getDetailProductPp(String kdProduct) {
    List<ProductData> list = <ProductData>[];
    for (var i = 0; i < _penjualanController.listProduct.length; i++) {
      if (_penjualanController.listProduct[i].kdProduct == kdProduct) {
        list.add(_penjualanController.listProduct[i]);
        selectedProductProdukPengganti.value = list;
      }
    }
  }

  handleEditTarikBarangItem(TarikBarangModel data) {
    selectedKdProducttarikbarang.value = data.kdProduct.toString();
    qty1tb.value.text = '0';
    qty2tb.value.text = '0';
    qty3tb.value.text = '0';
    selectedAlasantb.value = data.alasan;
    for (var k = 0; k < _penjualanController.listProduct.length; k++) {
      if (_penjualanController.listProduct[k].kdProduct == data.kdProduct) {
        for (var i = 0; i < data.itemOrder.length; i++) {
          for (var j = 0;
              j < _penjualanController.listProduct[k].detailProduct.length;
              j++) {
            if (j == 0 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty1tb.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 1 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty2tb.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 2 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty3tb.value.text = data.itemOrder[i].Qty.toString();
            }
          }
        }
      }
    }

    getDetailProductTb(data.kdProduct);
  }

  handleEditGantiKemasanItem(TarikBarangModel data) {
    selectedKdProductgantikemasan.value = data.kdProduct.toString();
    qty1gk.value.text = '0';
    qty2gk.value.text = '0';
    qty3gk.value.text = '0';
    selectedAlasangk.value = data.alasan;
    for (var k = 0; k < _penjualanController.listProduct.length; k++) {
      if (_penjualanController.listProduct[k].kdProduct == data.kdProduct) {
        for (var i = 0; i < data.itemOrder.length; i++) {
          for (var j = 0;
              j < _penjualanController.listProduct[k].detailProduct.length;
              j++) {
            if (j == 0 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty1gk.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 1 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty2gk.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 2 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty3gk.value.text = data.itemOrder[i].Qty.toString();
            }
          }
        }
      }
    }

    getDetailProductGk(data.kdProduct);
  }

  handleEditServisMebelItem(TarikBarangModel data) {
    selectedKdProductservismebel.value = data.kdProduct.toString();
    qty1sm.value.text = '0';
    qty2sm.value.text = '0';
    qty3sm.value.text = '0';
    for (var k = 0; k < _penjualanController.listProduct.length; k++) {
      if (_penjualanController.listProduct[k].kdProduct == data.kdProduct) {
        for (var i = 0; i < data.itemOrder.length; i++) {
          for (var j = 0;
              j < _penjualanController.listProduct[k].detailProduct.length;
              j++) {
            if (j == 0 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty1sm.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 1 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty2sm.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 2 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty3sm.value.text = data.itemOrder[i].Qty.toString();
            }
          }
        }
      }
    }

    getDetailProductSm(data.kdProduct);
  }

  handleEditGantiBarangItem(TarikBarangModel data) {
    selectedKdProductgantibarang.value = data.kdProduct.toString();
    qty1gb.value.text = '0';
    qty2gb.value.text = '0';
    qty3gb.value.text = '0';
    for (var k = 0; k < _penjualanController.listProduct.length; k++) {
      if (_penjualanController.listProduct[k].kdProduct == data.kdProduct) {
        for (var i = 0; i < data.itemOrder.length; i++) {
          for (var j = 0;
              j < _penjualanController.listProduct[k].detailProduct.length;
              j++) {
            if (j == 0 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty1gb.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 1 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty2gb.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 2 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty3gb.value.text = data.itemOrder[i].Qty.toString();
            }
          }
        }
      }
    }

    getDetailProductGb(data.kdProduct);
  }

  handleEditTukarWarnaItem(TukarWarnaModel data) {
    selectedKdProductTukarWarna.value = data.kdProduct.toString();
    qty1tw.value.text = '0';
    qty2tw.value.text = '0';
    qty3tw.value.text = '0';
    for (var k = 0; k < _penjualanController.listProduct.length; k++) {
      if (_penjualanController.listProduct[k].kdProduct == data.kdProduct) {
        // listitemforProdukPengganti.clear();
        // listitemforProdukPengganti.add(TarikBarangModel(
        //     data.kdProduct, data.nmProduct, data.listqtyheader, ""));
        // listProdukPengganti.clear();
        // listProdukPengganti.add(TarikBarangModel(kdProduct, nmProduct, itemOrder, alasan))
        for (var i = 0; i < data.listqtyheader.length; i++) {
          for (var j = 0;
              j < _penjualanController.listProduct[k].detailProduct.length;
              j++) {
            if (j == 0 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.listqtyheader[i].Satuan) {
              qty1tw.value.text = data.listqtyheader[i].Qty.toString();
            } else if (j == 1 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.listqtyheader[i].Satuan) {
              qty2tw.value.text = data.listqtyheader[i].Qty.toString();
            } else if (j == 2 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.listqtyheader[i].Satuan) {
              qty3tw.value.text = data.listqtyheader[i].Qty.toString();
            }
          }
        }
      }
    }

    getDetailProductTw(data.kdProduct);
  }

  handleEditProdukPenggantiItem(TarikBarangModel data) {
    isOverfow.value = false;
    selectedKdProductProdukPengganti.value = data.kdProduct.toString();
    qty1pp.value.text = '0';
    qty2pp.value.text = '0';
    qty3pp.value.text = '0';
    for (var k = 0; k < _penjualanController.listProduct.length; k++) {
      if (_penjualanController.listProduct[k].kdProduct == data.kdProduct) {
        for (var i = 0; i < data.itemOrder.length; i++) {
          for (var j = 0;
              j < _penjualanController.listProduct[k].detailProduct.length;
              j++) {
            if (j == 0 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty1pp.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 1 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty2pp.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 2 &&
                _penjualanController.listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty3pp.value.text = data.itemOrder[i].Qty.toString();
            }
          }
        }
      }
    }

    getDetailProductPp(data.kdProduct);
  }

  addToCartTb() {
    if (selectedAlasantb.value == "" ||
        selectedAlasantb.value == "Pilih Alasan Retur") {
      Get.snackbar("Error", "pilih alasan terlebih dahulu !",
          backgroundColor: Colors.red.withOpacity(0.5));
      return;
    }
    var flag = "null";
    for (var i = 0; i < listTarikBarang.length; i++) {
      print(listTarikBarang[i].kdProduct);
      if (selectedProducttarikbarang[0].kdProduct ==
          listTarikBarang[i].kdProduct) {
        print("same");
        flag = i.toString();
        break;
      }
    }
    print("ini isi flag ${flag}");
    if (flag == "null") {
      List<CartModel> _items = <CartModel>[];
      for (var i = 0;
          i < selectedProducttarikbarang[0].detailProduct.length;
          i++) {
        if (i == 0 &&
            qty1tb.value.text != "" &&
            int.parse(qty1tb.value.text) != 0) {
          _items.add(CartModel(
              selectedProducttarikbarang[0].kdProduct,
              selectedProducttarikbarang[0].nmProduct,
              int.parse(qty1tb.value.text),
              selectedProducttarikbarang[0].detailProduct[i].satuan,
              0));
        } else if (i == 1 &&
            qty2tb.value.text != "" &&
            int.parse(qty2tb.value.text) != 0) {
          _items.add(CartModel(
              selectedProducttarikbarang[0].kdProduct,
              selectedProducttarikbarang[0].nmProduct,
              int.parse(qty2tb.value.text),
              selectedProducttarikbarang[0].detailProduct[i].satuan,
              0));
        } else if (i == 2 &&
            qty3tb.value.text != "" &&
            int.parse(qty3tb.value.text) != 0) {
          _items.add(CartModel(
              selectedProducttarikbarang[0].kdProduct,
              selectedProducttarikbarang[0].nmProduct,
              int.parse(qty3tb.value.text),
              selectedProducttarikbarang[0].detailProduct[i].satuan,
              0));
        }
      }
      if (!_items.isEmpty) {
        listTarikBarang.add(TarikBarangModel(
            selectedProducttarikbarang[0].kdProduct,
            selectedProducttarikbarang[0].nmProduct,
            _items,
            selectedAlasantb.value));
      }

      selectedKdProducttarikbarang.value = "";
      selectedAlasantb.value = "";
      selectedProducttarikbarang.clear();
      tarikbarangfield.value.clear();
      qty1tb.value.clear();
      qty2tb.value.clear();
      qty3tb.value.clear();
    } else {
      print("already added");
      List<CartModel> _items = <CartModel>[];
      for (var i = 0;
          i < selectedProducttarikbarang[0].detailProduct.length;
          i++) {
        if (i == 0 &&
            qty1tb.value.text != "" &&
            int.parse(qty1tb.value.text) != 0) {
          _items.add(CartModel(
              selectedProducttarikbarang[0].kdProduct,
              selectedProducttarikbarang[0].nmProduct,
              int.parse(qty1tb.value.text),
              selectedProducttarikbarang[0].detailProduct[i].satuan,
              0));
        } else if (i == 1 &&
            qty2tb.value.text != "" &&
            int.parse(qty2tb.value.text) != 0) {
          _items.add(CartModel(
              selectedProducttarikbarang[0].kdProduct,
              selectedProducttarikbarang[0].nmProduct,
              int.parse(qty2tb.value.text),
              selectedProducttarikbarang[0].detailProduct[i].satuan,
              0));
        } else if (i == 2 &&
            qty3tb.value.text != "" &&
            int.parse(qty3tb.value.text) != 0) {
          _items.add(CartModel(
              selectedProducttarikbarang[0].kdProduct,
              selectedProducttarikbarang[0].nmProduct,
              int.parse(qty3tb.value.text),
              selectedProducttarikbarang[0].detailProduct[i].satuan,
              0));
        }
      }
      if (_items.isNotEmpty) {
        listTarikBarang[int.parse(flag)].kdProduct =
            selectedProducttarikbarang[0].kdProduct;
        listTarikBarang[int.parse(flag)].nmProduct =
            selectedProducttarikbarang[0].nmProduct;
        listTarikBarang[int.parse(flag)].itemOrder = _items;
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
      qty1tb.value.clear();
      qty2tb.value.clear();
      qty3tb.value.clear();
    }
    if (listTarikBarang.isEmpty && selectedProducttarikbarang.isEmpty) {
      tarikbaranghorizontal.value = false;
    } else if (listTarikBarang.isEmpty &&
        selectedProducttarikbarang.isNotEmpty) {
      tarikbaranghorizontal.value = true;
    }
  }

  addToCartGk() {
    if (selectedAlasangk.value == "" ||
        selectedAlasangk.value == "Pilih Alasan Retur") {
      Get.snackbar("Error", "pilih alasan terlebih dahulu !",
          backgroundColor: Colors.red.withOpacity(0.5));
      return;
    }
    var flag = "null";
    for (var i = 0; i < listgantikemasan.length; i++) {
      print(listgantikemasan[i].kdProduct);
      if (selectedProductgantikemasan[0].kdProduct ==
          listgantikemasan[i].kdProduct) {
        print("same");
        flag = i.toString();
        break;
      }
    }
    print("ini isi flag ${flag}");
    if (flag == "null") {
      List<CartModel> _items = <CartModel>[];
      for (var i = 0;
          i < selectedProductgantikemasan[0].detailProduct.length;
          i++) {
        if (i == 0 &&
            qty1gk.value.text != "" &&
            int.parse(qty1gk.value.text) != 0) {
          _items.add(CartModel(
              selectedProductgantikemasan[0].kdProduct,
              selectedProductgantikemasan[0].nmProduct,
              int.parse(qty1gk.value.text),
              selectedProductgantikemasan[0].detailProduct[i].satuan,
              0));
        } else if (i == 1 &&
            qty2gk.value.text != "" &&
            int.parse(qty2gk.value.text) != 0) {
          _items.add(CartModel(
              selectedProductgantikemasan[0].kdProduct,
              selectedProductgantikemasan[0].nmProduct,
              int.parse(qty2gk.value.text),
              selectedProductgantikemasan[0].detailProduct[i].satuan,
              0));
        } else if (i == 2 &&
            qty3gk.value.text != "" &&
            int.parse(qty3gk.value.text) != 0) {
          _items.add(CartModel(
              selectedProductgantikemasan[0].kdProduct,
              selectedProductgantikemasan[0].nmProduct,
              int.parse(qty3gk.value.text),
              selectedProductgantikemasan[0].detailProduct[i].satuan,
              0));
        }
      }
      if (!_items.isEmpty) {
        listgantikemasan.add(TarikBarangModel(
            selectedProductgantikemasan[0].kdProduct,
            selectedProductgantikemasan[0].nmProduct,
            _items,
            selectedAlasangk.value));
      }

      selectedKdProductgantikemasan.value = "";
      selectedAlasangk.value = "";
      selectedProductgantikemasan.clear();
      gantikemasanfield.value.clear();
      qty1gk.value.clear();
      qty2gk.value.clear();
      qty3gk.value.clear();
    } else {
      print("already added");
      List<CartModel> _items = <CartModel>[];
      for (var i = 0;
          i < selectedProductgantikemasan[0].detailProduct.length;
          i++) {
        if (i == 0 &&
            qty1gk.value.text != "" &&
            int.parse(qty1gk.value.text) != 0) {
          _items.add(CartModel(
              selectedProductgantikemasan[0].kdProduct,
              selectedProductgantikemasan[0].nmProduct,
              int.parse(qty1gk.value.text),
              selectedProductgantikemasan[0].detailProduct[i].satuan,
              0));
        } else if (i == 1 &&
            qty2gk.value.text != "" &&
            int.parse(qty2gk.value.text) != 0) {
          _items.add(CartModel(
              selectedProductgantikemasan[0].kdProduct,
              selectedProductgantikemasan[0].nmProduct,
              int.parse(qty2gk.value.text),
              selectedProductgantikemasan[0].detailProduct[i].satuan,
              0));
        } else if (i == 2 &&
            qty3gk.value.text != "" &&
            int.parse(qty3gk.value.text) != 0) {
          _items.add(CartModel(
              selectedProductgantikemasan[0].kdProduct,
              selectedProductgantikemasan[0].nmProduct,
              int.parse(qty3gk.value.text),
              selectedProductgantikemasan[0].detailProduct[i].satuan,
              0));
        }
      }
      if (_items.isNotEmpty) {
        listgantikemasan[int.parse(flag)].kdProduct =
            selectedProductgantikemasan[0].kdProduct;
        listgantikemasan[int.parse(flag)].nmProduct =
            selectedProductgantikemasan[0].nmProduct;
        listgantikemasan[int.parse(flag)].itemOrder = _items;
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
      qty1gk.value.clear();
      qty2gk.value.clear();
      qty3gk.value.clear();
    }
    if (listgantikemasan.isEmpty && selectedProductgantikemasan.isEmpty) {
      gantikemasanhorizontal.value = false;
    } else if (listgantikemasan.isEmpty &&
        selectedProductgantikemasan.isNotEmpty) {
      gantikemasanhorizontal.value = true;
    }
  }

  addToCartSm() {
    var flag = "null";
    for (var i = 0; i < listServisMebel.length; i++) {
      if (selectedProductservismebel[0].kdProduct ==
          listServisMebel[i].kdProduct) {
        flag = i.toString();
        break;
      }
    }
    if (flag == "null") {
      List<CartModel> _items = <CartModel>[];
      for (var i = 0;
          i < selectedProductservismebel[0].detailProduct.length;
          i++) {
        if (i == 0 &&
            qty1sm.value.text != "" &&
            int.parse(qty1sm.value.text) != 0) {
          _items.add(CartModel(
              selectedProductservismebel[0].kdProduct,
              selectedProductservismebel[0].nmProduct,
              int.parse(qty1sm.value.text),
              selectedProductservismebel[0].detailProduct[i].satuan,
              0));
        } else if (i == 1 &&
            qty2sm.value.text != "" &&
            int.parse(qty2sm.value.text) != 0) {
          _items.add(CartModel(
              selectedProductservismebel[0].kdProduct,
              selectedProductservismebel[0].nmProduct,
              int.parse(qty2sm.value.text),
              selectedProductservismebel[0].detailProduct[i].satuan,
              0));
        } else if (i == 2 &&
            qty3sm.value.text != "" &&
            int.parse(qty3sm.value.text) != 0) {
          _items.add(CartModel(
              selectedProductservismebel[0].kdProduct,
              selectedProductservismebel[0].nmProduct,
              int.parse(qty3sm.value.text),
              selectedProductservismebel[0].detailProduct[i].satuan,
              0));
        }
      }
      if (!_items.isEmpty) {
        listServisMebel.add(TarikBarangModel(
            selectedProductservismebel[0].kdProduct,
            selectedProductservismebel[0].nmProduct,
            _items,
            ""));
      }

      selectedKdProductservismebel.value = "";
      selectedProductservismebel.clear();
      servismebelfield.value.clear();
      qty1sm.value.clear();
      qty2sm.value.clear();
      qty3sm.value.clear();
    } else {
      List<CartModel> _items = <CartModel>[];
      for (var i = 0;
          i < selectedProductservismebel[0].detailProduct.length;
          i++) {
        if (i == 0 &&
            qty1sm.value.text != "" &&
            int.parse(qty1sm.value.text) != 0) {
          _items.add(CartModel(
              selectedProductservismebel[0].kdProduct,
              selectedProductservismebel[0].nmProduct,
              int.parse(qty1sm.value.text),
              selectedProductservismebel[0].detailProduct[i].satuan,
              0));
        } else if (i == 1 &&
            qty2sm.value.text != "" &&
            int.parse(qty2sm.value.text) != 0) {
          _items.add(CartModel(
              selectedProductservismebel[0].kdProduct,
              selectedProductservismebel[0].nmProduct,
              int.parse(qty2sm.value.text),
              selectedProductservismebel[0].detailProduct[i].satuan,
              0));
        } else if (i == 2 &&
            qty3sm.value.text != "" &&
            int.parse(qty3sm.value.text) != 0) {
          _items.add(CartModel(
              selectedProductservismebel[0].kdProduct,
              selectedProductservismebel[0].nmProduct,
              int.parse(qty3sm.value.text),
              selectedProductservismebel[0].detailProduct[i].satuan,
              0));
        }
      }
      if (_items.isNotEmpty) {
        listServisMebel[int.parse(flag)].kdProduct =
            selectedProductservismebel[0].kdProduct;
        listServisMebel[int.parse(flag)].nmProduct =
            selectedProductservismebel[0].nmProduct;
        listServisMebel[int.parse(flag)].itemOrder = _items;
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
      qty1sm.value.clear();
      qty2sm.value.clear();
      qty3sm.value.clear();
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
      if (selectedProductgantibarang[0].kdProduct ==
          listGantiBarang[i].kdProduct) {
        flag = i.toString();
        break;
      }
    }
    if (flag == "null") {
      List<CartModel> _items = <CartModel>[];
      for (var i = 0;
          i < selectedProductgantibarang[0].detailProduct.length;
          i++) {
        if (i == 0 &&
            qty1gb.value.text != "" &&
            int.parse(qty1gb.value.text) != 0) {
          _items.add(CartModel(
              selectedProductgantibarang[0].kdProduct,
              selectedProductgantibarang[0].nmProduct,
              int.parse(qty1gb.value.text),
              selectedProductgantibarang[0].detailProduct[i].satuan,
              0));
        } else if (i == 1 &&
            qty2gb.value.text != "" &&
            int.parse(qty2gb.value.text) != 0) {
          _items.add(CartModel(
              selectedProductgantibarang[0].kdProduct,
              selectedProductgantibarang[0].nmProduct,
              int.parse(qty2gb.value.text),
              selectedProductgantibarang[0].detailProduct[i].satuan,
              0));
        } else if (i == 2 &&
            qty3gb.value.text != "" &&
            int.parse(qty3gb.value.text) != 0) {
          _items.add(CartModel(
              selectedProductgantibarang[0].kdProduct,
              selectedProductgantibarang[0].nmProduct,
              int.parse(qty3gb.value.text),
              selectedProductgantibarang[0].detailProduct[i].satuan,
              0));
        }
      }
      if (!_items.isEmpty) {
        listGantiBarang.add(TarikBarangModel(
            selectedProductgantibarang[0].kdProduct,
            selectedProductgantibarang[0].nmProduct,
            _items,
            ""));
      }

      selectedKdProductgantibarang.value = "";
      selectedProductgantibarang.clear();
      gantibarangfield.value.clear();
      qty1gb.value.clear();
      qty2gb.value.clear();
      qty3gb.value.clear();
    } else {
      List<CartModel> _items = <CartModel>[];
      for (var i = 0;
          i < selectedProductgantibarang[0].detailProduct.length;
          i++) {
        if (i == 0 &&
            qty1gb.value.text != "" &&
            int.parse(qty1gb.value.text) != 0) {
          _items.add(CartModel(
              selectedProductgantibarang[0].kdProduct,
              selectedProductgantibarang[0].nmProduct,
              int.parse(qty1gb.value.text),
              selectedProductgantibarang[0].detailProduct[i].satuan,
              0));
        } else if (i == 1 &&
            qty2gb.value.text != "" &&
            int.parse(qty2gb.value.text) != 0) {
          _items.add(CartModel(
              selectedProductgantibarang[0].kdProduct,
              selectedProductgantibarang[0].nmProduct,
              int.parse(qty2gb.value.text),
              selectedProductgantibarang[0].detailProduct[i].satuan,
              0));
        } else if (i == 2 &&
            qty3gb.value.text != "" &&
            int.parse(qty3gb.value.text) != 0) {
          _items.add(CartModel(
              selectedProductgantibarang[0].kdProduct,
              selectedProductgantibarang[0].nmProduct,
              int.parse(qty3gb.value.text),
              selectedProductgantibarang[0].detailProduct[i].satuan,
              0));
        }
      }
      if (_items.isNotEmpty) {
        listGantiBarang[int.parse(flag)].kdProduct =
            selectedProductgantibarang[0].kdProduct;
        listGantiBarang[int.parse(flag)].nmProduct =
            selectedProductgantibarang[0].nmProduct;
        listGantiBarang[int.parse(flag)].itemOrder = _items;
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
      qty1gb.value.clear();
      qty2gb.value.clear();
      qty3gb.value.clear();
    }
    if (listGantiBarang.isEmpty && selectedProductgantibarang.isEmpty) {
      gantibaranghorizontal.value = false;
    } else if (listGantiBarang.isEmpty &&
        selectedProductgantibarang.isNotEmpty) {
      gantibaranghorizontal.value = true;
    }
  }

  addToCartPp() {
    var itemtotal = countTotalpengganti();
    List<CartModel> _list = <CartModel>[];
    for (var i = 0;
        i < selectedProductProdukPengganti[0].detailProduct.length;
        i++) {
      if (i == 0 &&
          qty1pp.value.text != "" &&
          int.parse(qty1pp.value.text) > 0) {
        _list.add(CartModel(
            selectedProductProdukPengganti[0].kdProduct,
            selectedProductProdukPengganti[0].nmProduct,
            int.parse(qty1pp.value.text),
            selectedProductProdukPengganti[0].detailProduct[i].satuan,
            selectedProductProdukPengganti[0].detailProduct[i].hrg));
      } else if (i == 1 &&
          qty2pp.value.text != "" &&
          int.parse(qty2pp.value.text) > 0) {
        _list.add(CartModel(
            selectedProductProdukPengganti[0].kdProduct,
            selectedProductProdukPengganti[0].nmProduct,
            int.parse(qty2pp.value.text),
            selectedProductProdukPengganti[0].detailProduct[i].satuan,
            selectedProductProdukPengganti[0].detailProduct[i].hrg));
      } else if (i == 2 &&
          qty3pp.value.text != "" &&
          int.parse(qty3pp.value.text) > 0) {
        _list.add(CartModel(
            selectedProductProdukPengganti[0].kdProduct,
            selectedProductProdukPengganti[0].nmProduct,
            int.parse(qty3pp.value.text),
            selectedProductProdukPengganti[0].detailProduct[i].satuan,
            selectedProductProdukPengganti[0].detailProduct[i].hrg));
      }
    }
    print("awal ${itemtotal}");
    for (var i = 0; i < _list.length; i++) {
      if ("dos" == _list[i].Satuan) {
        itemtotal = itemtotal - (_list[i].Qty * 8);
      } else if ("biji" == _list[i].Satuan) {
        itemtotal = itemtotal - _list[i].Qty;
      } else if ("kaleng" == _list[i].Satuan) {
        itemtotal = itemtotal - _list[i].Qty;
      } else if ("inner plas" == _list[i].Satuan) {
        itemtotal = itemtotal - (_list[i].Qty * 4);
      }
    }
    for (var i = 0; i < listProdukPengganti.length; i++) {
      if (listProdukPengganti[i].kdProduct !=
          selectedProductProdukPengganti[0].kdProduct) {
        for (var j = 0; j < listProdukPengganti[i].itemOrder.length; j++) {
          if ("dos" == listProdukPengganti[i].itemOrder[j].Satuan) {
            itemtotal =
                itemtotal - (listProdukPengganti[i].itemOrder[j].Qty * 8);
          } else if ("biji" == listProdukPengganti[i].itemOrder[j].Satuan) {
            itemtotal = itemtotal - listProdukPengganti[i].itemOrder[j].Qty;
          } else if ("kaleng" == listProdukPengganti[i].itemOrder[j].Satuan) {
            itemtotal = itemtotal - listProdukPengganti[i].itemOrder[j].Qty;
          } else if ("inner plas" ==
              listProdukPengganti[i].itemOrder[j].Satuan) {
            itemtotal =
                itemtotal - (listProdukPengganti[i].itemOrder[j].Qty * 4);
          }
        }
      }
    }
    print("after minus by all item ${itemtotal}");
    if (itemtotal < 0) {
      isOverfow.value = true;
      print("overflow");
      return;
    }

    if (listProdukPengganti.isNotEmpty &&
        listProdukPengganti.any((data) =>
            data.kdProduct == selectedProductProdukPengganti[0].kdProduct)) {
      for (var i = 0; i < listProdukPengganti.length; i++) {
        if (listProdukPengganti[i].kdProduct ==
            selectedProductProdukPengganti[0].kdProduct) {
          listProdukPengganti[i].itemOrder.clear();
          print(_list.length.toString() + " list length");
          if (_list.isNotEmpty) {
            listProdukPengganti[i].itemOrder.addAll(_list);
          } else {
            listProdukPengganti.removeAt(i);
          }
          break;
        }
      }
    } else {
      if (_list.isNotEmpty) {
        listProdukPengganti.add(TarikBarangModel(
            selectedProductProdukPengganti[0].kdProduct,
            selectedProductProdukPengganti[0].nmProduct,
            _list,
            ""));
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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
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
    listTarikBarang
        .removeWhere((element) => element.kdProduct == data.kdProduct);
    if (listTarikBarang.isEmpty && selectedProducttarikbarang.isEmpty) {
      tarikbaranghorizontal.value = false;
    } else if (listTarikBarang.isEmpty &&
        selectedProducttarikbarang.isNotEmpty) {
      tarikbaranghorizontal.value = true;
    }
  }

  deleteGantiKemasanItem(TarikBarangModel data) {
    listgantikemasan
        .removeWhere((element) => element.kdProduct == data.kdProduct);
    if (listgantikemasan.isEmpty && selectedProductgantikemasan.isEmpty) {
      gantikemasanhorizontal.value = false;
    } else if (listgantikemasan.isEmpty &&
        selectedProductgantikemasan.isNotEmpty) {
      gantikemasanhorizontal.value = true;
    }
  }

  deleteServisMebelItem(TarikBarangModel data) {
    listServisMebel
        .removeWhere((element) => element.kdProduct == data.kdProduct);
    if (listServisMebel.isEmpty && selectedProductservismebel.isEmpty) {
      servismebelhorizontal.value = false;
    } else if (listServisMebel.isEmpty &&
        selectedProductservismebel.isNotEmpty) {
      servismebelhorizontal.value = true;
    }
  }

  deleteGantiBarangItem(TarikBarangModel data) {
    listGantiBarang
        .removeWhere((element) => element.kdProduct == data.kdProduct);
    if (listGantiBarang.isEmpty && selectedProductgantibarang.isEmpty) {
      gantibaranghorizontal.value = false;
    } else if (listGantiBarang.isEmpty &&
        selectedProductgantibarang.isNotEmpty) {
      gantibaranghorizontal.value = true;
    }
  }

  deleteProdukPenggantiItem(TarikBarangModel data) {
    listProdukPengganti
        .removeWhere((element) => element.kdProduct == data.kdProduct);
    countSisaPengganti();
  }

  handleSaveGantiBarang() {
    Get.dialog(Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogCheckoutGb()));
  }

  handleSaveServisMebel() {
    Get.dialog(Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogCheckoutSm()));
  }

  handleSaveTarikBarang() {
    Get.dialog(Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogCheckOutTb()));
  }

  showProdukPengganti(BuildContext context) {
    selectedKdProductProdukPengganti.value = "";
    selectedProductProdukPengganti.clear();
    listProdukPengganti.clear();
    produkpenggantifield.value.clear();
    listitemforProdukPengganti.clear();
    List<CartModel> _list = <CartModel>[];
    for (var i = 0; i < _penjualanController.listProduct.length; i++) {
      if (_penjualanController.listProduct[i].kdProduct ==
          selectedProductTukarWarna[0].kdProduct) {
        for (var k = 0;
            k < _penjualanController.listProduct[i].detailProduct.length;
            k++) {
          if (k == 0 &&
              qty1tw.value.text != "" &&
              int.tryParse(qty1tw.value.text)! > 0) {
            _list.add(CartModel(
                _penjualanController.listProduct[i].kdProduct,
                _penjualanController.listProduct[i].nmProduct,
                int.tryParse(qty1tw.value.text)!,
                _penjualanController.listProduct[i].detailProduct[k].satuan,
                _penjualanController.listProduct[i].detailProduct[k].hrg));
          } else if (k == 1 &&
              qty2tw.value.text != "" &&
              int.tryParse(qty2tw.value.text)! > 0) {
            _list.add(CartModel(
                _penjualanController.listProduct[i].kdProduct,
                _penjualanController.listProduct[i].nmProduct,
                int.tryParse(qty2tw.value.text)!,
                _penjualanController.listProduct[i].detailProduct[k].satuan,
                _penjualanController.listProduct[i].detailProduct[k].hrg));
          } else if (k == 2 &&
              qty3tw.value.text != "" &&
              int.tryParse(qty3tw.value.text)! > 0) {
            _list.add(CartModel(
                _penjualanController.listProduct[i].kdProduct,
                _penjualanController.listProduct[i].nmProduct,
                int.tryParse(qty3tw.value.text)!,
                _penjualanController.listProduct[i].detailProduct[k].satuan,
                _penjualanController.listProduct[i].detailProduct[k].hrg));
          }
        }
        break;
      }
    }
    if (_list.isEmpty) {
      selectedProductTukarWarna.clear();
      selectedKdProductTukarWarna.value = "";
      tukarwarnafield.value.clear();
    } else {
      listitemforProdukPengganti.add(TarikBarangModel(
          selectedProductTukarWarna[0].kdProduct,
          selectedProductTukarWarna[0].nmProduct,
          _list,
          ""));
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        shape: RoundedRectangleBorder(
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

  countTotalpengganti() {
    var items = 0;
    for (var i = 0; i < listitemforProdukPengganti[0].itemOrder.length; i++) {
      if ("dos" == listitemforProdukPengganti[0].itemOrder[i].Satuan) {
        items = items + (listitemforProdukPengganti[0].itemOrder[i].Qty * 8);
      } else if ("biji" == listitemforProdukPengganti[0].itemOrder[i].Satuan) {
        items = items + listitemforProdukPengganti[0].itemOrder[i].Qty;
      } else if ("kaleng" ==
          listitemforProdukPengganti[0].itemOrder[i].Satuan) {
        items = items + listitemforProdukPengganti[0].itemOrder[i].Qty;
      } else if ("inner plas" ==
          listitemforProdukPengganti[0].itemOrder[i].Satuan) {
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
          listSisa.add("${qty} dos");
        } else if (itemtotal >= 4) {
          int qty = (itemtotal / 4).toInt();
          itemtotal = itemtotal - (4 * qty);
          listSisa.add("${qty} inner plas");
        } else {
          listSisa.add("${itemtotal} biji");
          itemtotal = itemtotal - itemtotal;
        }
      }
      return listSisa.length;
    }
  }

  handlesaveprodukpengganti(BuildContext context) {
    List<CartModel> _list = <CartModel>[];
    for (var i = 0; i < listitemforProdukPengganti[0].itemOrder.length; i++) {
      CartModel data = listitemforProdukPengganti[0].itemOrder[i];
      _list.add(CartModel(data.kdProduct, data.nmProduct, data.Qty, data.Satuan,
          data.hrgPerPieces));
    }
    List<CartDetail> _listdetail = <CartDetail>[];
    for (var i = 0; i < listProdukPengganti.length; i++) {
      _listdetail.add(CartDetail(listProdukPengganti[i].kdProduct,
          listProdukPengganti[i].nmProduct, listProdukPengganti[i].itemOrder));
    }
    if (listTukarWarna.isEmpty) {
      listTukarWarna.add(TukarWarnaModel(selectedProductTukarWarna[0].kdProduct,
          selectedProductTukarWarna[0].nmProduct, _list, _listdetail));
    } else {
      if (listTukarWarna.any(
          (data) => data.kdProduct == selectedProductTukarWarna[0].kdProduct)) {
        for (var i = 0; i < listTukarWarna.length; i++) {
          if (listTukarWarna[i].kdProduct ==
              selectedProductTukarWarna[0].kdProduct) {
            listTukarWarna[i].listqtyheader.clear();
            listTukarWarna[i].listitemdetail.clear();
            listTukarWarna[i].listqtyheader.addAll(_list);
            listTukarWarna[i].listitemdetail.addAll(_listdetail);
          }
        }
      } else {
        listTukarWarna.add(TukarWarnaModel(
            selectedProductTukarWarna[0].kdProduct,
            selectedProductTukarWarna[0].nmProduct,
            _list,
            _listdetail));
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

  deleteItemTukarWarna(TukarWarnaModel data) {
    listTukarWarna
        .removeWhere((element) => element.kdProduct == data.kdProduct);
  }
}
