class MasterItemVendor {
  String? prefix;
  String? name;
  String? receivables;
  String? overdue_invoices;
  List<Banks>? banks;
  List<PaymentMethods>? paymentMethods;
  List<Items>? items;

  MasterItemVendor({this.prefix, this.name, this.items});

  MasterItemVendor.fromJson(Map<dynamic, dynamic> json) {
    prefix = json['prefix'];
    name = json['name'];
    receivables = json['receivables'].toString();
    overdue_invoices = json['overdue_invoices'].toString();
     if (json['banks'] != null) {
      banks = <Banks>[];
      json['banks'].forEach((v) {
        banks!.add(Banks.fromJson(v));
      });
    }
    if (json['paymentMethods'] != null) {
      paymentMethods = <PaymentMethods>[];
      json['paymentMethods'].forEach((v) {
        paymentMethods!.add(PaymentMethods.fromJson(v));
      });
    }
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prefix'] = prefix;
    data['name'] = name;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentMethods {
  int? id;
  String? name;

  PaymentMethods({this.id, this.name});

  PaymentMethods.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
  
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Banks {
  int? id;
  String? name;

  Banks({this.id, this.name});

  Banks.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Items {
  String? id;
  String? code;
  String? merk;
  String? volume;
  String? color;
  String? desc;
  String? uomId;
  String? price;
  String? komisi;
  List<Uoms>? uoms;

  Items({this.id, this.code, this.merk, this.volume, this.color, this.desc, this.uomId, this.price, this.komisi,this.uoms});

  Items.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'].toString();
    code = json['code'];
    merk = json['merk'];
    volume = json['volume'];
    color = json['color'];
    desc = json['desc'];
    uomId = json['uom_id'].toString();
    price = json['price'].toString();
    if(json['komisi'] != null){
      komisi = json['komisi'].toString();
    } else {
      komisi = "0";
    }
    if (json['uoms'] != null) {
      uoms = <Uoms>[];
      json['uoms'].forEach((v) {
        uoms!.add(Uoms.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['merk'] = merk;
    data['volume'] = volume;
    data['color'] = color;
    data['desc'] = desc;
    data['uom_id'] = uomId;
    data['price'] = price;
    data['komisi'] = komisi;
    if (uoms != null) {
      data['uoms'] = uoms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Uoms {
  String? id;
  String? name;

  Uoms({this.id, this.name});

  Uoms.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
