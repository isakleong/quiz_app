import 'cartmodel.dart';

class CartDetail {
  String kdProduct;
  String nmProduct;
  List<CartModel> itemOrder;
  CartDetail(this.kdProduct, this.nmProduct, this.itemOrder);
}