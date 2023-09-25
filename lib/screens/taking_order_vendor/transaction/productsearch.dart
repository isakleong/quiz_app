import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/widgets/customelevatedbutton.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common/app_config.dart';

class ProductSearch extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  ProductSearch({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Obx(() => _takingOrderVendorController.nmtoko.value == "" ? 
      Shimmer.fromColors(
            baseColor: Colors.grey.shade400,
            highlightColor: Colors.grey.shade200,
            child: Container(
              width: 0.9 * width,
              height: 0.2 * height,
              color: Colors.white,
              // Add any other child widgets you want inside the shimmering container
            ),
          ):
      Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: SizedBox(
            width: 0.9 * width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 50.sp,
                              height: 50.sp,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppConfig.mainCyan,
                              ),
                            ),
                            Image.asset(
                              'assets/images/custorder.png',
                              width: 35.sp,
                              height: 35.sp,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextView(
                                headings: "H2", text: "Penjualan", fontSize: 10.sp),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 14.sp,
                                      height: 14.sp,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppConfig.mainCyan,
                                      ),
                                    ),
                                    Icon(
                                      Icons.home,
                                      color: Colors.white,
                                      size: 10.sp,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                TextView(
                                  text: _takingOrderVendorController.nmtoko.value,
                                  fontSize: 10.sp,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding:  EdgeInsets.only(right: 0.025 * width),
                      child: CustomElevatedButton(
                            text: "Outstanding",
                            onTap: () {
                              _takingOrderVendorController.overlayactivepenjualan.value = "outstanding";
                            },
                            width: 0.25 * width,
                            radius: 10,
                            backgroundColor: Colors.orange.shade700,
                            textcolor: Colors.white,
                            elevation: 5,
                            fonts: 9.sp,
                            bordercolor: Colors.orange.shade700,
                            headings: 'H2'),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.02 * width),
                child: Container(
                  width: 0.86 * width,
                  height: 2,
                  color: Colors.grey.shade300,
                ),
              ),
              _takingOrderVendorController.listProduct.isEmpty && _takingOrderVendorController.needtorefresh.value == false ? 
                Padding(
                  padding: EdgeInsets.only(left: 0.02 * width, top: 5, bottom: 10),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade400,
                      highlightColor: Colors.grey.shade200,
                      child: Container(
                        width: 0.86 * width,
                        height: 40,
                        color: Colors.white,
                        // Add any other child widgets you want inside the shimmering container
                      ),
                  ),
              ): _takingOrderVendorController.needtorefresh.value == true ? 
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                                  onPressed: () {
                                    _takingOrderVendorController.getListItem();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConfig.mainCyan,
                                    padding:  const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                    shape: const StadiumBorder(),
                                    elevation: 5,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children:  [
                                      FaIcon(FontAwesomeIcons.arrowsRotate,size: 12.sp,),
                                      const SizedBox(width: 10),
                                      TextView(
                                          headings: "H4",
                                          text: "Refresh",
                                          fontSize: 12.sp,
                                          color: Colors.white),
                                    ],
                                  ),
                                ),
                        ):
              Padding(
                padding:
                    EdgeInsets.only(left: 0.02 * width, top: 5, bottom: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 0.8 * width,
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _takingOrderVendorController.cnt.value,
                          style: TextStyle(fontSize: 12.sp),
                          decoration: InputDecoration(
                              labelText: 'Cari Produk',
                              labelStyle: TextStyle(fontSize: 12.sp),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                FontAwesomeIcons.search,
                                color: const Color(0XFF319088),
                                size: 14.sp,
                              )),
                        ),
                        suggestionsCallback: (pattern) {
                          return _takingOrderVendorController.listProduct
                              .where((data) => data.nmProduct
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()))
                              .toList();
                        },
                        itemBuilder: (context, suggestion) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: 0.01 * height,
                                bottom: 0.01 * height),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 0.02 * width,
                                ),
                                Icon(
                                  FontAwesomeIcons.solidCircle,
                                  color: Colors.grey.shade600,
                                  size: 10.sp,
                                ),
                                SizedBox(
                                  width: 0.02 * width,
                                ),
                                TextView(
                                  text: suggestion.nmProduct,
                                  fontSize: 11.sp,
                                ),
                              ],
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          // print(suggestion);
                          if (suggestion == "") {
                            _takingOrderVendorController.cnt.value.text = "";
                          } else {
                            _takingOrderVendorController.cnt.value.text = suggestion.nmProduct;
                            _takingOrderVendorController.handleProductSearchButton(suggestion.kdProduct);
                          }
                        },
                        hideSuggestionsOnKeyboardHide: true,
                        noItemsFoundBuilder: (BuildContext context) =>
                            Container(
                          height: 43,
                          margin: const EdgeInsets.only(left: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(Icons.close, color: Colors.red.shade600),
                                const SizedBox(width: 10),
                                const TextView(text: "Produk Tidak Ditemukan"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ));
  }
}
