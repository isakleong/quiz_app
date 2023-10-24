import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/widgets/customelevatedbutton.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/app_config.dart';
import '../../../tools/textfieldformatter.dart';
import '../../../tools/utils.dart';

class DialogAddress extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  DialogAddress({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: SizedBox(
        width: width * 0.9,
        height: 0.67 * height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            TextView(
              text: _takingOrderVendorController.hardcodeOtherAddress,
              headings: 'H3',
              fontSize: 13.sp,
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Container(
              width: 0.9 * width,
              height: 10,
              color: Colors.grey.shade200,
            ),
            SizedBox(
              height: 0.02 * height,
            ),
            SizedBox(
              width: 0.7 * width,
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(
                      r'[a-zA-Z0-9\s()!?&%#@/<>,.\-=+_]+')), // Custom character set
                ],
                decoration: InputDecoration(
                  labelText: 'Alamat Penerima *',
                  icon: Image.asset(
                    'assets/images/location-pin.png',
                    width: 35.sp,
                    height: 35.sp,
                    fit: BoxFit.fill,
                  ),
                ),
                maxLength: 200,
                controller: _takingOrderVendorController.addressName.value,
                maxLines: null,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                keyboardType: TextInputType.multiline,
                style: TextStyle(fontSize: 10.sp),
                onChanged: (text) {
                  // Handle text changes here
                },
              ),
            ),
            SizedBox(
              width: 0.7 * width,
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(
                      r'[a-zA-Z0-9\s()!?&%#@/<>,.\-=+_]+')), // Custom character set
                ],
                decoration: InputDecoration(
                  labelText: 'Nama Penerima *',
                  icon: Image.asset(
                    'assets/images/user.png',
                    width: 35.sp,
                    height: 35.sp,
                    fit: BoxFit.fill,
                  ),
                ),
                maxLength: 100,
                controller: _takingOrderVendorController.receiverName.value,
                maxLines: null,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                keyboardType: TextInputType.multiline,
                style: TextStyle(fontSize: 10.sp),
                onChanged: (text) {
                  // Handle text changes here
                },
              ),
            ),
            SizedBox(
              width: 0.7 * width,
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nomor HP *',
                  icon: Image.asset(
                    'assets/images/telephone.png',
                    width: 35.sp,
                    height: 35.sp,
                    fit: BoxFit.fill,
                  ),
                ),
                maxLength: 50,
                controller: _takingOrderVendorController.phoneNum.value,
                maxLines: null,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                style: TextStyle(fontSize: 10.sp),
                onChanged: (text) {
                  // Handle text changes here
                },
              ),
            ),
            SizedBox(
              width: 0.7 * width,
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nomor HP Lainnya (Optional)',
                  icon: Image.asset(
                    'assets/images/telephone.png',
                    width: 35.sp,
                    height: 35.sp,
                    fit: BoxFit.fill,
                  ),
                ),
                maxLength: 50,
                controller: _takingOrderVendorController.phoneNumSecond.value,
                maxLines: null,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                style: TextStyle(fontSize: 10.sp),
                onChanged: (text) {
                  // Handle text changes here
                },
              ),
            ),
            SizedBox(
              width: 0.7 * width,
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(
                      r'[a-zA-Z0-9\s()!?&%#@/<>,.\-=+_]+')), // Custom character set
                ],
                decoration: InputDecoration(
                  labelText: 'Keterangan (Optional)',
                  icon: Image.asset(
                    'assets/images/notes.png',
                    width: 35.sp,
                    height: 35.sp,
                    fit: BoxFit.fill,
                  ),
                ),
                maxLength: 200,
                controller: _takingOrderVendorController.notesOtherAddress.value,
                maxLines: null,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                keyboardType: TextInputType.multiline,
                style: TextStyle(fontSize: 10.sp),
                onChanged: (text) {
                  // Handle text changes here
                },
              ),
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
                    onTap: ()  async {
                      if(_takingOrderVendorController.addressName.value.text.trim() == "" || _takingOrderVendorController.addressName.value.text.trim().length < 10){
                        Utils().showDialogSingleButton(context,"Peringatan" ,"Alamat penerima tidak boleh kosong dan harus lebih dari 10 karakter","info.json",(){Get.back();});
                        return;
                      }
                      if(_takingOrderVendorController.receiverName.value.text.trim() == "" || _takingOrderVendorController.receiverName.value.text.trim().length < 5){
                        Utils().showDialogSingleButton(context,"Peringatan" ,"Nama penerima tidak boleh kosong dan harus lebih dari 5 karakter","info.json",(){Get.back();});
                        return;
                      }
                      if(_takingOrderVendorController.phoneNum.value.text.trim() == "" || _takingOrderVendorController.phoneNum.value.text.trim().length < 9){
                        Utils().showDialogSingleButton(context,"Peringatan" ,"Nomor HP tidak boleh kosong dan harus lebih dari 9 digit","info.json",(){Get.back();});
                        return;
                      }
                      if(_takingOrderVendorController.phoneNumSecond.value.text.trim() != "" && _takingOrderVendorController.phoneNumSecond.value.text.trim().length < 9){
                        Utils().showDialogSingleButton(context,"Peringatan" ,"Nomor HP Lainnya harus lebih dari 9 digit","info.json",(){Get.back();});
                        return;
                      }
                      _takingOrderVendorController.addOtherAddressData();
                      Get.back();
                      _takingOrderVendorController.previewCheckOut();
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
