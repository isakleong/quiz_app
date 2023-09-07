import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/app_config.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/textview.dart';
import '../transaction/chipsitem.dart';

class ShopCartGantiBarang extends StatelessWidget {
  ShopCartGantiBarang({super.key});
  final TakingOrderVendorController _takingOrderVendorController = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    double height = Get.height;
    return Obx(() => Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: Container(
            width: 0.9 * width,
            decoration: BoxDecoration(
                border: Border.all(color: AppConfig.mainCyan, width: 2),
                borderRadius: BorderRadius.circular(10)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextView(
                          headings: 'H4',
                          fontSize: 14,
                          text: _takingOrderVendorController
                              .selectedProductgantibarang[0].nmProduct,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: ElevatedButton(
                        onPressed: () async {
                          await _takingOrderVendorController.addToCartGb();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConfig.mainCyan,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 2, bottom: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_cart),
                            const SizedBox(
                                width:
                                    8), // Add some space between the icon and text
                            TextView(
                              text: _takingOrderVendorController
                                      .listGantiBarang.isEmpty
                                  ? "Tambah"
                                  : _takingOrderVendorController.listGantiBarang
                                          .any((data) =>
                                              data.kdProduct ==
                                              _takingOrderVendorController
                                                  .selectedProductgantibarang[0]
                                                  .kdProduct)
                                      ? "Ganti"
                                      : "Tambah",
                              headings: 'H4',
                              fontSize: 14,
                              color: Colors.white,
                            )
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
              const SizedBox(
                height: 8,
              ),Obx(()=>  
                    SizedBox(
                          height: 80,
                          child: Row(children: [
                              for(var i = 0 ; i <  _takingOrderVendorController.selectedProductgantibarang[0].detailProduct.length; i++)
                                Expanded(
                                  child: Padding(
                                    padding: Get.width < 450 ? const EdgeInsets.only(left: 5,right: 5) : const EdgeInsets.only(left: 10,right: 10),
                                    child: Column(
                                      children: [
                                      const SizedBox(height: 6,),
                                      ChipsItem(satuan:_takingOrderVendorController.selectedProductgantibarang[0].detailProduct[i].satuan,fontSize: 8.sp,),
                                      const SizedBox(height:6),
                                      SizedBox(
                                        height: 40,
                                        child: SpinBox(
                                          min: 0,
                                          max: 9999,textStyle: TextStyle(fontSize: 10.sp),
                                          value: double.parse(_takingOrderVendorController.listQtygb[i].toString()),
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.zero
                                          ),onChanged: (value) => _takingOrderVendorController.listQtygb[i] = value.toInt(),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              )
                            ],
                          )
                        ),
                      ),
              const SizedBox(
                height: 15,
              ),
            ]),
          ),
        ));
  }
}
