import 'dart:convert';
import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sfa_tools/controllers/laporan_controller.dart';
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
import '../models/customer.dart';
import '../models/detailproductdata.dart';
import '../models/productdata.dart';
import '../screens/taking_order_vendor/transaction/dialogdelete.dart';
import '../tools/service.dart';
import '../tools/utils.dart';

class PenjualanController extends GetxController
    with GetTickerProviderStateMixin {
  RxString selectedValue = "".obs;
  RxList<ProductData> selectedProduct = <ProductData>[].obs;
  RxList<ProductData> listProduct = <ProductData>[].obs;
  RxList<DropDownValueModel> listDropDown = <DropDownValueModel>[].obs;
  RxList<CartModel> cartList = <CartModel>[].obs;
  RxList<CartDetail> cartDetailList = <CartDetail>[].obs;
  // late SingleValueDropDownController cnt;
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
  late Box<List<Vendor>> vendorBox; 
  late Box<List<ShipToAddress>> listaddressbox; 
  late Box<Customer> customerBox; 
  late Box boxpostpenjualan;
  late Box boxreportpenjualan;
  final keycheckout = GlobalKey();

  getBox() async {
    try {
      vendorBox = await Hive.openBox<List<Vendor>>('vendorBox');
      listaddressbox = await Hive.openBox<List<ShipToAddress>>('shiptoBox');
      customerBox = await Hive.openBox<Customer>('customerBox');
      boxpostpenjualan =  await Hive.openBox('penjualanReportpostdata');
      boxreportpenjualan = await Hive.openBox('penjualanReport');
    } catch (e) {
      vendorBox = await Hive.openBox('vendorBox');
      listaddressbox = await Hive.openBox('shiptoBox');
      customerBox = await Hive.openBox('customerBox');
    }
  }

  getListItem() async {
    await getBox();

    //get salesid and custid data
    String salesid = await getParameterData("sales");
    String custid = await getParameterData("cust");
    if(custid != "01B05070012"){
      custid = "01B05070012";
    }
    
    //get customer data
    var dataToko = customerBox.get(custid);
    nmtoko.value = dataToko!.name;

    //get shippping address data
    var addressdata = listaddressbox.get(custid);
    if(addressdata == null || addressdata.isEmpty ){
      listAddress.add(ShipToAddress(code: dataToko.no, name: dataToko.name, address: dataToko.address, county: dataToko.county, City: dataToko.city , PostCode: ""));
    } else {
      listAddress.add(ShipToAddress(code: "", name: "Pilih Alamat Pengiriman", address: "Pilih Alamat Pengiriman", county: "", City: "", PostCode: ""));
      listAddress.add(ShipToAddress(code: "", name: dataToko.name, address: dataToko.address, county: dataToko.county, City: dataToko.city , PostCode: ""));
      listAddress.addAll(addressdata);
    }

    //get vendor data
    var datavendor = vendorBox.get("$salesid|$custid");
    vendorlist.clear();
    vendorlist.addAll(datavendor!);

    //get list product vendor
    var getVendorItem = await ApiClient().getData(vendorlist[0].baseApiUrl,"/setting/vendor/${vendorlist[0].prefix}");
    print(getVendorItem);
    var data = MasterItemVendor.fromJson(getVendorItem);
    for (var i = 0; i < data.items.length; i++) {
      listProduct.add(ProductData(data.items[i].code, data.items[i].name, [DetailProductData(data.items[i].uom.name, double.parse(data.items[i].price), data.items[i].uomId)]));
    }

    // vendorBox.get("")
    // listProduct.clear();
    // listProduct.add(ProductData('asc', _laporanController.dummyList[0],
    //     [DetailProductData('dos', 15000)]));
    // listProduct.add(ProductData('desc', _laporanController.dummyList[1], [
    //   DetailProductData('kaleng', 10000),
    //   DetailProductData('biji', 20000)
    // ]));
    // listProduct.add(ProductData('ccc', _laporanController.dummyList[2],
    //     [DetailProductData('inner plas', 25000)]));
    // listProduct.add(ProductData('acc', _laporanController.dummyList[3],
    //     [DetailProductData('biji', 30000), DetailProductData('dos', 35000)]));
    // listProduct.add(ProductData('cca', _laporanController.dummyList[4], [
    //   DetailProductData('dos', 50000),
    //   DetailProductData('inner plas', 100000),
    //   DetailProductData('biji', 120000)
    // ]));
    // listProduct.add(ProductData('cac', _laporanController.dummyList[5],
    //     [DetailProductData('dos', 200000)]));

    // for (var i = 0; i < listProduct.length; i++) {
    //   listDropDown.add(DropDownValueModel(
    //       value: listProduct[i].kdProduct, name: listProduct[i].nmProduct));
    // }
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

  String formatNumber(int number) {
    final NumberFormat numberFormat = NumberFormat('#,##0');
    return numberFormat.format(number);
  }

  fillCartDetail() {
    cartDetailList.clear();
    listAnimation.clear();
    for (var i = 0; i < cartList.length; i++) {
      if (cartDetailList.isEmpty) {
        List<CartModel> data = [
          CartModel(cartList[i].kdProduct, cartList[i].nmProduct,
              cartList[i].Qty, cartList[i].Satuan, cartList[i].hrgPerPieces)
        ];
        // if (cartList.length - 1 == i) {
        listAnimation.add(Tween<Offset>(
          begin: Offset((-0.9 - (i * 0.06)), 0),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 700),
          )..forward(),
          curve: Curves.easeInOut,
        )));
        // } else {
        //   listAnimation.add(Tween<Offset>(
        //     begin: Offset(0, 0),
        //     end: Offset(0, 0),
        //   ).animate(CurvedAnimation(
        //     parent: AnimationController(
        //       vsync: this,
        //       duration: Duration(milliseconds: 500),
        //     )..forward(),
        //     curve: Curves.easeInOut,
        //   )));
        // }

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
              listAnimation.add(Tween<Offset>(
                begin: Offset((-0.9 - (i * 0.06)), 0),
                end: const Offset(0, 0),
              ).animate(CurvedAnimation(
                parent: AnimationController(
                  vsync: this,
                  duration: const Duration(milliseconds: 700),
                )..forward(),
                curve: Curves.easeInOut,
              )));
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

  callcontroller(){
    final isControllerRegistered = GetInstance().isRegistered<LaporanController>();
    if(!isControllerRegistered){
      final LaporanController _controller =  Get.put(LaporanController());
      return _controller;
    } else {
      final LaporanController _controller = Get.find();
      return _controller;
    }
  }

  checkout() async {
    await getBox();
    String salesid = await getParameterData("sales");
    String cust = await getParameterData("cust");
    if(cust != "01B05070012"){
      cust = "01B05070012";
    }
    var _datapenjualan = await boxreportpenjualan.get("$salesid|$cust");
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
    String date = DateFormat('dd-MM-yyyy').format(now);
    String time = DateFormat('HH:mm').format(now);
    List<CartDetail> listcopy = [];
    listcopy.addAll(cartDetailList);
    await saveOrderToReport(noorder, date, time,  notes.value.text, listcopy,salesid,cust);
    saveOrderToApi(salesid, cust, notes.value.text, date, noorder);
    //return ReportPenjualanModel('pending',noorder,"penjualan" , date, time, listcopy, notes.value.text);
  }

  saveOrderToReport(String noorder,String date, String time, String notestext , List<CartDetail> dataList, String salesid, String cust) async {
    var dataPenjualanbox = await boxreportpenjualan.get("$salesid|$cust");
    List<ReportPenjualanModel> dataPenjualan = <ReportPenjualanModel>[];
    if (dataPenjualanbox == null){
      dataPenjualan.add(ReportPenjualanModel('pending',noorder,"penjualan" , date, time, dataList, notestext));
    } else {
      for (var i = 0; i < dataPenjualanbox.length; i++) {
        dataPenjualan.add(dataPenjualanbox[i]);
      }
      dataPenjualan.add(ReportPenjualanModel('pending',noorder,"penjualan" , date, time, dataList, notestext));
    }
    await boxreportpenjualan.put("$salesid|$cust",dataPenjualan);
  }

  saveOrderToApi(String salesid,String custid, String notestext, String orderdate, String noorder) async {
      print("saveOrderToApi");
      var idx = listAddress.indexWhere((element) => element.address == choosedAddress.value);
      List<Map<String, dynamic>> _data = [];
      for (var i = 0; i < cartDetailList.length; i++) {
        _data.add(
          {
            'extDocId' : noorder,
            'orderDate' : orderdate,
            'customerNo' : custid,
            'lineNo' : (i+1).toString(),
            'itemNo' : cartDetailList[i].kdProduct,
            'qty' : cartDetailList[i].itemOrder[0].Qty.toString(),
            'note' : notestext,
            'shipTo' : listAddress[idx].code,
            'salesPersonCode' : salesid
          }
        );
      }
      var listpostbox = await boxpostpenjualan.get("$salesid|$custid");
      List<PenjualanPostModel> listpost = <PenjualanPostModel>[];
      if (listpostbox == null){
          listpost.add(PenjualanPostModel(_data));
      } else {
        listpost.addAll(listpostbox);
        listpost.add(PenjualanPostModel(_data));
      }
      await boxpostpenjualan.put("$salesid|$custid",listpost);
      await postDataOrder(_data,salesid,custid);
  }

  Future<void> postDataOrder(List<Map<String, dynamic>> data ,String salesid,String custid ) async {
    String key = "$salesid|$custid";
    String noorder = data[0]['extDocId'];
    LaporanController controllerLaporan = callcontroller();
    var _datareportpenjualan = await boxreportpenjualan.get(key);
    var idx = _datareportpenjualan!.indexWhere((element) => element.id == noorder);
    final url = Uri.parse('https://mitra.tirtakencana.com/tangki-air-jerapah-dev/api/sales-orders/store');
    final request = http.MultipartRequest('POST', url);
      for (var i = 0; i < data.length; i++) {
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
          await boxpostpenjualan.delete(key);
          await boxreportpenjualan.delete(key);
          await boxreportpenjualan.put(key,_datareportpenjualan);
          print(responseString);

        } else {
          _datareportpenjualan[idx].condition = "error";
          await boxreportpenjualan.delete(key);
          await boxreportpenjualan.put(key,_datareportpenjualan);
        }
      } on SocketException {
          _datareportpenjualan[idx].condition = "pending";
          await boxreportpenjualan.delete(key);
          await boxreportpenjualan.put(key,_datareportpenjualan);
      } catch (e) {
          _datareportpenjualan[idx].condition = "pending";
          await boxreportpenjualan.delete(key);
          await boxreportpenjualan.put(key,_datareportpenjualan);
      } finally{
          controllerLaporan.listReportPenjualanShow.refresh();
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
        } else {
          return arrParameter[2];
        }
      }
    }
  }

}
