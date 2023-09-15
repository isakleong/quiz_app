import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/checkoutlist.dart';
import 'package:sfa_tools/widgets/customelevatedbutton.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/app_config.dart';
import '../../../tools/utils.dart';

class DialogCheckOut extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  DialogCheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 0.9,
      height: 0.85 * height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            TextView(
              text: "Penjualan - ${_takingOrderVendorController.nmtoko.value}",
              headings: 'H3',
              fontSize: 13.sp,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            TextView(
              text: "Alamat Pengiriman",
              headings: 'H3',
              fontSize: 10.5.sp,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 0.02 * width, right: 0.01 * width),
              child: Container(
                width: 0.8 * width,
                height: 0.05 * height,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.home,
                        color: AppConfig.mainCyan,
                        size: 12
                            .sp), // Use any desired icon from flutter_icons package
                    const SizedBox(
                        width: 8), // Adjust the space between icon and text
                    Obx(
                      () => Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value:  
                            _takingOrderVendorController.listaddress.length > 1 ?
                            _takingOrderVendorController.choosedAddress.value == "" ? 'Pilih Alamat Pengiriman' : _takingOrderVendorController.choosedAddress.value :
                             _takingOrderVendorController.listaddress[0].address,
                            onChanged: (String? newValue) {
                              _takingOrderVendorController.choosedAddress.value = newValue!;
                            },
                            items: _takingOrderVendorController.listaddress.value.map((value) {
                              return DropdownMenuItem<String>(
                                value: value.address,
                                child: TextView(
                                  text: value.address,
                                  textAlign: TextAlign.left,
                                  fontSize: 10.sp,
                                  headings: 'H4',
                                ),
                              );
                            }).toList(),
                            
                            // <String>[
                            //   'Pilih Alamat Pengiriman',
                            //   'Pemancar Lamtemen Timur',
                            //   'Alamat Dummy',
                            // ].map((String value) {
                            //   return DropdownMenuItem<String>(
                            //     value: value,
                            //     child: TextView(
                            //       text: value,
                            //       textAlign: TextAlign.left,
                            //       fontSize: 10.sp,
                            //       headings: 'H4',
                            //     ),
                            //   );
                            // }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              width: 0.9 * width,
              height: 10,
              color: Colors.grey.shade200,
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.only(left: 0.05 * width,right: 0.05 * width),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s()!?&%#@/<>,.\-=+_]+')), // Custom character set
                      ],
                      decoration: InputDecoration(
                        labelText: 'Catatan / Keterangan',
                        icon: Image.asset(
                          'assets/images/notes.png',
                          width: 35.sp,
                          height: 35.sp,
                          fit: BoxFit.fill,
                        ),
                      ),
                      maxLength: 150,
                      controller: _takingOrderVendorController.notes.value,
                      maxLines: null,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 10.sp),
                      onChanged: (text) {
                        // Handle text changes here
                      },
                    ),
                  ),
                  /* ganti barang button
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade500, width: 1),
                        backgroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.all(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(3.0.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextView(
                              text: 'Ganti Barang',
                              color: Colors.black,
                              headings: 'H4',
                              fontSize: 10.sp,
                            ),
                            SizedBox(
                              width: 0.01 * width,
                            ),
                            Container(
                              width: 25.sp,
                              height: 25.sp,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green.shade700),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.manage_search,
                                    color: Colors.white,
                                    size: 14.sp,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                  )) */
                ],
              ),
            ),
            SizedBox(
              width: 0.85 * width,
              height: height * 0.4,
              child: ListView.builder(
                itemCount: _takingOrderVendorController.cartDetailList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        left: 0.05 * width,
                        top: 5,
                        right: 0.05 * width),
                    child: CheckoutList(
                        idx: (index + 1).toString(),
                        data:
                            _takingOrderVendorController.cartDetailList[index]),
                  );
                },
                physics: const BouncingScrollPhysics(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 0.75 * width,
              // height: 0.06 * height,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextView(
                            text:
                                "${_takingOrderVendorController.cartDetailList.length}",
                            headings: 'H2',
                            fontSize: 11.sp,
                            color: Colors.amber.shade900,
                          ),
                          TextView(
                            text: "Produk",
                            headings: 'H4',
                            fontSize: 9.sp,
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 1.5,
                      height: 0.06 * height,
                      color: Colors.grey.shade400,
                    ),
                    Image.asset(
                      'assets/images/custorder.png',
                      width: 25.sp,
                      height: 25.sp,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextView(
                            text: Utils().formatNumber(
                                _takingOrderVendorController.countPriceTotal()),
                            headings: 'H2',
                            fontSize: 11.sp,
                            color: Colors.amber.shade900,
                          ),
                          TextView(
                            text: "Perkiraan Pesanan",
                            headings: 'H4',
                            fontSize: 9.sp,
                          )
                        ],
                      ),
                    ),
                    /*komisi
                    Container(
                      width: 1.5,
                      height: 0.06 * height,
                      color: Colors.grey.shade400,
                    ),
                    Image.asset(
                      'assets/images/komisi.png',
                      width: 25.sp,
                      height: 25.sp,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextView(
                            text:
                                Utils().formatNumber(2500),
                            headings: 'H2',
                            fontSize: 10.sp,
                            color: Colors.amber.shade900,
                          ),
                          TextView(
                            text: "Perkiraan Komisi",
                            headings: 'H4',
                            fontSize: 9.sp,
                          )
                        ],
                      ),
                     ), */
                  ]),
            ),
            SizedBox(
              height: 0.02 * height,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomElevatedButton(
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: AppConfig.mainCyan,
                      size: 14.sp,
                    ),
                    text: "BATAL",
                    onTap: () {
                      Get.back();
                    },
                    radius: 4,
                    space: 5,
                    backgroundColor: Colors.white,
                    bordercolor: AppConfig.mainCyan,
                    elevation: 0,
                    fonts: 10.sp,
                    textcolor: AppConfig.mainCyan,
                    headings: 'H2'),
                CustomElevatedButton(
                    icon: Icon(
                      Icons.check_circle_outline_rounded,
                      size: 14.sp,
                    ),
                    text: "SIMPAN",
                    onTap: ()  {
                      _takingOrderVendorController.handleSaveConfirm( "Yakin untuk simpan penjualan ?",
                         "Konfirmasi Penjualan", 
                         () async {
                            await _takingOrderVendorController.checkout();
                        });
                    },
                    radius: 4,
                    space: 5,
                    fonts: 10.sp,
                    backgroundColor: AppConfig.mainCyan,
                    textcolor: Colors.white,
                    elevation: 2,
                    bordercolor: AppConfig.mainCyan,
                    headings: 'H2')
              ],
            )
          ],
        ),
      ),
    );
  }
}
