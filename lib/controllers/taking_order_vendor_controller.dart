import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sfa_tools/models/cartmodel.dart';
import 'package:sfa_tools/models/paymentdata.dart';
import 'package:sfa_tools/models/productdata.dart';
import 'package:sfa_tools/models/reportpembayaranmodel.dart';
import 'package:sfa_tools/models/reportpenjualanmodel.dart';
import 'package:sfa_tools/screens/transaction/payment/dialogconfirm.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/dialogcheckout.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/dialogdelete.dart';
import '../common/app_config.dart';
import '../models/tarikbarangmodel.dart';

class TakingOrderVendorController extends GetxController
    with GetSingleTickerProviderStateMixin {
  @override
  void onInit() {
    super.onInit();
    controller = TabController(vsync: this, length: 4, initialIndex: 0);
    cnt = SingleValueDropDownController();
    getListItem();
    getReportList();
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

  handleSaveConfirm(String msg) {
    Get.dialog(Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogConfirm(
          message: msg,
        )));
  }

  // for penjualan page
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
  RxString choosedAddress = "".obs;
  var dummyList = [
    'Aries Bling Emulsion SW - 18 KG',
    'ABSOLUTE Roof 30 - 2.5 LT',
    'AVIAN Cling Synthetic SWM - 3.4 LT',
    'AVIAN Cling Synthetic 11 - 17 LT',
    'Acura Sb 120 Sonoma Oak',
    'AVIAN Cling Zinc Chromate 901 - 1 KG'
  ];

  getListItem() {
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
        List<CartModel> data = [
          CartModel(cartList[i].kdProduct, cartList[i].nmProduct,
              cartList[i].Qty, cartList[i].Satuan, cartList[i].hrgPerPieces)
        ];
        cartDetailList.add(CartDetail(
          cartList[i].kdProduct,
          cartList[i].nmProduct,
          data,
        ));
      } else {
        for (var j = 0; j < cartDetailList.length; j++) {
          if (cartDetailList[j].kdProduct == cartList[i].kdProduct) {
            var counter = 0;
            for (var l = 0; l < cartDetailList[j].itemOrder.length; l++) {
              if (cartDetailList[j].itemOrder[l].Satuan == cartList[i].Satuan) {
                counter++;
                break;
              }
            }
            if (counter == 0) {
              cartDetailList[j].itemOrder.add(CartModel(
                  cartList[i].kdProduct,
                  cartList[i].nmProduct,
                  cartList[i].Qty,
                  cartList[i].Satuan,
                  cartList[i].hrgPerPieces));
            }
          } else if (cartDetailList[j].kdProduct != cartList[i].kdProduct) {
            var counter = 0;
            for (var k = 0; k < cartDetailList.length; k++) {
              if (cartDetailList[k].kdProduct == cartList[i].kdProduct) {
                counter++;
                break;
              }
            }
            if (counter == 0) {
              List<CartModel> data = [
                CartModel(
                    cartList[i].kdProduct,
                    cartList[i].nmProduct,
                    cartList[i].Qty,
                    cartList[i].Satuan,
                    cartList[i].hrgPerPieces)
              ];
              cartDetailList.add(CartDetail(
                  cartList[i].kdProduct, cartList[i].nmProduct, data));
            }
          }
        }
      }
    }
  }

  countTotalDetail(CartDetail data) {
    var total = 0.0;
    for (var i = 0; i < data.itemOrder.length; i++) {
      total = total + (data.itemOrder[i].Qty * data.itemOrder[i].hrgPerPieces);
    }
    return total.toInt();
  }

  getDetailProduct(String kdProduct) {
    List<ProductData> list = <ProductData>[];
    // print(cnt.dropDownValue!.value);
    for (var i = 0; i < listProduct.length; i++) {
      if (listProduct[i].kdProduct == kdProduct) {
        list.add(listProduct[i]);
        selectedProduct.value = list;
      }
    }
    // print(selectedProduct.value[0].detailProduct[0].satuan);
  }

  handleDeleteItem(CartDetail data) {
    Get.dialog(Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogDelete(
            nmProduct: data.nmProduct,
            ontap: () async {
              await deleteItem(data);
              Get.back();
            })));
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
    for (var k = 0; k < listProduct.length; k++) {
      if (listProduct[k].kdProduct == data.kdProduct) {
        for (var i = 0; i < data.itemOrder.length; i++) {
          for (var j = 0; j < listProduct[k].detailProduct.length; j++) {
            if (j == 0 &&
                listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty1.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 1 &&
                listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty2.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 2 &&
                listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty3.value.text = data.itemOrder[i].Qty.toString();
            }
          }
        }
      }
    }
    getDetailProduct(data.kdProduct);
  }

  handleProductSearchButton(String val) async {
    selectedValue.value = val;
    qty1.value.text = "0";
    qty2.value.text = "0";
    qty3.value.text = "0";
    if (cartList.isNotEmpty && cartList.any((data) => data.kdProduct == val)) {
      for (var i = 0; i < cartDetailList.length; i++) {
        if (cartDetailList[i].kdProduct == val) {
          handleEditItem(cartDetailList[i]);
        }
      }
    } else {
      await getDetailProduct(val);
    }
  }

  previewCheckOut() {
    Get.dialog(Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogCheckOut()));
  }

  //for laporan page
  RxString choosedReport = "".obs;
  List<ReportPenjualanModel> listReportPenjualan = <ReportPenjualanModel>[];
  RxList<ReportPembayaranModel> listReportPembayaranshow =
      <ReportPembayaranModel>[].obs;
  RxList<ReportPenjualanModel> listReportPenjualanShow =
      <ReportPenjualanModel>[].obs;
  List<ReportPembayaranModel> listReportPembayaran = <ReportPembayaranModel>[];
  RxInt allReportlength = 0.obs;

  getReportList() {
    listReportPenjualan.clear();
    List<CartModel> data = [
      CartModel("asc", dummyList[0], 2, "dos", 10000),
      CartModel("asc", dummyList[0], 1, "biji", 20000)
    ];
    List<CartDetail> list = [CartDetail("asc", dummyList[0], data)];
    listReportPenjualan.add(ReportPenjualanModel("GO-00AC1A0103-2307311034-001",
        "penjualan", "31-07-2023", "10:34", list, "test note pendek"));

    List<CartModel> data2 = [
      CartModel("desc", dummyList[1], 12, "kaleng", 10000)
    ];
    List<CartModel> data3 = [
      CartModel("ccc", dummyList[dummyList.length - 1], 4, "inner plas", 12000),
      CartModel("ccc", dummyList[dummyList.length - 1], 11, "dos", 12000),
    ];
    List<CartDetail> list2 = [
      CartDetail("desc", dummyList[1], data2),
      CartDetail("ccc", dummyList[dummyList.length - 1], data3)
    ];
    listReportPenjualan.add(ReportPenjualanModel("GO-00AC1A0103-2307311045-001",
        "penjualan", "31-07-2023", "10:45", list2, ""));

    List<CartModel> data4 = [
      CartModel("desc", dummyList[1], 12, "kaleng", 10000)
    ];
    List<CartModel> data5 = [
      CartModel("ccc", dummyList[dummyList.length - 1], 4, "inner plas", 12000),
      CartModel("ccc", dummyList[dummyList.length - 1], 11, "dos", 12000),
    ];
    List<CartModel> data6 = [
      CartModel("asc", dummyList[0], 2, "dos", 10000),
      CartModel("asc", dummyList[0], 1, "biji", 20000)
    ];
    List<CartDetail> list3 = [
      CartDetail("asc", dummyList[0], data6),
      CartDetail("desc", dummyList[1], data4),
      CartDetail("ccc", dummyList[dummyList.length - 1], data5)
    ];
    listReportPenjualan.add(ReportPenjualanModel(
        "GO-00AC1A0103-2308010914-001",
        "penjualan",
        "01-08-2023",
        "09:14",
        list3,
        "test note panjang fasbgwujkasbkfbuwahsfjkwiahfjkhuiwhfuia"));

    listReportPenjualanShow.addAll(listReportPenjualan);

    listReportPembayaran.clear();
    List<PaymentData> payment1 = [
      PaymentData("Tunai", "", "Setor di Cabang", "", 50000),
      PaymentData("Transfer", "", "BCA", "", 100000),
      PaymentData("cek", "uvusadeawdssa", "MANDIRI", "02-08-2023", 750000),
      PaymentData("cn", "", "", "", 250000),
    ];
    listReportPembayaran.add(ReportPembayaranModel(
        "GP-00AC1A0103-2308021435-001",
        1150000.0,
        "02-08-2023",
        "14:35",
        payment1));
    listReportPembayaranshow.addAll(listReportPembayaran);
    allReportlength.value =
        listReportPenjualanShow.length + listReportPembayaranshow.length;
  }

  filteReport() {
    if (choosedReport.value.contains("Semua")) {
      listReportPenjualanShow.value.clear();
      listReportPenjualanShow.value.addAll(listReportPenjualan);
      listReportPembayaranshow.clear();
      listReportPembayaranshow.value.addAll(listReportPembayaran);
    } else if (choosedReport.value == "Transaksi Penjualan") {
      listReportPenjualanShow.value.clear();
      listReportPembayaranshow.clear();
      listReportPenjualanShow.value.addAll(listReportPenjualan);
    } else if (choosedReport.value == "Transaksi Pembayaran") {
      listReportPenjualanShow.value.clear();
      listReportPembayaranshow.clear();
      listReportPembayaranshow.value.addAll(listReportPembayaran);
    }
  }

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

  //for retur page
  RxList<bool> selectedsegment = [true, false, false, false, false].obs;
  RxInt indexSegment = 0.obs;
  //
  Rx<TextEditingController> tarikbarangfield = TextEditingController().obs;
  Rx<TextEditingController> tukarwarnafield = TextEditingController().obs;
  Rx<TextEditingController> gantikemasanfield = TextEditingController().obs;
  Rx<TextEditingController> servismebelfield = TextEditingController().obs;
  Rx<TextEditingController> gantibarangfield = TextEditingController().obs;
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
  //
  RxList<ProductData> selectedProducttarikbarang = <ProductData>[].obs;
  RxList<ProductData> selectedProductgantikemasan = <ProductData>[].obs;
  RxList<ProductData> selectedProductservismebel = <ProductData>[].obs;
  RxList<ProductData> selectedProductgantibarang = <ProductData>[].obs;
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
  //
  RxString selectedAlasantb = "".obs;
  RxString selectedAlasangk = "".obs;
  //
  RxList<TarikBarangModel> listTarikBarang = <TarikBarangModel>[].obs;
  RxList<TarikBarangModel> listgantikemasan = <TarikBarangModel>[].obs;
  RxList<TarikBarangModel> listServisMebel = <TarikBarangModel>[].obs;
  RxList<TarikBarangModel> listGantiBarang = <TarikBarangModel>[].obs;

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

  getDetailProductGk(String kdProduct) {
    List<ProductData> list = <ProductData>[];
    for (var i = 0; i < listProduct.length; i++) {
      if (listProduct[i].kdProduct == kdProduct) {
        list.add(listProduct[i]);
        selectedProductgantikemasan.value = list;
      }
    }
  }

  getDetailProductTb(String kdProduct) {
    List<ProductData> list = <ProductData>[];
    for (var i = 0; i < listProduct.length; i++) {
      if (listProduct[i].kdProduct == kdProduct) {
        list.add(listProduct[i]);
        selectedProducttarikbarang.value = list;
      }
    }
  }

  getDetailProductSm(String kdProduct) {
    List<ProductData> list = <ProductData>[];
    for (var i = 0; i < listProduct.length; i++) {
      if (listProduct[i].kdProduct == kdProduct) {
        list.add(listProduct[i]);
        selectedProductservismebel.value = list;
      }
    }
  }

  getDetailProductGb(String kdProduct) {
    List<ProductData> list = <ProductData>[];
    for (var i = 0; i < listProduct.length; i++) {
      if (listProduct[i].kdProduct == kdProduct) {
        list.add(listProduct[i]);
        selectedProductgantibarang.value = list;
      }
    }
  }

  handleEditTarikBarangItem(TarikBarangModel data) {
    selectedKdProducttarikbarang.value = data.kdProduct.toString();
    qty1tb.value.text = '0';
    qty2tb.value.text = '0';
    qty3tb.value.text = '0';
    selectedAlasantb.value = data.alasan;
    for (var k = 0; k < listProduct.length; k++) {
      if (listProduct[k].kdProduct == data.kdProduct) {
        for (var i = 0; i < data.itemOrder.length; i++) {
          for (var j = 0; j < listProduct[k].detailProduct.length; j++) {
            if (j == 0 &&
                listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty1tb.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 1 &&
                listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty2tb.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 2 &&
                listProduct[k].detailProduct[j].satuan ==
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
    for (var k = 0; k < listProduct.length; k++) {
      if (listProduct[k].kdProduct == data.kdProduct) {
        for (var i = 0; i < data.itemOrder.length; i++) {
          for (var j = 0; j < listProduct[k].detailProduct.length; j++) {
            if (j == 0 &&
                listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty1gk.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 1 &&
                listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty2gk.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 2 &&
                listProduct[k].detailProduct[j].satuan ==
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
    for (var k = 0; k < listProduct.length; k++) {
      if (listProduct[k].kdProduct == data.kdProduct) {
        for (var i = 0; i < data.itemOrder.length; i++) {
          for (var j = 0; j < listProduct[k].detailProduct.length; j++) {
            if (j == 0 &&
                listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty1sm.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 1 &&
                listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty2sm.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 2 &&
                listProduct[k].detailProduct[j].satuan ==
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
    for (var k = 0; k < listProduct.length; k++) {
      if (listProduct[k].kdProduct == data.kdProduct) {
        for (var i = 0; i < data.itemOrder.length; i++) {
          for (var j = 0; j < listProduct[k].detailProduct.length; j++) {
            if (j == 0 &&
                listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty1gb.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 1 &&
                listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty2gb.value.text = data.itemOrder[i].Qty.toString();
            } else if (j == 2 &&
                listProduct[k].detailProduct[j].satuan ==
                    data.itemOrder[i].Satuan) {
              qty3gb.value.text = data.itemOrder[i].Qty.toString();
            }
          }
        }
      }
    }

    getDetailProductGb(data.kdProduct);
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
      List<TarikBarangItemModel> _items = <TarikBarangItemModel>[];
      for (var i = 0;
          i < selectedProducttarikbarang[0].detailProduct.length;
          i++) {
        if (i == 0 &&
            qty1tb.value.text != "" &&
            int.parse(qty1tb.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProducttarikbarang[0].kdProduct,
              selectedProducttarikbarang[0].nmProduct,
              int.parse(qty1tb.value.text),
              selectedProducttarikbarang[0].detailProduct[i].satuan));
        } else if (i == 1 &&
            qty2tb.value.text != "" &&
            int.parse(qty2tb.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProducttarikbarang[0].kdProduct,
              selectedProducttarikbarang[0].nmProduct,
              int.parse(qty2tb.value.text),
              selectedProducttarikbarang[0].detailProduct[i].satuan));
        } else if (i == 2 &&
            qty3tb.value.text != "" &&
            int.parse(qty3tb.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProducttarikbarang[0].kdProduct,
              selectedProducttarikbarang[0].nmProduct,
              int.parse(qty3tb.value.text),
              selectedProducttarikbarang[0].detailProduct[i].satuan));
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
      List<TarikBarangItemModel> _items = <TarikBarangItemModel>[];
      for (var i = 0;
          i < selectedProducttarikbarang[0].detailProduct.length;
          i++) {
        if (i == 0 &&
            qty1tb.value.text != "" &&
            int.parse(qty1tb.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProducttarikbarang[0].kdProduct,
              selectedProducttarikbarang[0].nmProduct,
              int.parse(qty1tb.value.text),
              selectedProducttarikbarang[0].detailProduct[i].satuan));
        } else if (i == 1 &&
            qty2tb.value.text != "" &&
            int.parse(qty2tb.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProducttarikbarang[0].kdProduct,
              selectedProducttarikbarang[0].nmProduct,
              int.parse(qty2tb.value.text),
              selectedProducttarikbarang[0].detailProduct[i].satuan));
        } else if (i == 2 &&
            qty3tb.value.text != "" &&
            int.parse(qty3tb.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProducttarikbarang[0].kdProduct,
              selectedProducttarikbarang[0].nmProduct,
              int.parse(qty3tb.value.text),
              selectedProducttarikbarang[0].detailProduct[i].satuan));
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
      List<TarikBarangItemModel> _items = <TarikBarangItemModel>[];
      for (var i = 0;
          i < selectedProductgantikemasan[0].detailProduct.length;
          i++) {
        if (i == 0 &&
            qty1gk.value.text != "" &&
            int.parse(qty1gk.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductgantikemasan[0].kdProduct,
              selectedProductgantikemasan[0].nmProduct,
              int.parse(qty1gk.value.text),
              selectedProductgantikemasan[0].detailProduct[i].satuan));
        } else if (i == 1 &&
            qty2gk.value.text != "" &&
            int.parse(qty2gk.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductgantikemasan[0].kdProduct,
              selectedProductgantikemasan[0].nmProduct,
              int.parse(qty2gk.value.text),
              selectedProductgantikemasan[0].detailProduct[i].satuan));
        } else if (i == 2 &&
            qty3gk.value.text != "" &&
            int.parse(qty3gk.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductgantikemasan[0].kdProduct,
              selectedProductgantikemasan[0].nmProduct,
              int.parse(qty3gk.value.text),
              selectedProductgantikemasan[0].detailProduct[i].satuan));
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
      List<TarikBarangItemModel> _items = <TarikBarangItemModel>[];
      for (var i = 0;
          i < selectedProductgantikemasan[0].detailProduct.length;
          i++) {
        if (i == 0 &&
            qty1gk.value.text != "" &&
            int.parse(qty1gk.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductgantikemasan[0].kdProduct,
              selectedProductgantikemasan[0].nmProduct,
              int.parse(qty1gk.value.text),
              selectedProductgantikemasan[0].detailProduct[i].satuan));
        } else if (i == 1 &&
            qty2gk.value.text != "" &&
            int.parse(qty2gk.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductgantikemasan[0].kdProduct,
              selectedProductgantikemasan[0].nmProduct,
              int.parse(qty2gk.value.text),
              selectedProductgantikemasan[0].detailProduct[i].satuan));
        } else if (i == 2 &&
            qty3gk.value.text != "" &&
            int.parse(qty3gk.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductgantikemasan[0].kdProduct,
              selectedProductgantikemasan[0].nmProduct,
              int.parse(qty3gk.value.text),
              selectedProductgantikemasan[0].detailProduct[i].satuan));
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
      List<TarikBarangItemModel> _items = <TarikBarangItemModel>[];
      for (var i = 0;
          i < selectedProductservismebel[0].detailProduct.length;
          i++) {
        if (i == 0 &&
            qty1sm.value.text != "" &&
            int.parse(qty1sm.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductservismebel[0].kdProduct,
              selectedProductservismebel[0].nmProduct,
              int.parse(qty1sm.value.text),
              selectedProductservismebel[0].detailProduct[i].satuan));
        } else if (i == 1 &&
            qty2sm.value.text != "" &&
            int.parse(qty2sm.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductservismebel[0].kdProduct,
              selectedProductservismebel[0].nmProduct,
              int.parse(qty2sm.value.text),
              selectedProductservismebel[0].detailProduct[i].satuan));
        } else if (i == 2 &&
            qty3sm.value.text != "" &&
            int.parse(qty3sm.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductservismebel[0].kdProduct,
              selectedProductservismebel[0].nmProduct,
              int.parse(qty3sm.value.text),
              selectedProductservismebel[0].detailProduct[i].satuan));
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
      List<TarikBarangItemModel> _items = <TarikBarangItemModel>[];
      for (var i = 0;
          i < selectedProductservismebel[0].detailProduct.length;
          i++) {
        if (i == 0 &&
            qty1sm.value.text != "" &&
            int.parse(qty1sm.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductservismebel[0].kdProduct,
              selectedProductservismebel[0].nmProduct,
              int.parse(qty1sm.value.text),
              selectedProductservismebel[0].detailProduct[i].satuan));
        } else if (i == 1 &&
            qty2sm.value.text != "" &&
            int.parse(qty2sm.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductservismebel[0].kdProduct,
              selectedProductservismebel[0].nmProduct,
              int.parse(qty2sm.value.text),
              selectedProductservismebel[0].detailProduct[i].satuan));
        } else if (i == 2 &&
            qty3sm.value.text != "" &&
            int.parse(qty3sm.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductservismebel[0].kdProduct,
              selectedProductservismebel[0].nmProduct,
              int.parse(qty3sm.value.text),
              selectedProductservismebel[0].detailProduct[i].satuan));
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
      List<TarikBarangItemModel> _items = <TarikBarangItemModel>[];
      for (var i = 0;
          i < selectedProductgantibarang[0].detailProduct.length;
          i++) {
        if (i == 0 &&
            qty1gb.value.text != "" &&
            int.parse(qty1gb.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductgantibarang[0].kdProduct,
              selectedProductgantibarang[0].nmProduct,
              int.parse(qty1gb.value.text),
              selectedProductgantibarang[0].detailProduct[i].satuan));
        } else if (i == 1 &&
            qty2gb.value.text != "" &&
            int.parse(qty2gb.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductgantibarang[0].kdProduct,
              selectedProductgantibarang[0].nmProduct,
              int.parse(qty2gb.value.text),
              selectedProductgantibarang[0].detailProduct[i].satuan));
        } else if (i == 2 &&
            qty3gb.value.text != "" &&
            int.parse(qty3gb.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductgantibarang[0].kdProduct,
              selectedProductgantibarang[0].nmProduct,
              int.parse(qty3gb.value.text),
              selectedProductgantibarang[0].detailProduct[i].satuan));
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
      List<TarikBarangItemModel> _items = <TarikBarangItemModel>[];
      for (var i = 0;
          i < selectedProductgantibarang[0].detailProduct.length;
          i++) {
        if (i == 0 &&
            qty1gb.value.text != "" &&
            int.parse(qty1gb.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductgantibarang[0].kdProduct,
              selectedProductgantibarang[0].nmProduct,
              int.parse(qty1gb.value.text),
              selectedProductgantibarang[0].detailProduct[i].satuan));
        } else if (i == 1 &&
            qty2gb.value.text != "" &&
            int.parse(qty2gb.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductgantibarang[0].kdProduct,
              selectedProductgantibarang[0].nmProduct,
              int.parse(qty2gb.value.text),
              selectedProductgantibarang[0].detailProduct[i].satuan));
        } else if (i == 2 &&
            qty3gb.value.text != "" &&
            int.parse(qty3gb.value.text) != 0) {
          _items.add(TarikBarangItemModel(
              selectedProductgantibarang[0].kdProduct,
              selectedProductgantibarang[0].nmProduct,
              int.parse(qty3gb.value.text),
              selectedProductgantibarang[0].detailProduct[i].satuan));
        }
      }
      if (_items.isNotEmpty) {
        listGantiBarang[int.parse(flag)].kdProduct =
            selectedProductservismebel[0].kdProduct;
        listGantiBarang[int.parse(flag)].nmProduct =
            selectedProductservismebel[0].nmProduct;
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
}
