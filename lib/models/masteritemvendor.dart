class MasterItemVendor {
  String? prefix;
  String? name;
  List<Items>? items;

  MasterItemVendor({this.prefix, this.name, this.items});

  MasterItemVendor.fromJson(Map<String, dynamic> json) {
    prefix = json['prefix'];
    name = json['name'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prefix'] = this.prefix;
    data['name'] = this.name;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? id;
  String? code;
  String? name;
  String? uomId;
  String? price;
  List<Uoms>? uoms;

  Items({this.id, this.code, this.name, this.uomId, this.price, this.uoms});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    code = json['code'];
    name = json['name'];
    uomId = json['uom_id'].toString();
    price = json['price'].toString();
    if (json['uoms'] != null) {
      uoms = <Uoms>[];
      json['uoms'].forEach((v) {
        uoms!.add(new Uoms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['uom_id'] = this.uomId;
    data['price'] = this.price;
    if (this.uoms != null) {
      data['uoms'] = this.uoms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Uoms {
  String? id;
  String? code;
  String? name;

  Uoms({this.id, this.code, this.name});

  Uoms.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}
