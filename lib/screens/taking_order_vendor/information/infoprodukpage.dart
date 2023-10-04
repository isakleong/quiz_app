import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:list_treeview/list_treeview.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/tools/viewpdf.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../models/treenodedata.dart';
import '../../../tools/viewimage.dart';
import '../../../tools/viewvideo.dart';
import '../../../widgets/textview.dart';

class InfoProdukPage extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();

  InfoProdukPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(()=>_takingOrderVendorController.isSuccess.value == false ? getProgressView(context) : 
      (_takingOrderVendorController.isSuccess.value == true && _takingOrderVendorController.datanodelength.value == 0 ) ? Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie/notfound.json', width: width * 0.35),
            const TextView(
              text: "Tidak Ada Info Produk",
              headings: 'H4',
              fontSize: 20,
            )
          ],
        )) : getBody(),
      ) 
    );
  }

  Widget getProgressView(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: 0.01 * height,),
        Expanded( child: ListView.builder(
          itemBuilder: (c, i) {
                return Padding(
                  padding: EdgeInsets.only(top:8.0,bottom: 8.0, left: 0.05 * width, right: 0.05 * width),
                  child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade400,
                        highlightColor: Colors.grey.shade200,
                        child: Container(
                          width: 0.8 * width,
                          height: 0.05 * height,
                          color: Colors.white,
                          // Add any other child widgets you want inside the shimmering container
                        ),
                      ),
                );
          },
          itemCount: 10,
          physics: const BouncingScrollPhysics(),
        )),
      ],
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
                      var tdir = "${AppConfig().folderProductKnowledge}/${item.fullname}".substring(0, "${AppConfig().folderProductKnowledge}/${item.fullname}".lastIndexOf("/")).replaceAll("%20", " ");
                      if (await Directory("${_takingOrderVendorController.productdir}/$tdir").exists() && await File("${_takingOrderVendorController.productdir}/${AppConfig().folderProductKnowledge.replaceAll("%20", " ")}/${item.fullname.replaceAll("%20", " ")}").exists()) {
                        if (item.extension == "jpg" || item.extension == "jpeg") {
                          Get.to(ViewImageScreen("${_takingOrderVendorController.productdir}/${AppConfig().folderProductKnowledge.replaceAll("%20", " ")}/${item.fullname.replaceAll("%20", " ")}"));
                        } else if (item.extension == "pdf") {
                          Get.to(ViewPDFScreen("${_takingOrderVendorController.productdir}/${AppConfig().folderProductKnowledge.replaceAll("%20", " ")}/${item.fullname.replaceAll("%20", " ")}"));
                        } else if (item.extension == "mp4") {
                          Get.to(ViewVideoScreen("${_takingOrderVendorController.productdir}/${AppConfig().folderProductKnowledge.replaceAll("%20", " ")}/${item.fullname.replaceAll("%20", " ")}"));
                        }
                      } else {
                        Get.defaultDialog(
                          radius: 6,
                          barrierDismissible: true,
                          title: "",
                          titlePadding: const EdgeInsets.only(top: 0, bottom: 0),
                          cancel: OutlinedButton(
                            onPressed: () => {Get.back()},
                            style: OutlinedButton.styleFrom(backgroundColor: Colors.teal),
                            child: const Text("TUTUP", style: TextStyle(fontFamily: "Lato", fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
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