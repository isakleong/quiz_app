class ProductData {
  String kdProduct;
  String nmProduct;
  List<DetailProductData> detailProduct;
  ProductData(this.kdProduct, this.nmProduct, this.detailProduct);
}

class DetailProductData {
  String satuan;
  double hrg;
  DetailProductData(this.satuan, this.hrg);
}
