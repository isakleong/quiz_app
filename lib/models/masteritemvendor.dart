class MasterItemVendor {
  final String prefix;
  final String name;
  final List<Item> items;

  MasterItemVendor({
    required this.prefix,
    required this.name,
    required this.items,
  });

  factory MasterItemVendor.fromJson(Map<String, dynamic> json) {
    List<Item> itemsList = (json['items'] as List)
        .map((itemJson) => Item.fromJson(itemJson))
        .toList();

    return MasterItemVendor(
      prefix: json['prefix'],
      name: json['name'],
      items: itemsList,
    );
  }
}

class Item {
  final String code;
  final String name;
  final String price;
  final String uomId;
  final UnitOfMeasure uom;

  Item({
    required this.code,
    required this.name,
    required this.price,
    required this.uomId,
    required this.uom,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      code: json['code'],
      name: json['name'],
      price: json['price'],
      uomId: json['uom_id'],
      uom: UnitOfMeasure.fromJson(json['uom']),
    );
  }
}

class UnitOfMeasure {
  final int id;
  final String code;
  final String name;

  UnitOfMeasure({
    required this.id,
    required this.code,
    required this.name,
  });

  factory UnitOfMeasure.fromJson(Map<String, dynamic> json) {
    return UnitOfMeasure(
      id: json['id'],
      code: json['code'],
      name: json['name'],
    );
  }
}
