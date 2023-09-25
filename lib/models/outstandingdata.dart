class OutstandingResponse {
  bool? success;
  String? message;
  List<OutstandingData>? data;

  OutstandingResponse({this.success, this.message, this.data});

  OutstandingResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OutstandingData>[];
      json['data'].forEach((v) {
        data!.add(new OutstandingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OutstandingData {
  SalesOrder? salesOrder;
  List<DetailsSo>? details;

  OutstandingData({this.salesOrder, this.details});

  OutstandingData.fromJson(Map<String, dynamic> json) {
    salesOrder = json['salesOrder'] != null
        ? new SalesOrder.fromJson(json['salesOrder'])
        : null;
    if (json['details'] != null) {
      details = <DetailsSo>[];
      json['details'].forEach((v) {
        details!.add(new DetailsSo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.salesOrder != null) {
      data['salesOrder'] = this.salesOrder!.toJson();
    }
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesOrder {
  String? code;
  String? totalAmount;
  String? orderDate;
  String? totalAmountFormated;
  String? orderDateFormated;

  SalesOrder(
      {this.code,
      this.totalAmount,
      this.orderDate,
      this.totalAmountFormated,
      this.orderDateFormated});

  SalesOrder.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    totalAmount = json['totalAmount'];
    orderDate = json['orderDate'];
    totalAmountFormated = json['totalAmountFormated'];
    orderDateFormated = json['orderDateFormated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['totalAmount'] = this.totalAmount;
    data['orderDate'] = this.orderDate;
    data['totalAmountFormated'] = this.totalAmountFormated;
    data['orderDateFormated'] = this.orderDateFormated;
    return data;
  }
}

class DetailsSo {
  String? itemCode;
  String? itemName;
  String? uom;
  int? qty;

  DetailsSo({this.itemCode, this.itemName, this.uom, this.qty});

  DetailsSo.fromJson(Map<String, dynamic> json) {
    itemCode = json['code'];
    itemName = json['name'];
    uom = json['uom'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.itemCode;
    data['name'] = this.itemName;
    data['uom'] = this.uom;
    data['qty'] = this.qty;
    return data;
  }
}