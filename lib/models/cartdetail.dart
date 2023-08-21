import 'package:hive/hive.dart';

import 'cartmodel.dart';
part 'cartdetail.g.dart';

@HiveType(typeId: 8)
class CartDetail {
  @HiveField(0)
  String kdProduct;

  @HiveField(1)
  String nmProduct;
  
  @HiveField(2)
  List<CartModel> itemOrder;

  CartDetail(this.kdProduct, this.nmProduct, this.itemOrder);

  factory CartDetail.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonItemList = json['itemOrder'];
    final List<CartModel> cartModels = jsonItemList.map((item) => CartModel.fromJson(item)).toList();

    return CartDetail(
      json['kdProduct'] as String,
      json['nmProduct'] as String,
      cartModels,
    );
  }
}