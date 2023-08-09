import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/laporan_controller.dart';
import 'package:sfa_tools/controllers/pembayaran_controller.dart';
import 'package:sfa_tools/controllers/penjualan_controller.dart';
import 'package:sfa_tools/controllers/retur_controller.dart';
import 'package:sfa_tools/models/cartmodel.dart';
import 'package:sfa_tools/models/paymentdata.dart';
import 'package:sfa_tools/models/productdata.dart';
import 'package:sfa_tools/models/reportpembayaranmodel.dart';
import 'package:sfa_tools/models/reportpenjualanmodel.dart';
import 'package:sfa_tools/models/tukarwarnamodel.dart';
import 'package:sfa_tools/screens/taking_order_vendor/payment/dialogconfirm.dart';
import '../models/tarikbarangmodel.dart';

class TakingOrderVendorController extends GetxController
    with GetTickerProviderStateMixin {
  final PembayaranController _pembayaranController =
      Get.put(PembayaranController());
  final LaporanController _laporanController = Get.put(LaporanController());
  final PenjualanController _penjualanController =
      Get.put(PenjualanController());

  final ReturController _returController = Get.put(ReturController());

  @override
  void onInit() {
    super.onInit();
    _pembayaranController.controller =
        TabController(vsync: this, length: 4, initialIndex: 0);
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
        shape: const RoundedRectangleBorder(
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
  Rx<TextEditingController> get tarikbarangfield =>
      _returController.tarikbarangfield;
  Rx<TextEditingController> get tukarwarnafield =>
      _returController.tukarwarnafield;
  Rx<TextEditingController> get gantikemasanfield =>
      _returController.gantikemasanfield;
  Rx<TextEditingController> get servismebelfield =>
      _returController.servismebelfield;
  Rx<TextEditingController> get gantibarangfield =>
      _returController.gantibarangfield;
  Rx<TextEditingController> get produkpenggantifield =>
      _returController.produkpenggantifield;
  RxList<ProductData> get selectedProducttarikbarang =>
      _returController.selectedProducttarikbarang;
  RxList<ProductData> get selectedProductgantikemasan =>
      _returController.selectedProductgantikemasan;
  RxList<ProductData> get selectedProductservismebel =>
      _returController.selectedProductservismebel;
  RxList<ProductData> get selectedProductgantibarang =>
      _returController.selectedProductgantibarang;
  RxList<ProductData> get selectedProductTukarWarna =>
      _returController.selectedProductTukarWarna;
  RxList<ProductData> get selectedProductProdukPengganti =>
      _returController.selectedProductProdukPengganti;
  RxList<TarikBarangModel> get listTarikBarang =>
      _returController.listTarikBarang;
  RxList<TarikBarangModel> get listgantikemasan =>
      _returController.listgantikemasan;
  RxList<TarikBarangModel> get listServisMebel =>
      _returController.listServisMebel;
  RxList<TarikBarangModel> get listGantiBarang =>
      _returController.listGantiBarang;
  RxList<TukarWarnaModel> get listTukarWarna => _returController.listTukarWarna;
  RxList<TarikBarangModel> get listProdukPengganti =>
      _returController.listProdukPengganti;
  RxList<TarikBarangModel> get listitemforProdukPengganti =>
      _returController.listitemforProdukPengganti;
  RxList get listSisa => _returController.listSisa;
  RxInt get indexSegment => _returController.indexSegment;
  RxList<bool> get selectedsegment => _returController.selectedsegment;
  Rx<TextEditingController> get qty1tb => _returController.qty1tb;
  Rx<TextEditingController> get qty2tb => _returController.qty2tb;
  Rx<TextEditingController> get qty3tb => _returController.qty3tb;
  Rx<TextEditingController> get qty1gk => _returController.qty1gk;
  Rx<TextEditingController> get qty2gk => _returController.qty2gk;
  Rx<TextEditingController> get qty3gk => _returController.qty3gk;
  Rx<TextEditingController> get qty1sm => _returController.qty1sm;
  Rx<TextEditingController> get qty2sm => _returController.qty2sm;
  Rx<TextEditingController> get qty3sm => _returController.qty3sm;
  Rx<TextEditingController> get qty1gb => _returController.qty1gb;
  Rx<TextEditingController> get qty2gb => _returController.qty2gb;
  Rx<TextEditingController> get qty3gb => _returController.qty3gb;
  Rx<TextEditingController> get qty1tw => _returController.qty1tw;
  Rx<TextEditingController> get qty2tw => _returController.qty2tw;
  Rx<TextEditingController> get qty3tw => _returController.qty3tw;
  Rx<TextEditingController> get qty1pp => _returController.qty1pp;
  Rx<TextEditingController> get qty2pp => _returController.qty2pp;
  Rx<TextEditingController> get qty3pp => _returController.qty3pp;
  RxBool get tukarwarnahorizontal => _returController.tukarwarnahorizontal;
  RxBool get tarikbaranghorizontal => _returController.tarikbaranghorizontal;
  RxBool get gantikemasanhorizontal => _returController.gantikemasanhorizontal;
  RxBool get servismebelhorizontal => _returController.servismebelhorizontal;
  RxBool get gantibaranghorizontal => _returController.gantibaranghorizontal;
  RxString get selectedKdProducttarikbarang =>
      _returController.selectedKdProducttarikbarang;
  RxString get selectedKdProductgantikemasan =>
      _returController.selectedKdProductgantikemasan;
  RxString get selectedKdProductservismebel =>
      _returController.selectedKdProductservismebel;
  RxString get selectedKdProductgantibarang =>
      _returController.selectedKdProductgantibarang;
  RxString get selectedKdProductTukarWarna =>
      _returController.selectedKdProductTukarWarna;
  RxString get selectedKdProductProdukPengganti =>
      _returController.selectedKdProductProdukPengganti;
  RxString get selectedAlasantb => _returController.selectedAlasantb;
  RxString get selectedAlasangk => _returController.selectedAlasangk;
  RxBool get isOverfow => _returController.isOverfow;

  handleProductSearchGb(String val) async {
    await _returController.handleProductSearchGb(val);
  }

  handleProductSearchPp(String val) async {
    await _returController.handleProductSearchPp(val);
  }

  handleProductSearchTb(String val) async {
    await _returController.handleProductSearchTb(val);
  }

  handleProductSearchGk(String val) async {
    await _returController.handleProductSearchGk(val);
  }

  handleProductSearchSm(String val) async {
    await _returController.handleProductSearchSm(val);
  }

  handleProductSearchTw(String val) async {
    await _returController.handleProductSearchTw(val);
  }

  addToCartTb() {
    _returController.addToCartTb();
  }

  addToCartGk() {
    _returController.addToCartGk();
  }

  addToCartGb() {
    _returController.addToCartGb();
  }

  addToCartPp() {
    _returController.addToCartPp();
  }

  addToCartSm() {
    _returController.addToCartSm();
  }

  handleSaveGantiBarang() {
    _returController.handleSaveGantiBarang();
  }

  handleSaveServisMebel() {
    _returController.handleSaveServisMebel();
  }

  handleSaveTarikBarang() {
    _returController.handleSaveTarikBarang();
  }

  handlesaveprodukpengganti(BuildContext context) {
    _returController.handlesaveprodukpengganti(context);
  }

  handleEditGantiBarangItem(TarikBarangModel data) {
    _returController.handleEditGantiBarangItem(data);
  }

  handleEditTukarWarnaItem(TukarWarnaModel data) {
    _returController.handleEditTukarWarnaItem(data);
  }

  handleEditProdukPenggantiItem(TarikBarangModel data) {
    _returController.handleEditProdukPenggantiItem(data);
  }

  handleEditGantiKemasanItem(TarikBarangModel data) {
    _returController.handleEditGantiKemasanItem(data);
  }

  handleEditServisMebelItem(TarikBarangModel data) {
    _returController.handleEditServisMebelItem(data);
  }

  handleEditTarikBarangItem(TarikBarangModel data) {
    _returController.handleEditTarikBarangItem(data);
  }

  handleDeleteItemRetur(TarikBarangModel data, String from) {
    _returController.handleDeleteItemRetur(data, from);
  }

  handleDeleteItemTukarWarna(TukarWarnaModel data) {
    _returController.handleDeleteItemTukarWarna(data);
  }

  showProdukPengganti(BuildContext context) {
    _returController.showProdukPengganti(context);
  }

  showEditProdukPengganti(BuildContext context) {
    _returController.showEditProdukPengganti(context);
  }
}
