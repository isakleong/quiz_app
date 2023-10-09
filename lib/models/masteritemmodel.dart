class MasterItemModel {
  List<Itemsub>? items;

  MasterItemModel({this.items});

  MasterItemModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Itemsub>[];
      json['items'].forEach((v) {
        items!.add(new Itemsub.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Itemsub {
  String? id;
  String? code;
  String? merk;
  String? volume;
  String? color;
  String? desc;
  String? komisi;
  List<Subdistricts>? subdistricts;
  List<Uomsub>? uoms;

  Itemsub(
      {this.id,
      this.code,
      this.merk,
      this.volume,
      this.color,
      this.desc,
      this.subdistricts,
      this.uoms});

  Itemsub.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    code = json['code'].toString();
    merk = json['merk'].toString();
    volume = json['volume'].toString();
    color = json['color'].toString();
    desc = json['desc'].toString();
    if (json['subdistricts'] != null) {
      subdistricts = <Subdistricts>[];
      json['subdistricts'].forEach((v) {
        subdistricts!.add(new Subdistricts.fromJson(v));
      });
    }
    if(json['komisi'] != null){
      komisi = json['komisi'].toString();
    } else {
      komisi = "0";
    }
    if (json['uoms'] != null) {
      uoms = <Uomsub>[];
      json['uoms'].forEach((v) {
        uoms!.add(new Uomsub.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['merk'] = this.merk;
    data['volume'] = this.volume;
    data['color'] = this.color;
    data['desc'] = this.desc;
    if (this.subdistricts != null) {
      data['subdistricts'] = this.subdistricts!.map((v) => v.toJson()).toList();
    }
    if (this.uoms != null) {
      data['uoms'] = this.uoms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subdistricts {
  String? name;
  dynamic price; // Change the type to dynamic

  Subdistricts({this.name, this.price});

  Subdistricts.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    price = json['price']; // Assign the dynamic value directly
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}

class Uomsub {
  String? id;
  String? name;

  Uomsub({this.id, this.name});

  Uomsub.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}