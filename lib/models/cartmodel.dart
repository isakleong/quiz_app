class CartDetail {
  String kdProduct;
  String nmProduct;
  List<CartModel> itemOrder;
  CartDetail(this.kdProduct, this.nmProduct, this.itemOrder);
}

class CartModel {
  String kdProduct;
  String nmProduct;
  int Qty;
  String Satuan;
  double hrgPerPieces;
  CartModel(
      this.kdProduct, this.nmProduct, this.Qty, this.Satuan, this.hrgPerPieces);
}
