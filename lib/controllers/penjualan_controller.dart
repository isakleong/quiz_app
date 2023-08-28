import 'dart:convert';
import 'dart:io';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sfa_tools/controllers/laporan_controller.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/models/cartdetail.dart';
import 'package:sfa_tools/models/masteritemvendor.dart';
import 'package:sfa_tools/models/penjualanpostmodel.dart';
import 'package:sfa_tools/models/reportpenjualanmodel.dart';
import 'package:sfa_tools/models/shiptoaddress.dart';
import 'package:sfa_tools/models/vendor.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/dialogcheckout.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/dialogprodukserupa.dart';
import 'package:http/http.dart' as http;
import '../models/cartmodel.dart';
import '../models/detailproductdata.dart';
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
  Rx<TextEditingController> qty1 = TextEditingController().obs;
  Rx<TextEditingController> qty2 = TextEditingController().obs;
  Rx<TextEditingController> qty3 = TextEditingController().obs;
  RxString choosedAddress = "".obs;
  List<Animation<Offset>> listAnimation = <Animation<Offset>>[];
  List<Vendor> vendorlist = <Vendor>[];
  RxString nmtoko = "".obs;
  RxList<ShipToAddress> listAddress = <ShipToAddress>[].obs;
  Rx<TextEditingController> notes = TextEditingController().obs;
  //box
  late Box vendorBox; 
  late Box listaddressbox; 
  late Box customerBox; 
  late Box boxpostpenjualan;
  late Box boxreportpenjualan;
  late Box itemvendorbox;
  late Box statePenjualanbox;
  final keycheckout = GlobalKey();
  var idvendor = -1;
  var globalkeybox = "";
  RxBool needtorefresh = false.obs;

  savePenjualanState(dynamic data) async {
    if(!Hive.isBoxOpen('statepenjualan')) statePenjualanbox = await Hive.openBox('statepenjualan');
    await statePenjualanbox.delete(globalkeybox);
    await statePenjualanbox.put(globalkeybox, data);
    await statePenjualanbox.close();
  }

  getpenjualanstate() async {
    if(!Hive.isBoxOpen('statepenjualan')){
      statePenjualanbox = await Hive.openBox('statepenjualan');
    }
    var databox = await statePenjualanbox.get(globalkeybox);
    statePenjualanbox.close();
    if(databox != null){
      var datadecoded = json.decode(databox);
      var datacart = json.decode(datadecoded['cartlist']);
      for (var i = 0; i < datacart.length; i++) {
        CartModel datacartlist = CartModel.fromJson(datacart[i]);
        var idx = listProduct.indexWhere((element) => element.kdProduct == datacartlist.kdProduct);
        if(idx > -1 &&
         listProduct[idx].nmProduct == datacartlist.nmProduct &&
         listProduct[idx].detailProduct.indexWhere((element) => element.satuan == datacartlist.Satuan) != -1 &&
         listProduct[idx].detailProduct.indexWhere((element) => element.hrg == datacartlist.hrgPerPieces) != -1 ){

          cartList.add(datacartlist);
          listAnimation.add(Tween<Offset>(begin: Offset((-0.9 - (i * 0.06)), 0),end: const Offset(0, 0),
          ).animate(CurvedAnimation(parent: AnimationController(vsync: this,duration: const Duration(milliseconds: 700),)..forward(),curve: Curves.easeInOut,)));

        } else {
          return;
        }
      }
      var datacartdetail = json.decode(datadecoded['cartdetailist']);
      for (var i = 0; i < datacartdetail.length; i++) {
        CartDetail datacartdetaillist =  CartDetail.fromJson(datacartdetail[i]);
        cartDetailList.add(datacartdetaillist);
      }
    }
  }

  String formatDate(String dateTimeString) {
    final inputFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
    final outputFormat = DateFormat('dd-MM-yyyy');

    final dateTime = inputFormat.parse(dateTimeString);
    final formattedDate = outputFormat.format(dateTime);

    return formattedDate;
  }

  bool isDateNotToday(String dateTimeString) {
    final inputFormat = DateFormat('dd-MM-yyyy');
    final dateTime = inputFormat.parse(dateTimeString);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return dateTime.isBefore(today);
  }

  String formatNumber(int number) {
    final NumberFormat numberFormat = NumberFormat('#,##0');
    return numberFormat.format(number);
  }

  getBox() async {
    try {
      vendorBox = await Hive.openBox('vendorBox');
      listaddressbox = await Hive.openBox('shiptoBox');
      customerBox = await Hive.openBox('customerBox');
      boxpostpenjualan =  await Hive.openBox('penjualanReportpostdata');
      boxreportpenjualan = await Hive.openBox('penjualanReport');
      itemvendorbox = await Hive.openBox("itemVendorBox");
    } catch (e) {
    }
  }

  closebox() async{
    try {
      vendorBox.close();
      listaddressbox.close();
      customerBox.close();
      boxpostpenjualan.close();
      boxreportpenjualan.close();
      itemvendorbox.close();
    } catch (e) {
    }
  }

  getproduct({String? type}) async {
    try {
      var getVendorItem = await ApiClient().getData(vendorlist[idvendor].baseApiUrl,"/setting/vendor/${vendorlist[idvendor].prefix}",timeouttime: 10);
      var data = MasterItemVendor.fromJson(getVendorItem);
      // print(data);
      listProduct.clear();
      for (var i = 0; i < data.items.length; i++) {
        listProduct.add(ProductData(data.items[i].code, data.items[i].name, [DetailProductData(data.items[i].uom.name, double.parse(data.items[i].price), data.items[i].uomId)],DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now())));
      }
      itemvendorbox.delete(globalkeybox);
      itemvendorbox.put(globalkeybox,listProduct);
    } catch (e) {
      if(type == ""){
        needtorefresh.value = true;
      } else {
        var itemvendorhive = itemvendorbox.get(globalkeybox);
        listProduct.clear();
        for (var i = 0; i < itemvendorhive.length; i++) {
          listProduct.add(itemvendorhive[i]);
        }
      }
    }
  }

  getListItem() async {
    needtorefresh.value = false;
    await getBox();

    //get salesid and custid data
    String salesid = await getParameterData("sales");
    String custid = await getParameterData("cust");
    
    //get customer data
    if(!customerBox.isOpen) await getBox();
    var dataToko = customerBox.get(custid);
    nmtoko.value = dataToko!.name;

    //get shippping address data
    if(!listaddressbox.isOpen) await getBox();
    var addressdata = listaddressbox.get(custid);
    if(addressdata == null || addressdata.isEmpty ){
      choosedAddress.value = dataToko.address;
      listAddress.add(ShipToAddress(code: "", name: dataToko.name, address: dataToko.address, county: dataToko.county, City: dataToko.city , PostCode: ""));
    } else {
      listAddress.add(ShipToAddress(code: "", name: "Pilih Alamat Pengiriman", address: "Pilih Alamat Pengiriman", county: "", City: "", PostCode: ""));
      listAddress.add(ShipToAddress(code: "", name: dataToko.name, address: dataToko.address, county: dataToko.county, City: dataToko.city , PostCode: ""));
      for (var i = 0; i < addressdata.length; i++) {
        listAddress.add(addressdata[i]);
      }
    }

    //get vendor data
    if(!vendorBox.isOpen) await getBox();
    var datavendor = vendorBox.get("$salesid|$custid");
    vendorlist.clear();
    for (var i = 0; i < datavendor.length; i++) {
      vendorlist.add(datavendor[i]);
    }
    SplashscreenController _splashscreenController = callcontroller("splashscreencontroller");
    idvendor =  vendorlist.indexWhere((element) => element.name.toLowerCase() == _splashscreenController.selectedVendor.value.toLowerCase());
    globalkeybox = "$salesid|$custid|${vendorlist[idvendor].prefix}|${vendorlist[idvendor].baseApiUrl}";
    
    //get list product vendor
    try {
      var itemvendorhive = itemvendorbox.get(globalkeybox);
      if(itemvendorhive != null){
        listProduct.clear();
        for (var i = 0; i < itemvendorhive.length; i++) {
          listProduct.add(itemvendorhive[i]);
        }
        if(isDateNotToday(formatDate(listProduct[0].timestamp))){
          listProduct.clear();
          await getproduct(type: 'hivefilled');
        }
      } else {
        await getproduct();
      }
      await getpenjualanstate();
    } catch (e) {
      needtorefresh.value = true;
    }
    await closebox();
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
    cnt.value.clear();
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

  fillCartDetail() async {
    cartDetailList.clear();
    listAnimation.clear();
    for (var i = 0; i < cartList.length; i++) {
      if (cartDetailList.isEmpty) {
        List<CartModel> data = [CartModel(cartList[i].kdProduct, cartList[i].nmProduct,cartList[i].Qty, cartList[i].Satuan, cartList[i].hrgPerPieces)];
        listAnimation.add(Tween<Offset>(begin: Offset((-0.9 - (i * 0.06)), 0),end: const Offset(0, 0),
        ).animate(CurvedAnimation(parent: AnimationController(vsync: this,duration: const Duration(milliseconds: 700),)..forward(),curve: Curves.easeInOut,)));
        cartDetailList.add(CartDetail(cartList[i].kdProduct,cartList[i].nmProduct,data));
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
              cartDetailList[j].itemOrder.add(CartModel(cartList[i].kdProduct,cartList[i].nmProduct,cartList[i].Qty,cartList[i].Satuan,cartList[i].hrgPerPieces));
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
              List<CartModel> data = [CartModel(cartList[i].kdProduct,cartList[i].nmProduct,cartList[i].Qty,cartList[i].Satuan,cartList[i].hrgPerPieces)];
              listAnimation.add(Tween<Offset>(begin: Offset((-0.9 - (i * 0.06)), 0),end: const Offset(0, 0),
              ).animate(CurvedAnimation(parent: AnimationController(vsync: this,duration: const Duration(milliseconds: 700),)..forward(),curve: Curves.easeInOut)));
              cartDetailList.add(CartDetail(cartList[i].kdProduct, cartList[i].nmProduct, data));
            }
          }
        }
      }
    }
    if(cartList.isNotEmpty){
      convertalldatatojson();
    } else {
      if(!Hive.isBoxOpen('statepenjualan')) statePenjualanbox = await Hive.openBox('statepenjualan');
      await statePenjualanbox.delete(globalkeybox);
      await statePenjualanbox.close();
    }
  }

  convertalldatatojson(){
   
    List<Map<String, dynamic>> cartListmap = cartList.map((clist) {
      return {
        'kdProduct': clist.kdProduct,
        'nmProduct': clist.nmProduct,
        'Qty': clist.Qty,
        'Satuan': clist.Satuan,
        'hrgPerPieces': clist.hrgPerPieces
      };
    }).toList();

    String jsonStrclist = jsonEncode(cartListmap);
    print(jsonStrclist);

    List<Map<String, dynamic>> cartdetailListmap = cartDetailList.map((cdetaillist) {
      List _listitemorder = [];
      for (var i = 0; i < cdetaillist.itemOrder.length; i++) {
        _listitemorder.add({
          'kdProduct' : cdetaillist.itemOrder[i].kdProduct,
          'nmProduct' : cdetaillist.itemOrder[i].nmProduct,
          'Qty' : cdetaillist.itemOrder[i].Qty,
          'Satuan' : cdetaillist.itemOrder[i].Satuan,
          'hrgPerPieces' : cdetaillist.itemOrder[i].hrgPerPieces
        });
      }
      return {
        'kdProduct': cdetaillist.kdProduct,
        'nmProduct': cdetaillist.nmProduct,
        'itemOrder': _listitemorder,
      };
    }).toList();
    print(cartdetailListmap);

    String jsonStrcdetaillist = jsonEncode(cartdetailListmap);
    
    var convjson = {
      "cartlist" : jsonStrclist,
      "cartdetailist" : jsonStrcdetaillist
    };

    String convjsondatastring = jsonEncode(convjson);
    print(convjsondatastring);
    savePenjualanState(convjsondatastring);
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
    cnt.value.clear();
  }

  previewCheckOut() {
    Get.dialog(Dialog(
      key: keycheckout,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DialogCheckOut()));
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
          final LaporanController _controller =  Get.put(LaporanController());
          return _controller;
      } else {
          final LaporanController _controller = Get.find();
          return _controller;
      }
    } else if (controllername.toLowerCase() == "splashscreencontroller".toLowerCase()){
      final isControllerRegistered = GetInstance().isRegistered<SplashscreenController>();
      if(!isControllerRegistered){
          final SplashscreenController _controller =  Get.put(SplashscreenController());
          return _controller;
      } else {
          final SplashscreenController _controller = Get.find();
          return _controller;
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
    return isvalid;
  }

  checkout() async {
    await getBox();
    String salesid = await getParameterData("sales");
    String cust = await getParameterData("cust");
    // if(cust != "01B05070012"){
    //   cust = "01B05070012";
    // }
    var _datapenjualan = await boxreportpenjualan.get(globalkeybox);
    String inc = "000";
    var idx = 0;
    if(_datapenjualan != null)
    idx =  _datapenjualan!.isEmpty ? 0 : _datapenjualan.length;
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
    // print("length cartdetailist ${cartDetailList.length}");
    await closebox();
    await saveOrderToReport(noorder, date, time,  notes.value.text, listcopy,salesid,cust);
    saveOrderToApi(salesid, cust, notes.value.text, date, noorder,listcopy,alm);
    //return ReportPenjualanModel('pending',noorder,"penjualan" , date, time, listcopy, notes.value.text);
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

  saveOrderToApi(String salesid,String custid, String notestext, String orderdate, String noorder, List<CartDetail> _listdetail, String choosedAddressdata) async {
      await getBox();
      var idx = listAddress.indexWhere((element) => element.address == choosedAddressdata);
      List<Map<String, dynamic>> _data = [];
      for (var i = 0; i < _listdetail.length; i++) {
        _data.add(
          {
            'extDocId' : noorder,
            'orderDate' : orderdate,
            'customerNo' : custid,
            'lineNo' : (i+1).toString(),
            'itemNo' : _listdetail[i].kdProduct,
            'qty' : _listdetail[i].itemOrder[0].Qty.toString(),
            'note' : notestext,
            'shipTo' : listAddress[idx].code,
            'salesPersonCode' : salesid
          }
        );
      }
      var listpostbox = await boxpostpenjualan.get(globalkeybox);
      List<PenjualanPostModel> listpost = <PenjualanPostModel>[];
      if (listpostbox == null){
          listpost.add(PenjualanPostModel(_data));
      } else {
        for (var i = 0; i < listpostbox.length; i++) {
          listpost.add(listpostbox[i]);
        }
        listpost.add(PenjualanPostModel(_data));
      }
      await boxpostpenjualan.put(globalkeybox,listpost);
      await closebox();
      await postDataOrder(_data,salesid,custid,listpost);
  }

  Future<void> postDataOrder(List<Map<String, dynamic>> data ,String salesid,String custid ,List<PenjualanPostModel> listpostdata) async {
    await getBox();
    // print(data);
    String noorder = data[0]['extDocId'];
    LaporanController controllerLaporan = callcontroller("laporancontroller");
    var _datareportpenjualan = await boxreportpenjualan.get(globalkeybox);
    var idx = _datareportpenjualan!.indexWhere((element) => element.id == noorder);
    var idxpost = -1;
    for (var i = 0; i < listpostdata.length; i++) {
      if(listpostdata[i].dataList[0]['extDocId'] == noorder){
          idxpost = i;
          break;
      }
    }
    final url = Uri.parse('${vendorlist[idvendor].baseApiUrl}sales-orders/store');
    final request = http.MultipartRequest('POST', url);
      for (var i = 0; i < data.length; i++) {
        // print(data[i]['orderDate'].toString());
        request.fields['data[$i][extDocId]'] = data[i]['extDocId'];
        request.fields['data[$i][orderDate]'] = data[i]['orderDate'];
        request.fields['data[$i][customerNo]'] = data[i]['customerNo'];
        request.fields['data[$i][lineNo]'] = data[i]['lineNo'];
        request.fields['data[$i][itemNo]'] = data[i]['itemNo'];
        request.fields['data[$i][qty]'] = data[i]['qty'];
        request.fields['data[$i][note]'] = data[i]['note'];
        request.fields['data[$i][shipTo]'] = data[i]['shipTo'];
        request.fields['data[$i][salesPersonCode]'] = data[i]['salesPersonCode'];
      }try {
        final response = await request.send();
        final responseString = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          _datareportpenjualan[idx].condition = "success";
          listpostdata.removeAt(idxpost);
          await boxpostpenjualan.delete(globalkeybox);
          if(listpostdata.isNotEmpty) {
            await boxpostpenjualan.put(globalkeybox,listpostdata);
          }
          await boxreportpenjualan.delete(globalkeybox);
          await boxreportpenjualan.put(globalkeybox,_datareportpenjualan);
          // print(responseString);

        } else {
          _datareportpenjualan[idx].condition = "gagal";
          await boxreportpenjualan.delete(globalkeybox);
          await boxreportpenjualan.put(globalkeybox,_datareportpenjualan);
          // print(responseString);
        }
      } on SocketException {
          _datareportpenjualan[idx].condition = "pending";
          await boxreportpenjualan.delete(globalkeybox);
          await boxreportpenjualan.put(globalkeybox,_datareportpenjualan);
          // print("socketexception");
      } catch (e) {
          _datareportpenjualan[idx].condition = "pending";
          await boxreportpenjualan.delete(globalkeybox);
          await boxreportpenjualan.put(globalkeybox,_datareportpenjualan);
          // print(e.toString() + " abnormal ");
      }  finally{
          await closebox();
          controllerLaporan.getReportList();
      }
  }

  getParameterData(String type) async {
    //SalesID;CustID;LocCheckIn
    String parameter = await Utils().readParameter();
    if (parameter != "") {
      var arrParameter = parameter.split(';');
      for (int i = 0; i < arrParameter.length; i++) {
        if (i == 0 && type == "sales") {
          return arrParameter[i];
        } else if (i == 1 && type == "cust") {
          return arrParameter[i];
        } else if (type == "") {
          return arrParameter[i];
        }
      }
    }
  }

}
