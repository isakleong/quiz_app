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
        data!.add(OutstandingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
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
        ? SalesOrder.fromJson(json['salesOrder'])
        : null;
    if (json['details'] != null) {
      details = <DetailsSo>[];
      json['details'].forEach((v) {
        details!.add(DetailsSo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (salesOrder != null) {
      data['salesOrder'] = salesOrder!.toJson();
    }
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['totalAmount'] = totalAmount;
    data['orderDate'] = orderDate;
    data['totalAmountFormated'] = totalAmountFormated;
    data['orderDateFormated'] = orderDateFormated;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = itemCode;
    data['name'] = itemName;
    data['uom'] = uom;
    data['qty'] = qty;
    return data;
  }
}