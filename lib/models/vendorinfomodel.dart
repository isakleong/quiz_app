import 'package:sfa_tools/models/customer.dart';
import 'package:sfa_tools/models/shiptoaddress.dart';
import 'package:sfa_tools/models/vendor.dart';

class VendorInfo {
  final Customer customer;
  final List<ShipToAddress> shipToAddresses;
  final List<Vendor> availVendors;

  VendorInfo({
    required this.customer,
    required this.shipToAddresses,
    required this.availVendors,
  });

  factory VendorInfo.fromJson(Map<String, dynamic> json) {
    return VendorInfo(
      customer: Customer.fromJson(json['customer']),
      shipToAddresses: List<ShipToAddress>.from(
        json['shipToAddresses'].map((x) => ShipToAddress.fromJson(x)),
      ),
      availVendors: List<Vendor>.from(
        json['availVendors'].map((x) => Vendor.fromJson(x)),
      ),
    );
  }
}
