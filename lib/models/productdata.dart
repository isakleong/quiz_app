import 'package:hive/hive.dart';

import 'detailproductdata.dart';
part 'productdata.g.dart';

@HiveType(typeId: 11)
class ProductData {

  @HiveField(0)
  String kdProduct;

  @HiveField(1)
  String nmProduct;

  @HiveField(2)
  List<DetailProductData> detailProduct;

  ProductData(this.kdProduct, this.nmProduct, this.detailProduct);
}
