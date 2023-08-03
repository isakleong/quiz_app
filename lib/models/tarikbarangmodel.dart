class TarikBarangModel {
  String kdProduct;
  String nmProduct;
  String alasan;
  List<TarikBarangItemModel> itemOrder;
  TarikBarangModel(this.kdProduct, this.nmProduct, this.itemOrder, this.alasan);
}

class TarikBarangItemModel {
  String kdProduct;
  String nmProduct;
  int Qty;
  String Satuan;
  TarikBarangItemModel(this.kdProduct, this.nmProduct, this.Qty, this.Satuan);
}
