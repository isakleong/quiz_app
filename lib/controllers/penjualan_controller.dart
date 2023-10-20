import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/controllers/laporan_controller.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/models/cartdetail.dart';
import 'package:sfa_tools/models/masteritemvendor.dart';
import 'package:sfa_tools/models/other_address_data.dart';
import 'package:sfa_tools/models/penjualanpostmodel.dart';
import 'package:sfa_tools/models/reportpenjualanmodel.dart';
import 'package:sfa_tools/models/shiptoaddress.dart';
import 'package:sfa_tools/models/vendor.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/dialogaddress.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/dialogcheckout.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/dialogprodukserupa.dart';
import 'package:http/http.dart' as http;
import 'package:showcaseview/showcaseview.dart';
import '../common/hivebox_vendor.dart';
import '../models/cartmodel.dart';
import '../models/detailproductdata.dart';
import '../models/loginmodel.dart';
import '../models/productdata.dart';
import '../screens/taking_order_vendor/transaction/dialogdelete.dart';
import '../tools/service.dart';
import '../tools/utils.dart';

class PenjualanController extends GetxController with GetTickerProviderStateMixin {
  RxString selectedValue = "".obs;
  RxList<ProductData> selectedProduct = <ProductData>[].obs;
  RxList<ProductData> listProduct = <ProductData>[].obs;
  RxList<DropDownValueModel> listDropDown = <DropDownValueModel>[].obs;
  RxList<CartModel> cartList = <CartModel>[].obs;
  RxList<CartDetail> cartDetailList = <CartDetail>[].obs;
  Rx<TextEditingController> cnt = TextEditingController().obs;
  RxList<int> listQty = [0,0,0,0,0,0,0,0].obs;
  RxString choosedAddress = "".obs;
  List<Animation<Offset>> listAnimation = <Animation<Offset>>[];
  List<Vendor> vendorlist = <Vendor>[];
  RxString nmtoko = "".obs;
  RxList<ShipToAddress> listAddress = <ShipToAddress>[].obs;
  Rx<TextEditingController> notes = TextEditingController().obs;
  RxString totalpiutang = ''.obs;
  RxString totaljatuhtempo = ''.obs;
  final keycheckout = GlobalKey();
  var idvendor = -1;
  var globalkeybox = "";
  RxBool needtorefresh = false.obs;
  String activevendor = "";
  RxString komisi = "".obs;
  Rx<TextEditingController> addressName = TextEditingController().obs;
  Rx<TextEditingController> receiverName = TextEditingController().obs;
  Rx<TextEditingController> phoneNum = TextEditingController().obs;
  Rx<TextEditingController> phoneNumSecond = TextEditingController().obs;
  Rx<TextEditingController> notesOtherAddress = TextEditingController().obs;
  OtherAddressData? dataOtherAddress;
  String hardcodeOtherAddress = 'Alamat Kiriman Langsung Customer';

  countKomisi(){
    var komisidata = 0.0;
    for (var i = 0; i < cartDetailList.length; i++) {
      for (var j = 0; j < cartDetailList[i].itemOrder.length; j++) {
        if( double.parse(cartDetailList[i].itemOrder[j].komisi) > 0 ){
            komisidata = komisidata + (cartDetailList[i].itemOrder[j].hrgPerPieces *  cartDetailList[i].itemOrder[j].Qty) * (double.parse(cartDetailList[i].itemOrder[j].komisi) / 100);
        }
      }
    }
    komisi.value = komisidata.toString();
  }

  savePenjualanState(dynamic data, {String? morekey}) async {
    if(!Hive.isBoxOpen('statepenjualan')) statePenjualanbox = await Hive.openBox('statepenjualan');
    if(morekey != "" && morekey != null){
    await statePenjualanbox.delete(globalkeybox+morekey!);
    await statePenjualanbox.put(globalkeybox+morekey, data);
    } else {
    await statePenjualanbox.delete(globalkeybox);
    await statePenjualanbox.put(globalkeybox, data);
    }
    await statePenjualanbox.close();
  }

  deletestate() async {
    if(!Hive.isBoxOpen('statepenjualan')) statePenjualanbox = await Hive.openBox('statepenjualan');
    await statePenjualanbox.delete(globalkeybox);
    await statePenjualanbox.delete("${globalkeybox}addr");
    await statePenjualanbox.close();
    dataOtherAddress = null;
  }

  getpenjualanstate() async {
    if(!Hive.isBoxOpen('statepenjualan')){
      statePenjualanbox = await Hive.openBox('statepenjualan');
    }
    var databox = await statePenjualanbox.get(globalkeybox);
    var dataAlamat = await statePenjualanbox.get("${globalkeybox}addr");
    if(dataAlamat != null){
      dataAlamat = jsonDecode(dataAlamat);
      print(dataAlamat);
      dataOtherAddress = OtherAddressData(dataAlamat['address'], dataAlamat['nama'], dataAlamat['hp'], dataAlamat['hplain'], dataAlamat['note']);
      addressName.value.text = dataAlamat['address'];
      receiverName.value.text = dataAlamat['nama'];
      phoneNum.value.text = dataAlamat['hp'];
      phoneNumSecond.value.text = dataAlamat['hplain'];
      notesOtherAddress.value.text = dataAlamat['note'];
    }
    statePenjualanbox.close();
    if(databox != null){
      var datadecoded = json.decode(databox);
      for (var i = 0; i < datadecoded.length; i++) {
        CartModel datacartlist = CartModel.fromJson(datadecoded[i]);
        var idx = listProduct.indexWhere((element) => element.kdProduct == datacartlist.kdProduct);
        if(idx > -1 &&
         listProduct[idx].nmProduct == datacartlist.nmProduct &&
         listProduct[idx].detailProduct.indexWhere((element) => element.satuan == datacartlist.Satuan) != -1 &&
         listProduct[idx].detailProduct.indexWhere((element) => element.hrg == datacartlist.hrgPerPieces) != -1 ){
          cartList.add(datacartlist);
        } else {
          cartList.clear();
          return;
        }
      }
      fillCartDetail(type: 'loadstate');
    }
  }

  getBox() async {
    try {
      vendorBox = await Hive.openBox('vendorBox');
      shiptobox = await Hive.openBox('shiptoBox');
      customerBox = await Hive.openBox('customerBox');
      boxpostpenjualan =  await Hive.openBox('penjualanReportpostdata');
      boxreportpenjualan = await Hive.openBox('penjualanReport');
      itemvendorbox = await Hive.openBox("itemVendorBox");
      masteritemvendorbox = await Hive.openBox("masteritemvendorbox");
      tokenbox = await Hive.openBox('tokenbox');
    // ignore: empty_catches
    } catch (e) {
    }
  }

  closebox() async{
    try {
      vendorBox.close();
      shiptobox.close();
      customerBox.close();
      boxpostpenjualan.close();
      boxreportpenjualan.close();
      itemvendorbox.close();
      masteritemvendorbox.close();
      tokenbox.close();
    // ignore: empty_catches
    } catch (e) {
    }
  }

  gettoken() async {
      String salesId = await Utils().getParameterData('sales');
      var tokenboxdata = await tokenbox.get(salesId);
      var dectoken = Utils().decrypt(tokenboxdata);
      return dectoken;
  }
  
  getproduct({String? type, String? custid}) async {
    try {
      bool isdev = false;
      var params =  {
        // ignore: dead_code
        'customerNo': isdev ? "10A01010007" : custid,
      };
      var connTest = await ApiClient().checkConnection(jenis: "vendor");
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      String urlAPI = arrConnTest[1];

      String urls = vendorlist[idvendor].baseApiUrl;
      if(urlAPI == AppConfig.baseUrlVendorLocal){
        urlAPI = Utils().changeUrl(urls);
      } else {
        urlAPI = urls;
      }

      if (!isConnected){
        if(type == null){
          needtorefresh.value = true;
        } else {
          var itemvendorhive = itemvendorbox.get(globalkeybox);
          listProduct.clear();
          for (var i = 0; i < itemvendorhive.length; i++) {
            listProduct.add(itemvendorhive[i]);
          }
        }
        return;
      }

      var dectoken = await gettoken();
      var getVendorItem = await ApiClient().postData(urlAPI,"setting/vendor-info",jsonEncode(params), Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",'Authorization': 'Bearer $dectoken','Accept': 'application/json'
            }
          ));
          
      // print("${urlAPI}setting/vendor-info");
      masteritemvendorbox.delete(globalkeybox);
      masteritemvendorbox.put(globalkeybox, getVendorItem);
      var data = MasterItemVendor.fromJson(getVendorItem);
      listProduct.clear();
      totalpiutang.value = data.receivables!;
      totaljatuhtempo.value = data.overdue_invoices!;
      for (var i = 0; i < data.items!.length; i++) {
        List<DetailProductData> listdetail = [];
        for (var j = 0; j < data.items![i].uoms!.length; j++) {
          listdetail.add(DetailProductData(data.items![i].uoms![j].name!, double.parse(data.items![i].price!), data.items![i].uoms![j].id!, data.items![i].komisi!));
        }
        listProduct.add(ProductData(data.items![i].code!, "${data.items![i].merk!} ${data.items![i].volume!} ${data.items![i].color!} ${data.items![i].desc!}", listdetail,DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()),data.items![i].id!));
      }
      itemvendorbox.delete(globalkeybox);
      itemvendorbox.put(globalkeybox,listProduct);
    } on SocketException {
      if(type == null){
        needtorefresh.value = true;
      } else {
        var itemvendorhive = itemvendorbox.get(globalkeybox);
        listProduct.clear();
        for (var i = 0; i < itemvendorhive.length; i++) {
          listProduct.add(itemvendorhive[i]);
        }
      }
    }catch (e) {
      // print(e.toString());
      if(type == null){
        needtorefresh.value = true;
      } else {
        var itemvendorhive = itemvendorbox.get(globalkeybox);
        listProduct.clear();
        for (var i = 0; i < itemvendorhive.length; i++) {
          listProduct.add(itemvendorhive[i]);
        }
      }
      loginapivendor();
    }
  }

  getListItem() async {
    needtorefresh.value = false;
    await getBox();

    //get salesid and custid data
    String salesid = await Utils().getParameterData("sales");
    String custid = await Utils().getParameterData("cust");
    
    //get customer data
    if(!customerBox.isOpen) await getBox();
    var dataToko = customerBox.get(custid);
    nmtoko.value = dataToko!.name;

    //get shippping address data
    if(!shiptobox.isOpen) await getBox();
    var addressdata = shiptobox.get(custid);
    if(addressdata == null || addressdata.isEmpty ){
      choosedAddress.value = dataToko.address;
      listAddress.add(ShipToAddress(code: "", name: dataToko.name, address: dataToko.address, county: dataToko.county, City: dataToko.city , PostCode: ""));
      listAddress.add(ShipToAddress(code: "AL", name: hardcodeOtherAddress, address: hardcodeOtherAddress, county: "", PostCode: "", City: ""));
    } else {
      listAddress.add(ShipToAddress(code: "", name: "Pilih Alamat Pengiriman", address: "Pilih Alamat Pengiriman", county: "", City: "", PostCode: ""));
      listAddress.add(ShipToAddress(code: "", name: dataToko.name, address: dataToko.address, county: dataToko.county, City: dataToko.city , PostCode: ""));
      for (var i = 0; i < addressdata.length; i++) {
        listAddress.add(addressdata[i]);
      }
      listAddress.add(ShipToAddress(code: "AL", name: hardcodeOtherAddress, address: hardcodeOtherAddress, county: "", PostCode: "", City: ""));
    }
    try {
    //get vendor data
      if(!vendorBox.isOpen) await getBox();
      var datavendor = vendorBox.get("$salesid|$custid");
      vendorlist.clear();
      for (var i = 0; i < datavendor.length; i++) {
        vendorlist.add(datavendor[i]);
      }
      idvendor =  vendorlist.indexWhere((element) => element.name.toLowerCase() == activevendor);
      globalkeybox = "$salesid|$custid|${vendorlist[idvendor].prefix}|${vendorlist[idvendor].baseApiUrl}";
      try {
        getpiutangfrom('piutangbox');
      } catch (e) {
        totalpiutang.value = "0";
        totaljatuhtempo.value = "0";
      }

      var itemvendorhive = itemvendorbox.get(globalkeybox);
      if(itemvendorhive != null){
        listProduct.clear();
        for (var i = 0; i < itemvendorhive.length; i++) {
          listProduct.add(itemvendorhive[i]);
        }
        /* unused fetch data on home
        if(Utils().isDateNotToday(Utils().formatDate(listProduct[0].timestamp))){
          listProduct.clear();
          await getproduct(type: 'hivefilled',custid: custid);
        }*/
      } 
      /* unused fetch data on home
      else {
        await getproduct(custid: custid);
      }*/
    await getpenjualanstate();
    } catch (e) {
      needtorefresh.value = true;
    }
    await closebox();
  }

  getpiutangfrom(String boxname) async {
    if(boxname == 'masteritemvendorbox'){
      var databox = masteritemvendorbox.get(globalkeybox);
      if (databox != null){
        var dataconv = MasterItemVendor.fromJson(databox);
        totalpiutang.value = dataconv.receivables!;
        totaljatuhtempo.value = dataconv.overdue_invoices!;
      }
    } else {
      await Utils().managePiutangBox('open');
      var databox = piutangBox.get(globalkeybox);
      if (databox != null){
        var dataconv = jsonDecode(databox);
        totalpiutang.value = dataconv['receivables'].toString();
        totaljatuhtempo.value = dataconv['overdueInvoices'].toString();
      } else {
        totalpiutang.value = "0";
        totaljatuhtempo.value = "0";
      }
      await Utils().managePiutangBox('close');
    }
  }

  addToCart(){
    //print(selectedProduct.value[0].detailProduct[0].hrg);
    for (var i = 0; i < selectedProduct[0].detailProduct.length; i++) {
      if (listQty[i] != 0) {
        cartList.add(CartModel(
            selectedProduct[0].kdProduct,
            selectedProduct[0].nmProduct,
            listQty[i],
            selectedProduct[0].detailProduct[i].satuan,
            selectedProduct[0].detailProduct[i].hrg,
            selectedProduct[0].detailProduct[i].id,
            selectedProduct[0].id,
            selectedProduct[0].detailProduct[i].komisi
            ));
      }
    }
    for (var i = 0; i < listQty.length; i++) {
      listQty[i] = 0;
    }
    selectedValue.value = "";
    selectedProduct.clear();
    cnt.value.clear();
    //print(cartList.length);
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
      total = total + (double.parse(cartList[i].Qty.toString()) * cartList[i].hrgPerPieces);
    }
    return total.toInt();
  }

  fillCartDetail({String? type}) async {
    cartDetailList.clear();
    listAnimation.clear();
    for (var i = 0; i < cartList.length; i++) {
      if (cartDetailList.isEmpty) {
        List<CartModel> data = [CartModel(cartList[i].kdProduct, cartList[i].nmProduct,cartList[i].Qty, cartList[i].Satuan, cartList[i].hrgPerPieces, cartList[i].iduom,cartList[i].iditem,cartList[i].komisi)];
        listAnimation.add(Tween<Offset>(begin: Offset((-0.9 - (i * 0.06)), 0),end: const Offset(0, 0)).animate(CurvedAnimation(parent: AnimationController(vsync: this,duration: const Duration(milliseconds: 700))..forward(),curve: Curves.easeInOut)));
        //print("ini item id yang dimasukkan ${cartList[i].iditem}");
        cartDetailList.add(CartDetail(cartList[i].kdProduct,cartList[i].nmProduct,data,cartList[i].iditem));
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
              cartDetailList[j].itemOrder.add(CartModel(cartList[i].kdProduct,cartList[i].nmProduct,cartList[i].Qty,cartList[i].Satuan,cartList[i].hrgPerPieces, cartList[i].iduom,cartList[i].iditem,cartList[i].komisi));
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
              List<CartModel> data = [CartModel(cartList[i].kdProduct,cartList[i].nmProduct,cartList[i].Qty,cartList[i].Satuan,cartList[i].hrgPerPieces, cartList[i].iduom,cartList[i].iditem,cartList[i].komisi)];
              listAnimation.add(Tween<Offset>(begin: Offset((-0.9 - (i * 0.06)), 0),end: const Offset(0, 0)).animate(CurvedAnimation(parent: AnimationController(vsync: this,duration: const Duration(milliseconds: 700))..forward(),curve: Curves.easeInOut)));
              cartDetailList.add(CartDetail(cartList[i].kdProduct, cartList[i].nmProduct, data, cartList[i].iditem));
              //print("ini item id yang dimasukkan ${cartList[i].iditem}");
            }
          }
        }
      }
    }
    if(type == null){ 
      //print("here");
      if(cartList.isNotEmpty){
        convertalldatatojson();
      } else {
        deletestate();
      }
    }
  }

  convertalldatatojson({String? type}){
    if(type == "" || type == null){
      //save input item user
      List<Map<String, dynamic>> cartListmap = cartList.map((clist) {
        return {
          'kdProduct': clist.kdProduct,
          'nmProduct': clist.nmProduct,
          'Qty': clist.Qty,
          'Satuan': clist.Satuan,
          'hrgPerPieces': clist.hrgPerPieces,
          'iduom' : clist.iduom,
          'iditem' : clist.iditem,
          'komisi' : clist.komisi
        };
      }).toList();
      String jsonStrclist = jsonEncode(cartListmap);
      savePenjualanState(jsonStrclist);
    } else if (type == "saveAddress"){
      //save input alamat lain
      var dataAlamat = {
        "address" : dataOtherAddress!.alamatPenerima,
        "nama" : dataOtherAddress!.namaPenerima,
        "hp" : dataOtherAddress!.NomorHp,
        "hplain" : dataOtherAddress!.NomorHpOthers,
        "note" : dataOtherAddress!.notesOthers
      };
      String jsonOtherAddress = jsonEncode(dataAlamat);
      savePenjualanState(jsonOtherAddress, morekey: "addr");
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
    for (var i = 0; i < listProduct.length; i++) {
      if (listProduct[i].kdProduct == kdProduct) {
        list.add(listProduct[i]);
        selectedProduct.value = list;
      }
    }
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
    listQty.clear();
    for (var i = 0; i < 10; i++) {
      listQty.add(0);
    }
    for (var k = 0; k < listProduct.length; k++) {
      if (listProduct[k].kdProduct == data.kdProduct) {
        for (var i = 0; i < data.itemOrder.length; i++) {
          for (var j = 0; j < listProduct[k].detailProduct.length; j++) {
            if (listProduct[k].detailProduct[j].satuan == data.itemOrder[i].Satuan) {
              listQty[j] = data.itemOrder[i].Qty;
            }
          }
        }
      }
    }
    getDetailProduct(data.kdProduct);
  }

  handleProductSearchButton(String val) async {
    selectedValue.value = val;
    listQty.clear();
    for (var k = 0; k < 10; k++) {
      listQty.add(0);
    }
    if (cartList.isNotEmpty && cartList.any((data) => data.kdProduct == val)) {
      for (var i = 0; i < cartDetailList.length; i++) {
        if (cartDetailList[i].kdProduct == val) {
          handleEditItem(cartDetailList[i]);
        }
      }
    } else {
      await getDetailProduct(val);
    }
    cnt.value.clear();
  }

  previewCheckOut() async {
    await countKomisi();
    if(dataOtherAddress != null){
      choosedAddress.value = hardcodeOtherAddress;
    } else if (choosedAddress.value == hardcodeOtherAddress && dataOtherAddress == null){
      choosedAddress.value = "";
    }
    Get.dialog(Dialog(
      key: keycheckout,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: ShowCaseWidget(
          builder: Builder(builder: (_) => DialogCheckOut()),
          )));
  }

  showDialogAddOtherAddress(){
    try {
      Navigator.pop(keycheckout.currentContext!);
    // ignore: empty_catches
    } catch (e) {
      
    }
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogAddress()));
  }

  showProdukSerupa(CartDetail data) {
    Get.dialog(Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: DialogProdukSerupa()));
  }

  callcontroller(String controllername){
    if(controllername.toLowerCase() == "LaporanController".toLowerCase()){
      final isControllerRegistered = GetInstance().isRegistered<LaporanController>();
      if(!isControllerRegistered){
          final LaporanController controller =  Get.put(LaporanController());
          return controller;
      } else {
          final LaporanController controller = Get.find();
          return controller;
      }
    } else if (controllername.toLowerCase() == "splashscreencontroller".toLowerCase()){
      final isControllerRegistered = GetInstance().isRegistered<SplashscreenController>();
      if(!isControllerRegistered){
          final SplashscreenController controller =  Get.put(SplashscreenController());
          return controller;
      } else {
          final SplashscreenController controller = Get.find();
          return controller;
      }    
    }
  }

  cekvalidcheckout(){
    bool isvalid = false;
    var idx = listAddress.indexWhere((element) => element.address == choosedAddress.value);
    if (idx != -1) {
      isvalid = true;
    } 
    if (listAddress.length > 1 && idx == 0){
      isvalid = false;
    }
    if(listAddress.length == 1){
      isvalid = true;
      choosedAddress.value = listAddress[0].address;
    }
    return isvalid;
  }

  checkout() async {
    await getBox();
    String salesid = await Utils().getParameterData("sales");
    String cust = await Utils().getParameterData("cust");
    var datapenjualan = await boxreportpenjualan.get(globalkeybox);
    String inc = "000";
    var idx = 0;
    if(datapenjualan != null) {
      idx =  datapenjualan!.isEmpty ? 0 : datapenjualan.length;
      if(idx > 0){
        idx = 0;
        for (var i = 0; i < datapenjualan.length; i++) {
          if(!Utils().isDateNotToday(Utils().formatDate(datapenjualan[i].tanggal))){
            idx = idx + 1;
          }
        }
      }
    }
    idx = idx + 1;
    if (idx < 10){
      inc = "00$idx";
    } else if (idx < 100 && idx > 9){
      inc = "0$idx";
    } else {
      inc = "$idx";
    }
    DateTime now = DateTime.now();
    String noorder = "GO-$salesid-${DateFormat('yyMMddHHmm').format(now)}-$inc";
    String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
    String time = DateFormat('HH:mm').format(now);
    List<CartDetail> listcopy = [];
    listcopy.addAll(cartDetailList);
    String alm = choosedAddress.value;
    await closebox();
    await saveOrderToReport(noorder, date, time,  notes.value.text, listcopy,salesid,cust);
    saveOrderToApi(salesid, cust, notes.value.text, date, noorder,listcopy,alm);
  }

  saveOrderToReport(String noorder,String date, String time, String notestext , List<CartDetail> dataList, String salesid, String cust) async {
    await getBox();
    var dataPenjualanbox = await boxreportpenjualan.get(globalkeybox);
    List<ReportPenjualanModel> dataPenjualan = <ReportPenjualanModel>[];
    if (dataPenjualanbox == null){
      dataPenjualan.add(ReportPenjualanModel('pending',noorder,"penjualan" , date, time, dataList, notestext));
    } else {
      for (var i = 0; i < dataPenjualanbox.length; i++) {
        dataPenjualan.add(dataPenjualanbox[i]);
      }
      dataPenjualan.add(ReportPenjualanModel('pending',noorder,"penjualan" , date, time, dataList, notestext));
    }
    await boxreportpenjualan.put(globalkeybox,dataPenjualan);
    await closebox();
  }

  saveOrderToApi(String salesid,String custid, String notestext, String orderdate, String noorder, List<CartDetail> listdetail, String choosedAddressdata) async {
      await getBox();
      var idx = listAddress.indexWhere((element) => element.address == choosedAddressdata);
      // print("ini isi element ${listAddress[0].address} ini isi choosed $choosedAddressdata");
      List<Map<String, dynamic>> data = [];
      var inc = 1;
      for (var i = 0; i < listdetail.length; i++) {
        for (var k = 0; k < listdetail[i].itemOrder.length; k++) {
          data.add(
            {
              'extDocId' : noorder,
              'orderDate' : orderdate,
              'customerNo' : custid,
              'lineNo' : inc.toString(),
              'itemId' : listdetail[i].id,
              'uomId' : listdetail[i].itemOrder[k].iduom,
              'qty' : listdetail[i].itemOrder[k].Qty.toString(),
              'note' : notestext,
              'shipTo' : listAddress[idx].code,
              'salesPersonCode' : salesid,
              'komisi' : listdetail[i].itemOrder[k].komisi
            }
          );
          inc++;
        }
      }
      var listpostbox = await boxpostpenjualan.get(globalkeybox);
      List<PenjualanPostModel> listpost = <PenjualanPostModel>[];
      if (listpostbox == null){
          listpost.add(PenjualanPostModel(data));
      } else {
        for (var i = 0; i < listpostbox.length; i++) {
          listpost.add(listpostbox[i]);
        }
        listpost.add(PenjualanPostModel(data));
      }
      await boxpostpenjualan.delete(globalkeybox);
      await boxpostpenjualan.put(globalkeybox,listpost);
      await closebox();
      await postDataOrder(data,salesid,custid,listpost);
  }

  Future<void> postDataOrder(List<Map<String, dynamic>> data ,String salesid,String custid ,List<PenjualanPostModel> listpostdata) async {
      await getBox();
      String noorder = data[0]['extDocId'];
      LaporanController controllerLaporan = callcontroller("laporancontroller");
      var datareportpenjualan = await boxreportpenjualan.get(globalkeybox);
      var idx = datareportpenjualan!.indexWhere((element) => element.id == noorder);
      var idxpost = -1;
      for (var i = 0; i < listpostdata.length; i++) {
        if(listpostdata[i].dataList[0]['extDocId'] == noorder){
            idxpost = i;
            break;
        }
      }
      var dectoken = await gettoken();
      
      var connTest = await ApiClient().checkConnection(jenis: "vendor");
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      String urlAPI = arrConnTest[1];

      if(!isConnected){
          datareportpenjualan[idx].condition = "pending";
          await boxreportpenjualan.delete(globalkeybox);
          await boxreportpenjualan.put(globalkeybox,datareportpenjualan);
          await closebox();
          controllerLaporan.getReportList(true);
          return;
      }

      String urls = vendorlist[idvendor].baseApiUrl;
      if(urlAPI == AppConfig.baseUrlVendorLocal){
        urlAPI = Utils().changeUrl(urls);
      } else {
        urlAPI = urls;
      }

      final url = Uri.parse('${urlAPI}sales-orders/store');
      // print("${urlAPI}sales-orders/store");
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $dectoken',
      });

      for (var i = 0; i < data.length; i++) {
        request.fields['data[$i][extDocId]'] = data[i]['extDocId'];
        request.fields['data[$i][orderDate]'] = data[i]['orderDate'];
        request.fields['data[$i][customerNo]'] = data[i]['customerNo'];
        request.fields['data[$i][lineNo]'] = data[i]['lineNo'];
        request.fields['data[$i][itemId]'] = data[i]['itemId'];
        request.fields['data[$i][uomId]'] = data[i]['uomId'];
        request.fields['data[$i][qty]'] = data[i]['qty'];
        request.fields['data[$i][note]'] = data[i]['note'];
        request.fields['data[$i][shipTo]'] = data[i]['shipTo'];
        request.fields['data[$i][salesPersonCode]'] = data[i]['salesPersonCode'];
        request.fields['data[$i][komisi]'] = data[i]['komisi'];
      }
      
      try {
        final response = await request.send();
        final responseString = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(responseString);
          if(jsonResponse["success"] == true){
            if(jsonResponse["data"][0]["success"] == true){
                datareportpenjualan[idx].condition = "success";
                listpostdata.removeAt(idxpost);
                await boxpostpenjualan.delete(globalkeybox);
                if(listpostdata.isNotEmpty) {
                  await boxpostpenjualan.put(globalkeybox,listpostdata);
                }
                await boxreportpenjualan.delete(globalkeybox);
                await boxreportpenjualan.put(globalkeybox,datareportpenjualan);
            } else {
              var flag = 0;
                for (var i = 0; i < jsonResponse["data"][0]["errors"].length; i++) {
                  if(jsonResponse["data"][0]["errors"][i]['code'] == AppConfig().orderalreadyexistvendor){
                      datareportpenjualan[idx].condition = "success";
                      listpostdata.removeAt(idxpost);
                      await boxpostpenjualan.delete(globalkeybox);
                      if(listpostdata.isNotEmpty) {
                        await boxpostpenjualan.put(globalkeybox,listpostdata);
                      }
                      await boxreportpenjualan.delete(globalkeybox);
                      await boxreportpenjualan.put(globalkeybox,datareportpenjualan);
                      flag = 1;
                  }
                }
                if(flag == 0){
                  datareportpenjualan[idx].condition = "pending";
                  await boxreportpenjualan.delete(globalkeybox);
                  await boxreportpenjualan.put(globalkeybox,datareportpenjualan);
                }
            }
          } else {
            datareportpenjualan[idx].condition = "pending";
            await boxreportpenjualan.delete(globalkeybox);
            await boxreportpenjualan.put(globalkeybox,datareportpenjualan);
          }
        } else {
          var jsonResponse = jsonDecode(responseString);
          try {
            if (jsonResponse["code"] == "300"){
              await loginapivendor();
            }
          } finally{
            datareportpenjualan[idx].condition = "pending";
            await boxreportpenjualan.delete(globalkeybox);
            await boxreportpenjualan.put(globalkeybox,datareportpenjualan);
          }
        }
      } on SocketException {
          datareportpenjualan[idx].condition = "pending";
          await boxreportpenjualan.delete(globalkeybox);
          await boxreportpenjualan.put(globalkeybox,datareportpenjualan);
      } catch (e) {
          datareportpenjualan[idx].condition = "pending";
          await boxreportpenjualan.delete(globalkeybox);
          await boxreportpenjualan.put(globalkeybox,datareportpenjualan);
      }  finally{
          await closebox();
          controllerLaporan.getReportList(true);
      }
  }

  loginapivendor() async {
    try {
      var connTest = await ApiClient().checkConnection(jenis: "vendor");
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      String urlAPI = arrConnTest[1];

      if(!isConnected){
          return;
      }

      String salesiddata = await Utils().getParameterData("sales");
      String encparam = Utils().encryptsalescodeforvendor(salesiddata);
      var params = {
        "username" : encparam
      };
      var result = await ApiClient().postData(urlAPI,"${AppConfig.apiurlvendorpath}/api/login",
            params,
            Options(headers: {HttpHeaders.contentTypeHeader: "application/json"}));
          // print("$urlAPI${AppConfig.apiurlvendorpath}/api/login");
      var dataresp = LoginResponse.fromJson(result);
      if(!tokenbox.isOpen){
        tokenbox = await Hive.openBox('tokenbox');
      }
      tokenbox.delete(salesiddata);
      tokenbox.put(salesiddata, dataresp.data!.token);
      tokenbox.close();
    // ignore: empty_catches
    } catch (e) {
      
    }
  }

  addOtherAddressData(){
    dataOtherAddress = OtherAddressData(addressName.value.text.toString(), receiverName.value.text.toString(), phoneNum.value.text.toString(), phoneNumSecond.value.text.toString(), notesOtherAddress.value.text.toString());
    convertalldatatojson(type: "saveAddress");
  }

}
