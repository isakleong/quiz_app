import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shiptoaddress.g.dart'; // This will be generated by the build_runner

@JsonSerializable()
@HiveType(typeId: 4) // Unique type ID for ShipToAddress
class ShipToAddress extends HiveObject {
  @HiveField(0) // Unique field ID for each field
  final String code;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String address;
  
  @HiveField(3)
  final String county;

  @HiveField(4)
  final String PostCode;

  @HiveField(5)
  final String City;

  ShipToAddress({
    required this.code,
    required this.name,
    required this.address,
    required this.county,
    required this.PostCode,
    required this.City
  });
  
  factory ShipToAddress.fromJson(Map<String, dynamic> json) {
    return ShipToAddress(
      code: json['Code'],
      name: json['Name'],
      address: json['Address'],
      county: json['County'],
      PostCode : json['PostCode'],
      City : json['City'],
    );
  }

  factory ShipToAddress.from(Map<String, dynamic> json) => _$ShipToAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ShipToAddressToJson(this);

}
