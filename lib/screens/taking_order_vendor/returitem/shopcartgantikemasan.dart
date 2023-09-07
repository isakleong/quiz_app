import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/textview.dart';
import '../transaction/chipsitem.dart';

class ShopCartGantiKemasan extends StatelessWidget {
  ShopCartGantiKemasan({super.key});
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
                              .selectedProductgantikemasan[0].nmProduct,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: ElevatedButton(
                        onPressed: () async {
                          await _takingOrderVendorController.addToCartGk();
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
                                      .listgantikemasan.isEmpty
                                  ? "Tambah"
                                  : _takingOrderVendorController
                                          .listgantikemasan
                                          .any((data) =>
                                              data.kdProduct ==
                                              _takingOrderVendorController
                                                  .selectedProductgantikemasan[
                                                      0]
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
              ), Obx(()=>  
                    SizedBox(
                          height: 80,
                          child: Row(children: [
                              for(var i = 0 ; i <  _takingOrderVendorController.selectedProductgantikemasan[0].detailProduct.length; i++)
                                Expanded(
                                  child: Padding(
                                    padding: Get.width < 450 ? const EdgeInsets.only(left: 5,right: 5) : const EdgeInsets.only(left: 10,right: 10),
                                    child: Column(
                                      children: [
                                      const SizedBox(height: 6,),
                                      ChipsItem(satuan:_takingOrderVendorController.selectedProductgantikemasan[0].detailProduct[i].satuan,fontSize: 8.sp,),
                                      const SizedBox(height:6),
                                      SizedBox(
                                        height: 40,
                                        child: SpinBox(
                                          min: 0,
                                          max: 9999,textStyle: TextStyle(fontSize: 10.sp),
                                          value: double.parse(_takingOrderVendorController.listQtygk[i].toString()),
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.zero
                                          ),onChanged: (value) => _takingOrderVendorController.listQtygk[i] = value.toInt(),
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
              Padding(
                padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 0.01 * Get.height),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(width: 1, color: Colors.grey.shade500)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 10),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _takingOrderVendorController
                                    .selectedAlasangk.value ==
                                ""
                            ? 'Pilih Alasan Retur'
                            : _takingOrderVendorController
                                .selectedAlasangk.value,
                        onChanged: (data) {
                          print(data);
                          _takingOrderVendorController.selectedAlasangk.value =
                              data!;
                        },
                        items: <String>[
                          'Pilih Alasan Retur',
                          'Kaleng Penyok',
                          'Kaleng Karatan'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  value == 'Pilih Alasan Retur'
                                      ? FontAwesomeIcons.truck
                                      : FontAwesomeIcons.circleChevronRight,
                                  size: 18,
                                  color: AppConfig.mainCyan,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                TextView(
                                  text: value,
                                  textAlign: TextAlign.left,
                                  fontSize: 13,
                                  headings: 'H4',
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ));
  }
}
