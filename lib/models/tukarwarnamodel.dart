import 'package:sfa_tools/models/cartmodel.dart';

import 'cartdetail.dart';

class TukarWarnaModel {
  String kdProduct;
  String nmProduct;
  List<CartModel> listqtyheader;
  List<CartDetail> listitemdetail;
  String id;
  TukarWarnaModel(this.kdProduct, this.nmProduct, this.listqtyheader, this.listitemdetail,this.id);
}
