import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:list_treeview/list_treeview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:sfa_tools/controllers/laporan_controller.dart';
import 'package:sfa_tools/controllers/pembayaran_controller.dart';
import 'package:sfa_tools/controllers/penjualan_controller.dart';
import 'package:sfa_tools/controllers/retur_controller.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/models/cartmodel.dart';
import 'package:sfa_tools/models/other_address_data.dart';
import 'package:sfa_tools/models/paymentdata.dart';
import 'package:sfa_tools/models/productdata.dart';
import 'package:sfa_tools/models/reportpembayaranmodel.dart';
import 'package:sfa_tools/models/reportpenjualanmodel.dart';
import 'package:sfa_tools/models/shiptoaddress.dart';
import 'package:sfa_tools/models/tukarwarnamodel.dart';
import 'package:sfa_tools/screens/taking_order_vendor/payment/dialogconfirm.dart';
import 'package:sfa_tools/tools/utils.dart';
import 'package:showcaseview/showcaseview.dart';
import '../common/app_config.dart';
import '../common/hivebox_vendor.dart';
import '../models/cartdetail.dart';
import '../models/loginmodel.dart';
import '../models/outstandingdata.dart';
import '../models/tarikbarangmodel.dart';
import '../models/treenodedata.dart';
import '../models/vendor.dart';
import '../tools/service.dart';
import 'package:http/http.dart' as http;

class TakingOrderVendorController extends GetxController with GetTickerProviderStateMixin {
  final PembayaranController _pembayaranController = Get.put(PembayaranController());
  final LaporanController _laporanController = Get.put(LaporanController());
  final PenjualanController _penjualanController = Get.put(PenjualanController());
  final ReturController _returController = Get.put(ReturController());
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  final PersistentTabController controllerBar = PersistentTabController(initialIndex: 0);
  String activevendor = "";
  RxString overlayactivepenjualan = "main".obs;
  RxString custcode = "".obs;

  @override
  void onInit() {
    super.onInit();
    setactivendor();
    // prepareinfoproduk();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..forward();
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));
    _pembayaranController.controller =
        TabController(vsync: this, length: 3, initialIndex: 0);
  }

  callcontroller(String controllername) {
    if (controllername.toLowerCase() ==
        "splashscreencontroller".toLowerCase()) {
      final isControllerRegistered =
          GetInstance().isRegistered<SplashscreenController>();
      if (!isControllerRegistered) {
        final SplashscreenController controller =
            Get.put(SplashscreenController());
        return controller;
      } else {
        final SplashscreenController controller = Get.find();
        return controller;
      }
    }
  }

  setactivendor() async {
    SplashscreenController splashscreenController = callcontroller("splashscreencontroller");
    activevendor = splashscreenController.selectedVendor.value.toLowerCase();
    _penjualanController.activevendor = activevendor;
    _laporanController.activevendor = activevendor;
    _pembayaranController.activevendor = activevendor;
    custcode.value = await Utils().getParameterData("cust");
    await getListDataOutStanding();
    await _penjualanController.getListItem();
    await _laporanController.getReportList(true);
    await _pembayaranController.loadpembayaranstate();
    await downloadConfigFile("getinfoproduk");
  }

  handleSaveConfirm(String msg, String title, var ontap) {
    Get.dialog(Dialog(
        key: keyconfirm,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogConfirm(
          message: msg,
          title: title,
          onTap: ontap,
        )));
  }

  // for penjualan page
  RxList<ProductData> get listProduct => _penjualanController.listProduct;
  RxList<CartDetail> get cartDetailList => _penjualanController.cartDetailList;
  RxList<CartModel> get cartList => _penjualanController.cartList;
  RxString get selectedValue => _penjualanController.selectedValue;
  RxList<ProductData> get selectedProduct => _penjualanController.selectedProduct;
  Rx<TextEditingController> get cnt => _penjualanController.cnt;
  RxList<int> get listQty => _penjualanController.listQty;
  Rx<TextEditingController> get notes => _penjualanController.notes;
  RxString get choosedAddress => _penjualanController.choosedAddress;
  RxInt animated = 0.obs;
  get listAnimation => _penjualanController.listAnimation;
  get nmtoko => _penjualanController.nmtoko;
  GlobalKey get keychecout => _penjualanController.keycheckout;
  RxList<ShipToAddress> get listaddress => _penjualanController.listAddress;
  RxBool get needtorefresh => _penjualanController.needtorefresh;
  get komisi => _penjualanController.komisi;
  RxString infoos = "".obs;
  GlobalKey keyalamat = GlobalKey();
  GlobalKey keyconfirm = GlobalKey();
  Rx<TextEditingController> get addressName => _penjualanController.addressName;
  Rx<TextEditingController> get receiverName => _penjualanController.receiverName;
  Rx<TextEditingController> get phoneNum => _penjualanController.phoneNum;
  Rx<TextEditingController> get phoneNumSecond => _penjualanController.phoneNumSecond;
  Rx<TextEditingController> get notesOtherAddress => _penjualanController.notesOtherAddress;
  OtherAddressData? get dataOtherAddress => _penjualanController.dataOtherAddress;
  get hardcodeOtherAddress => _penjualanController.hardcodeOtherAddress;

  addOtherAddressData(){
    _penjualanController.addOtherAddressData();
  }

  showDialogAddOtherAddress(){
    _penjualanController.showDialogAddOtherAddress();
  }

  getListItem() {
    _penjualanController.getListItem();
  }

  countPriceTotal() {
    return _penjualanController.countPriceTotal();
  }

  previewCheckOut() {
    _penjualanController.previewCheckOut();
  }

  reminderaddress(BuildContext ctx){
    ShowCaseWidget.of(ctx).startShowCase([
      keyalamat
    ]);
  }

  addToCart() async {
    _penjualanController.addToCart();
  }

  updateCart() {
    _penjualanController.updateCart();
  }

  handleProductSearchButton(String val) async {
    await cekoutstanding(val);
    await animationController.reverse();
    await _penjualanController.handleProductSearchButton(val);
    await animationController.forward();
  }

  cekoutstanding(String codeitem) {
    try {
      // print(codeitem);
      infoos.value = "";
      var outstandingqty = 0;
      var satuan = "";
      if (listDataOutstanding.isNotEmpty) {
        for (var i = 0; i < listDataOutstanding.length; i++) {
          for (var j = 0; j < listDataOutstanding[i].details!.length; j++) {
            if (codeitem == listDataOutstanding[i].details![j].itemCode) {
              outstandingqty =
                  outstandingqty + listDataOutstanding[i].details![j].qty!;
              satuan = listDataOutstanding[i].details![j].uom!;
            }
          }
        }
      }
      if (outstandingqty != 0 && satuan != "") {
        infoos.value = "$outstandingqty $satuan";
      }
    } catch (e) {
      //print(e);
    }
  }

  countTotalDetail(CartDetail data) {
    return _penjualanController.countTotalDetail(data);
  }

  handleEditItem(CartDetail data) async {
    await cekoutstanding(data.kdProduct);
    _penjualanController.handleEditItem(data);
  }

  handleDeleteItem(CartDetail data) {
    _penjualanController.handleDeleteItem(data);
  }

  showProdukSerupa(CartDetail data) {
    _penjualanController.showProdukSerupa(data);
  }

  checkout(BuildContext ctx) async {
    if (await _penjualanController.cekvalidcheckout()) {
      await _penjualanController.checkout();
      _laporanController.getReportList(false);
      selectedValue.value = "";
      notes.value.clear();
      cartDetailList.clear();
      cartList.clear();
      selectedProduct.clear();
      cnt.value.clear();
      listAnimation.clear();
      choosedAddress.value = "";
      addressName.value.clear();
      receiverName.value.clear();
      phoneNum.value.clear();
      phoneNumSecond.value.clear();
      notesOtherAddress.value.clear();
      await _penjualanController.deletestate();
      try {
        Navigator.pop(keychecout.currentContext!);
        Navigator.pop(keyconfirm.currentContext!);
        // ignore: empty_catches
      } catch (e) {}
      controllerBar.jumpToTab(2);
    } else {
      Navigator.pop(keyconfirm.currentContext!);
      reminderaddress(ctx);
      // Get.snackbar("error", "silahkan pilih alamat pengiriman terlebih dahulu",
      //     backgroundColor: Colors.white, colorText: Colors.red);
    }
  }

  //for outstanding page
  RxList<OutstandingData> listDataOutstanding = <OutstandingData>[].obs;
  RxBool isLoadingOutstanding = false.obs;
  RxBool isFailedLoadOutstanding = false.obs;
  List<Vendor> vendorlist = <Vendor>[];
  int idvendorg = -1;

  getBoxOutStanding() async {
    try {
      outstandingBox = await Hive.openBox('outstandingBox');
      vendorBox = await Hive.openBox('vendorBox');
      // ignore: empty_catches
    } catch (e) {}
  }

  bool loaddataoutstandinghive(var dataosbox) {
    try {
      var dataosboxjson = jsonDecode(dataosbox);
      if (dataosboxjson['data'] != null) {
        listDataOutstanding.clear();
        for (var i = 0; i < dataosboxjson['data'].length; i++) {
          var decodetoosdata = OutstandingData.fromJson(dataosboxjson['data'][i]);
          listDataOutstanding.add(decodetoosdata);
        }
        if (!Utils().isDateNotToday(dataosboxjson['timestamp'])) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  gettoken() async {
    try {
      tokenbox = await Hive.openBox('tokenbox');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    } finally {
      String salesId = await Utils().getParameterData('sales');
      var tokenboxdata = await tokenbox.get(salesId);
      var dectoken = Utils().decrypt(tokenboxdata);
      tokenbox.close();
      // ignore: control_flow_in_finally
      return dectoken;
    }
  }

  getListDataOutStanding() async {
    try {
      isFailedLoadOutstanding.value = false;
      isLoadingOutstanding.value = true;
      String salescode = await Utils().getParameterData("sales");
      String custcode = await Utils().getParameterData("cust");

      //proses get list vendor untuk mendapatkan base url vendor
      if (!vendorBox.isOpen) vendorBox = await Hive.openBox('vendorBox');
      var datavendor = vendorBox.get("$salescode|$custcode");
      vendorBox.close();
      vendorlist.clear();
      for (var i = 0; i < datavendor.length; i++) {
        vendorlist.add(datavendor[i]);
      }
      idvendorg = vendorlist.indexWhere((element) => element.name.toLowerCase() == activevendor);

      //membuat key box dan mencoba mengambil data outstanding pada hive jika ada
      String keyos ="$salescode|$custcode|${vendorlist[idvendorg].prefix}|${vendorlist[idvendorg].baseApiUrl}";
      await getBoxOutStanding();
      if (!outstandingBox.isOpen){
        outstandingBox = await Hive.openBox('outstandingBox');
      }
      var dataosbox = await outstandingBox.get(keyos);
      outstandingBox.close();
      if (dataosbox != null) {
        var isnotnull = loaddataoutstandinghive(dataosbox);
        if (isnotnull) {
          isLoadingOutstanding.value = false;
          isFailedLoadOutstanding.value = false;
          return;
        } else {
          isLoadingOutstanding.value = false;
          isFailedLoadOutstanding.value = false;
          return;
        }
      } else {
          isLoadingOutstanding.value = false;
          isFailedLoadOutstanding.value = false;
          return;
      }

      //proses mengambil data outstanding menggunakan API
      /* unused fetch data on home
      var connTest = await ApiClient().checkConnection(jenis: "vendor");
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      String urlAPI = arrConnTest[1];

      if (!isConnected) {
        if (listDataOutstanding.isEmpty) {
          isLoadingOutstanding.value = false;
          isFailedLoadOutstanding.value = true;
          return;
        } else {
          isLoadingOutstanding.value = false;
          isFailedLoadOutstanding.value = false;
          return;
        }
      }

      String dectoken = await gettoken();
      String urls = vendorlist[idvendorg].baseApiUrl;
      if (urlAPI == AppConfig.baseUrlVendorLocal) {
        urlAPI = Utils().changeUrl(urls);
      } else {
        urlAPI = urls;
      }

      var params = {"customerNo": await Utils().getParameterData("cust")};
      // print(urlAPI);
      var getVendoroustanding = await ApiClient().postData(
          urlAPI,
          "sales-orders/outstanding",
          jsonEncode(params),
          Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            'Authorization': 'Bearer $dectoken',
            'Accept': 'application/json'
          }));
      // print("${urlAPI}sales-orders/outstanding");
      if (getVendoroustanding != null) {
        var dataresponse = OutstandingResponse.fromJson(getVendoroustanding);
        listDataOutstanding.clear();
        for (var i = 0; i < dataresponse.data!.length; i++) {
          listDataOutstanding.add(dataresponse.data![i]);
        }
        var makejson = {
          "data": getVendoroustanding['data'],
          "timestamp": DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now())
        };
        await getBoxOutStanding();
        outstandingBox.delete(keyos);
        outstandingBox.put(keyos, jsonEncode(makejson));
        await outstandingBox.close();
        await vendorBox.close();
      }
      isLoadingOutstanding.value = false;
      */
    } catch (e) {
      isLoadingOutstanding.value = false;
      if (listDataOutstanding.isEmpty) {
        isFailedLoadOutstanding.value = true;
      }
      /* unused fetch data on home
      await loginapivendor();*/
    }
  }

  loginapivendor() async {
    try {
      var connTest = await ApiClient().checkConnection(jenis: "vendor");
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      String urlAPI = arrConnTest[1];
      if (!isConnected) {
        return;
      }
      String salesiddata = await Utils().getParameterData("sales");
      String encparam = Utils().encryptsalescodeforvendor(salesiddata);
      var params = {"username": encparam};
      var result = await ApiClient().postData(
          urlAPI,
          "${AppConfig.apiurlvendorpath}/api/login",
          params,
          Options(
              headers: {HttpHeaders.contentTypeHeader: "application/json"}));
      // print("$urlAPI${AppConfig.apiurlvendorpath}/api/login");
      var dataresp = LoginResponse.fromJson(result);
      if (!tokenbox.isOpen) {
        tokenbox = await Hive.openBox('tokenbox');
      }
      tokenbox.delete(salesiddata);
      tokenbox.put(salesiddata, dataresp.data!.token);
      tokenbox.close();
      // ignore: empty_catches
    } catch (e) {}
  }

  //for laporan page
  RxString get choosedReport => _laporanController.choosedReport;
  RxList<ReportPembayaranModel> get listReportPembayaranshow => _laporanController.listReportPembayaranshow;
  RxList<ReportPenjualanModel> get listReportPenjualanShow => _laporanController.listReportPenjualanShow;
  RxInt get allReportlength => _laporanController.allReportlength;

  filteReport() async {
    await _laporanController.filteReport();
  }

  getreportlist() async {
    await _laporanController.getReportList(true);
  }

  //for payment page
  Rx<TextEditingController> get nomorcek => _pembayaranController.nomorcek;
  Rx<TextEditingController> get nominalcek => _pembayaranController.nominalcek;
  Rx<TextEditingController> get nmbank => _pembayaranController.nmbank;
  Rx<TextEditingController> get jatuhtempotgl =>_pembayaranController.jatuhtempotgl;
  RxList<PaymentData> get listpaymentdata => _pembayaranController.listpaymentdata;
  TabController get controller => _pembayaranController.controller;
  Rx<TextEditingController> get nominalCn => _pembayaranController.nominalCn;
  Rx<TextEditingController> get nominaltransfer => _pembayaranController.nominaltransfer;
  RxString get choosedTransferMethod => _pembayaranController.choosedTransferMethod;
  RxString get choosedTunaiMethod => _pembayaranController.choosedTunaiMethod;
  Rx<TextEditingController> get nominaltunai => _pembayaranController.nominaltunai;
  get pembayaranListKey => _pembayaranController.pembayaranListKey;
  get showBanner => _pembayaranController.showBanner;
  get totalpiutang => _penjualanController.totalpiutang;
  get totaljatuhtempo => _penjualanController.totaljatuhtempo;

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

  savepaymentdata() async {
    bool isdone = await _pembayaranController.savepaymentdata();
    // bool isdone = false;
    if (isdone) {
      await _laporanController.getReportList(false);
      try {
        Navigator.pop(keyconfirm.currentContext!);
        // ignore: empty_catches
      } catch (e) {}
      controllerBar.jumpToTab(2);
    } else {
      try {
        Navigator.pop(keyconfirm.currentContext!);
        // ignore: empty_catches
      } catch (e) {}
      Utils().showDialogSingleButton(null,"Oops, Terjadi kesalahan" ,"Data Payment tidak ditemukan, silahkan coba lagi !","error.json",(){Get.back();});
    }
  }

  // for informasi page
  RxList<bool> selectedsegmentinformasi = [true, false, false].obs;
  RxList<bool> selectedsegmentcategory = [true, false, false].obs;
  RxInt indexselectedsegmentcategory = 0.obs;
  RxInt indexSegmentinformasi = 0.obs;
  RxBool isSuccess = false.obs;
  var listnode = <TreeNodeData>[];
  TreeViewController? treecontroller;
  RxInt datanodelength = 0.obs;
  RxInt indicatorIndex = 0.obs;
  String productdir = AppConfig().productdir;
  String informasiconfig = AppConfig().informasiconfig;
  List<String> listdir = [];
  RxList<String> pricelistdir = <String>[].obs;
  RxList<String> promodir = <String>[].obs;

  Future<void> downloadConfigFile(String url) async {
    listdir.clear();
    pricelistdir.clear();

    if (await File('$productdir/${activevendor.toLowerCase()}/$informasiconfig').exists()) {
      processfile(false);
      return;
    }

    // Create a folder if it doesn't exist
    Directory directory = Directory('$productdir/${activevendor.toLowerCase()}/');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    var connTest = await ApiClient().checkConnection();
    var arrConnTest = connTest.split("|");
    bool isConnected = arrConnTest[0] == 'true';
    String urlAPI = arrConnTest[1];
    if (!isConnected) {
      processfile(false);
      return;
    }
    // Create the file path
    String filePath = '$productdir/${activevendor.toLowerCase()}/$informasiconfig';

    // Download the file
    final response = await http.get(Uri.parse('$urlAPI/$url?vendor=$activevendor'));

    if (response.statusCode == 200) {
      // Write the file
      try {
        var resp = jsonDecode(response.body);
        if(resp['error'] == 'vendor tidak ditemukan'){
          processfile(false);
        }
      } catch (e) {
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        processfile(true);
      }
    } else {
      processfile(false);
      // throw Exception('Failed to download file');
    }
  }

  isthereanyperiod(List<String> stringdata, bool download) {
    var filedir = stringdata[1];
    var splitdir = filedir.split("/");
    bool ispricelist = false;
    bool isproductknowledge = false;
    bool ispromo = false;
    if (splitdir[0] == AppConfig().folderpricelist) {
      ispricelist = true;
    } else if (splitdir[0] == AppConfig().folderProductKnowledge) {
      isproductknowledge = true;
      filedir = "";
      for (var i = 1; i < splitdir.length; i++) {
        filedir = "$filedir/${splitdir[i]}";
      }
      filedir = filedir.substring(1, filedir.length);
    } else if (splitdir[0] == AppConfig().folderPromo){
      ispromo = true;
    }
    if (stringdata.length == 2) {
      //tanpa periode
      if (ispricelist) {
        int idx = pricelistdir.indexOf(filedir);
        if(idx == -1){
          pricelistdir.add(filedir);
        }
      } else if (isproductknowledge) {
        int idx = listdir.indexOf(filedir);
        if(idx == -1){
          listdir.add(filedir);
        }
      }
      if (download) {
        if (ispricelist) {
          downloadusingdir(filedir);
        } else if (isproductknowledge){
          downloadusingdir("${splitdir[0]}/$filedir");
        }
      }
    } else if (stringdata.length == 3) {
      //terdapat periode
      if (Utils().isinperiod(stringdata[2])) {
        if (ispricelist) {
          int idx = pricelistdir.indexOf(filedir);
          if(idx == -1){
            pricelistdir.add(filedir);
          }
        } else if (isproductknowledge) {
          int idx = listdir.indexOf(filedir);
          if(idx == -1){
            listdir.add(filedir);
          }
        } else if (ispromo){
          promodir.add("$filedir|${stringdata[2]}");
        }
        if (download) {
          if (ispricelist) {
            downloadusingdir(filedir);
          } else if (ispromo) {
            downloadusingdir(filedir);
          } else if (isproductknowledge){
            downloadusingdir("${splitdir[0]}/$filedir");
          }
        }
      }
    }
  }

  processfile(bool download) async {
    //download not using await because efficiency time for parallel download
    String branchuser = "";
    String warnauser = "";
    String areauser = "";
    var databranch = null;
    try {
      branchinfobox = await Hive.openBox("BranchInfoBox");
      databranch = await branchinfobox.get(await Utils().getParameterData("sales"));
      branchuser = databranch[0]['branch'];
      warnauser = databranch[0]['color'];
      areauser = databranch[0]['area'];
    // ignore: empty_catches
    } catch (e) {
      try {
      databranch = await branchinfobox.get(await Utils().getParameterData("sales"));
      branchuser = databranch[0]['branch'];
      warnauser = databranch[0]['color'];
      areauser = databranch[0]['area'];
      } catch (e) {
        print(e);
      }
    }
    branchinfobox.close();
    if (await File('$productdir/${activevendor.toLowerCase()}/$informasiconfig').exists() && databranch != null) {
      var res = await File('$productdir/${activevendor.toLowerCase()}/$informasiconfig').readAsString();
      var ls = const LineSplitter();
      var tlist = ls.convert(res);
      for (var i = 0; i < tlist.length; i++) {
        var undollar = tlist[i].split('\$');
        var unpipelined = undollar[0].split("|");
        if (unpipelined[0] == AppConfig().forall) {
          //untuk all cabang
          isthereanyperiod(undollar, download);
        } else if (unpipelined[0] == AppConfig().forbranch) {
          //untuk cabang tertentu
          for (var j = 1; j < unpipelined.length; j++) {
            if (unpipelined[j] == branchuser) {
              isthereanyperiod(undollar, download);
            }
          }
        } else if (unpipelined[0] == AppConfig().forcolor) {
          //untuk cabang dengan warna tertentu
          for (var j = 1; j < unpipelined.length; j++) {
            if (unpipelined[j] == warnauser) {
              isthereanyperiod(undollar, download);
            }
          }
        } else if (unpipelined[0] == AppConfig().forarea) {
          //untuk cabang dengan area tertentu
          for (var j = 1; j < unpipelined.length; j++) {
            if (unpipelined[j] == areauser) {
              isthereanyperiod(undollar, download);
            }
          }
        }
      }
      if (listdir.isEmpty) {
        listnode.clear();
        isSuccess.value = true;
      } else if (listdir.isNotEmpty) {
        await generateTreeinfoproduct(listdir);
        if (listnode.isNotEmpty) {
          treecontroller = TreeViewController();
          treecontroller!.treeData(listnode);
          datanodelength.value = listnode.length;
        }
      }
    } else {
      listnode.clear();
      isSuccess.value = true;
      datanodelength.value = listnode.length;
    }
  }

  downloadusingdir(String directoryfile) async {
    var pathh = directoryfile.split('/');
    var dir = "";
    for (var i = 0; i < pathh.length - 1; i++) {
      dir = "$dir/${pathh[i]}";
    }
    var fname = pathh[pathh.length - 1];
    await ApiClient().downloadfiles(dir, fname, activevendor);
  }

  handleselectedindexinformasi(int index) {
    indexSegmentinformasi.value = index;
    for (var i = 0; i < selectedsegmentinformasi.length; i++) {
      selectedsegmentinformasi[i] = false;
    }
    selectedsegmentinformasi[index] = true;
  }

  generateTreeinfoproduct(List<String> tlist) {
    listnode.clear();
    for (String temp in tlist) {
      // print(temp);
      var tsplit = temp.split("/");
      var head = TreeNodeData();
      for (var i = 0; i < tsplit.length; i++) {
        var str = tsplit[i];
        var tnode = TreeNodeData();
        if (head.name == "") {
          tnode = listnode.firstWhere((element) => element.name == str,
              orElse: () => TreeNodeData());
        } else {
          tnode = head.children.firstWhere(
              (p) => (p as TreeNodeData).name == str,
              orElse: () => TreeNodeData()) as TreeNodeData;
        }

        if (tnode.name == "") {
          tnode.name = str;
          if (i == tsplit.length - 1) {
            tnode.isFile = true;
            tnode.fullname = temp;
            tnode.extension =
                str.substring(str.lastIndexOf(".") + 1, str.length);
          }
          if (head.name == "") {
            listnode.add(tnode);
          } else {
            head.addChild(tnode);
          }
        }
        head = tnode;
      }
    }
    isSuccess.value = true;
  }

  handleselectedsegmentcategory(int index) {
    indexselectedsegmentcategory.value = index;
    for (var i = 0; i < selectedsegmentcategory.length; i++) {
      selectedsegmentcategory[i] = false;
    }
    selectedsegmentcategory[index] = true;
  }

  //for retur page
  Rx<TextEditingController> get tarikbarangfield => _returController.tarikbarangfield;
  Rx<TextEditingController> get tukarwarnafield => _returController.tukarwarnafield;
  Rx<TextEditingController> get gantikemasanfield => _returController.gantikemasanfield;
  Rx<TextEditingController> get servismebelfield => _returController.servismebelfield;
  Rx<TextEditingController> get gantibarangfield => _returController.gantibarangfield;
  Rx<TextEditingController> get produkpenggantifield => _returController.produkpenggantifield;
  RxList<ProductData> get selectedProducttarikbarang => _returController.selectedProducttarikbarang;
  RxList<ProductData> get selectedProductgantikemasan => _returController.selectedProductgantikemasan;
  RxList<ProductData> get selectedProductservismebel => _returController.selectedProductservismebel;
  RxList<ProductData> get selectedProductgantibarang => _returController.selectedProductgantibarang;
  RxList<ProductData> get selectedProductTukarWarna => _returController.selectedProductTukarWarna;
  RxList<ProductData> get selectedProductProdukPengganti => _returController.selectedProductProdukPengganti;
  RxList<TarikBarangModel> get listTarikBarang => _returController.listTarikBarang;
  RxList<TarikBarangModel> get listgantikemasan => _returController.listgantikemasan;
  RxList<TarikBarangModel> get listServisMebel => _returController.listServisMebel;
  RxList<TarikBarangModel> get listGantiBarang => _returController.listGantiBarang;
  RxList<TukarWarnaModel> get listTukarWarna => _returController.listTukarWarna;
  RxList<TarikBarangModel> get listProdukPengganti => _returController.listProdukPengganti;
  RxList<TarikBarangModel> get listitemforProdukPengganti => _returController.listitemforProdukPengganti;
  RxList get listSisa => _returController.listSisa;
  RxInt get indexSegment => _returController.indexSegment;
  RxList<bool> get selectedsegment => _returController.selectedsegment;
  RxBool get tukarwarnahorizontal => _returController.tukarwarnahorizontal;
  RxBool get tarikbaranghorizontal => _returController.tarikbaranghorizontal;
  RxBool get gantikemasanhorizontal => _returController.gantikemasanhorizontal;
  RxBool get servismebelhorizontal => _returController.servismebelhorizontal;
  RxBool get gantibaranghorizontal => _returController.gantibaranghorizontal;
  RxString get selectedKdProducttarikbarang => _returController.selectedKdProducttarikbarang;
  RxString get selectedKdProductgantikemasan => _returController.selectedKdProductgantikemasan;
  RxString get selectedKdProductservismebel => _returController.selectedKdProductservismebel;
  RxString get selectedKdProductgantibarang => _returController.selectedKdProductgantibarang;
  RxString get selectedKdProductTukarWarna => _returController.selectedKdProductTukarWarna;
  RxString get selectedKdProductProdukPengganti => _returController.selectedKdProductProdukPengganti;
  RxString get selectedAlasantb => _returController.selectedAlasantb;
  RxString get selectedAlasangk => _returController.selectedAlasangk;
  RxBool get isOverfow => _returController.isOverfow;
  RxList get listQtytb => _returController.listQtytb;
  RxList get listQtygk => _returController.listQtygk;
  RxList get listQtysm => _returController.listQtysm;
  RxList get listQtygb => _returController.listQtygb;
  RxList get listQtytw => _returController.listQtytw;
  RxList get listQtypp => _returController.listQtypp;

  handleProductSearchretur(String val,String actionType) async {
   await _returController.handleProductSearch(val, actionType);
  }

  handleEditItemRetur(var data, String actionType){
    _returController.handleEditItem(data, actionType);
  }

  handleDeleteItemRetur(var data, String from) {
    _returController.handleDeleteItemRetur(data, from);
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

  showProdukPengganti(BuildContext context) {
    _returController.showProdukPengganti(context);
  }

  showEditProdukPengganti(BuildContext context) {
    _returController.showEditProdukPengganti(context);
  }

}
