import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'customer.g.dart';

@JsonSerializable()
@HiveType(typeId: 3) // Unique type ID for Customer
class Customer extends HiveObject {
  @HiveField(0) // Unique field ID for each field
  final String no;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String address;
  
  @HiveField(3)
  final String county;
  
  @HiveField(4)
  final String city;

  Customer({
    required this.no,
    required this.name,
    required this.address,
    required this.county,
    required this.city,
  });

   factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      no: json['No_'],
      name: json['Name'],
      address: json['Address'],
      county: json['County'],
      city: json['City'],
    );
  }

  factory Customer.from(Map<String, dynamic> json) => _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
  
}
