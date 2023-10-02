import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:list_treeview/list_treeview.dart';
import 'package:sfa_tools/tools/viewpdf.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../models/treenodedata.dart';
import '../../../tools/viewimage.dart';
import '../../../tools/viewvideo.dart';

class InfoProdukPage extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();

  InfoProdukPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(()=>_takingOrderVendorController.isSuccess.value == false ? getProgressView() : 
      (_takingOrderVendorController.isSuccess.value == true && _takingOrderVendorController.datanodelength.value == 0 ) ? Container()
       : getBody(),
      ) 
    );
  }

  Widget getProgressView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getBody() {
    return ListTreeView(
      shrinkWrap: false,
      padding: const EdgeInsets.all(0),
      itemBuilder: (BuildContext context, NodeData data) {
        TreeNodeData item = data as TreeNodeData;
        double offsetX = item.level * 30.0;
        return Padding(
          padding:  const EdgeInsets.only(left: 8.0),
          child: InkWell(
            onTap: !item.isFile
                  ? null
                  : () async {
                      var tdir = item.fullname.substring(0, item.fullname.lastIndexOf("/")).replaceAll("%20", " ");
                      print(await Directory("${_takingOrderVendorController.productdir}/$tdir"));
                      if (await Directory("${_takingOrderVendorController.productdir}/$tdir").exists() && await File("${_takingOrderVendorController.productdir}/${item.fullname.replaceAll("%20", " ")}").exists()) {
                        if (item.extension == "jpg" || item.extension == "jpeg") {
                          Get.to(ViewImageScreen("${_takingOrderVendorController.productdir}/${item.fullname.replaceAll("%20", " ")}"));
                        } else if (item.extension == "pdf") {
                          Get.to(ViewPDFScreen("${_takingOrderVendorController.productdir}/${item.fullname.replaceAll("%20", " ")}"));
                        } else if (item.extension == "mp4") {
                          Get.to(ViewVideoScreen("${_takingOrderVendorController.productdir}/${item.fullname.replaceAll("%20", " ")}"));
                        }
                      } else {
                        Get.defaultDialog(
                          radius: 6,
                          barrierDismissible: true,
                          title: "",
                          titlePadding: const EdgeInsets.only(top: 0, bottom: 0),
                          cancel: OutlinedButton(
                            onPressed: () => {Get.back()},
                            style: OutlinedButton.styleFrom(side: const BorderSide(width: 1, color: Colors.teal)),
                            child: const Text("TUTUP", style: TextStyle(fontFamily: "Lato", fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal)),
                          ),
                          contentPadding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                          content: Column(
                            children: [
                              const Text("Informasi Belum Tersedia", style: TextStyle(fontFamily: "Lato", fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                              const SizedBox(height: 25),
                              Text("File belum dapat diunduh,", style: TextStyle(fontFamily: "Lato", fontSize: 15, color: Colors.grey.shade800)),
                              const SizedBox(height: 6),
                              Text("mohon coba kembali lain waktu.", style: TextStyle(fontFamily: "Lato", fontSize: 15, color: Colors.grey.shade800)),
                              const SizedBox(height: 5),
                            ],
                          ),
                        );
                      }
                    },
            child: Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: offsetX),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: !item.isFile ? (item.isExpand ? Image.asset("assets/images/folderopen.png",height: 25,) :  Image.asset("assets/images/folder.png",height: 25,)) :
                            item.extension == "jpg" ? Image.asset("assets/images/filejpg.png",height: 30) : 
                            item.extension == "jpeg" ? Image.asset("assets/images/filejpg.png",height: 30) : 
                            item.extension == "pdf" ? Image.asset("assets/images/filepdf.png",height: 30) : 
                            item.extension == "mp4" ? Image.asset("assets/images/filemp4.png",height: 30) :
                            Image.asset("assets/images/filejpg.png",height: 30),
                          ),
                          AutoSizeText(
                            item.name.replaceAll("%20"," "),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontSize: MediaQuery.of(context).size.width < 450 ? 9.sp : 11.sp,fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      onTap: (NodeData data) {
        //print('index = ${data.index}');
      },
      controller: _takingOrderVendorController.treecontroller,
    );
  }
}