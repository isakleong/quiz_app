import 'package:sfa_tools/models/cartmodel.dart';

class TarikBarangModel {
  String kdProduct;
  String nmProduct;
  String alasan;
  List<CartModel> itemOrder;
  TarikBarangModel(this.kdProduct, this.nmProduct, this.itemOrder, this.alasan);
}
