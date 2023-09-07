import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/app_config.dart';
import '../../../controllers/taking_order_vendor_controller.dart';

class Shoppingcart extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  Shoppingcart({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Container(
        width: 0.9 * width,
        decoration: BoxDecoration(
            border: Border.all(color: AppConfig.mainCyan, width: 2),
            borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_mosaic_rounded,
                      color: AppConfig.mainCyan,
                      size: 12.sp,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextView(
                      headings: 'H4',
                      maxLines: 1,
                      fontSize: 10.sp,
                      textAlign: TextAlign.left,
                      text: _takingOrderVendorController
                          .selectedProduct[0].nmProduct,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_takingOrderVendorController.cartDetailList.isNotEmpty) {
                        if (_takingOrderVendorController.cartList.any((data) => data.kdProduct == _takingOrderVendorController.selectedProduct[0].kdProduct)) {
                          _takingOrderVendorController.updateCart();
                        } else {
                          _takingOrderVendorController.addToCart();
                        }
                      } else {
                        _takingOrderVendorController.addToCart();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.mainCyan,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.only(
                        left: 10.sp,
                        right: 10.sp,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          size: 12.sp,
                        ),
                        const SizedBox(
                            width:
                                8), // Add some space between the icon and text
                        TextView(
                          text: _takingOrderVendorController.cartList.isEmpty
                              ? "Tambah"
                              : _takingOrderVendorController.cartList.any(
                                      (data) =>
                                          data.kdProduct ==
                                          _takingOrderVendorController
                                              .selectedProduct[0].kdProduct)
                                  ? "Ganti"
                                  : "Tambah",
                          headings: 'H4',
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 0.02 * width),
            child: Container(
              width: 0.86 * width,
              height: 2,
              color: Colors.grey.shade300,
            ),
          ),
          Obx(()=>SizedBox(
            height: 80,
            child: Row(children: [
            for(var i = 0 ; i < _takingOrderVendorController.selectedProduct[0].detailProduct.length; i++)
              Expanded(
                child: Padding(
                  padding: Get.width < 450 ? const EdgeInsets.only(left: 5,right: 5) : const EdgeInsets.only(left: 10,right: 10),
                  child: Column(
                    children: [
                    const SizedBox(height: 6,),
                    ChipsItem(satuan:_takingOrderVendorController.selectedProduct[0].detailProduct[i].satuan,fontSize: 8.sp,),
                    const SizedBox(height:6),
                    SizedBox(
                      height: 40,
                      child: SpinBox(
                        min: 0,
                        max: 9999,textStyle: TextStyle(fontSize: 10.sp),
                        value: double.parse(_takingOrderVendorController.listQty[i].toString()),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.zero
                        ),onChanged: (value) => _takingOrderVendorController.listQty[i] = value.toInt(),
                    ),)
                  ],),
                  )
                )
              ],)
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ]),
      ),
    );
  }
}
