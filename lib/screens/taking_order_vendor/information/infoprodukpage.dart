import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:list_treeview/list_treeview.dart';

import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../models/treenodedata.dart';

class InfoProdukPage extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();

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
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getBody() {
    return ListTreeView(
      shrinkWrap: false,
      padding: EdgeInsets.all(0),
      itemBuilder: (BuildContext context, NodeData data) {
        TreeNodeData item = data as TreeNodeData;
        double offsetX = item.level * 30.0;
        return Padding(
          padding:  EdgeInsets.only(left: 8.0),
          child: Container(
            height: 54,
            padding: EdgeInsets.symmetric(horizontal: 16),
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
                          padding: EdgeInsets.only(right: 5),
                          child: !item.isFile ? (item.isExpand ? Image.asset("assets/images/folderopen.png",height: 25,) :  Image.asset("assets/images/folder.png",height: 25,)) :
                          item.extension == "jpg" ? Image.asset("assets/images/filejpg.png",height: 30) : 
                          item.extension == "jpeg" ? Image.asset("assets/images/filejpg.png",height: 30) : 
                          item.extension == "pdf" ? Image.asset("assets/images/filepdf.png",height: 30) : 
                          item.extension == "mp4" ? Image.asset("assets/images/filemp4.png",height: 30) :
                          Image.asset("assets/images/filejpg.png"),
                        ),
                        Text(
                          '${item.name.replaceAll("%20","")}',
                          style: TextStyle(fontSize: 15,),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onTap: (NodeData data) {
        print('index = ${data.index}');
      },
      controller: _takingOrderVendorController.treecontroller,
    );
  }
}