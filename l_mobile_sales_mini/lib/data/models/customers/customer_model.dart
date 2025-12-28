import 'package:json_annotation/json_annotation.dart';

part 'customer_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Customer {
  final String id;
  final String name;
  final String type;
  final String category;
  final String contactPerson;
  final String phone;
  final String email;
  final PhysicalAddress physicalAddress;
  final Location location;
  final String taxId;
  final String paymentTerms;
  final double creditLimit;
  final double currentBalance;
  final String territory;
  final String salesPerson;
  final String notes;
  final DateTime createdDate;
  final DateTime lastOrderDate;
  final String orderFrequency;

  Customer({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.contactPerson,
    required this.phone,
    required this.email,
    required this.physicalAddress,
    required this.location,
    required this.taxId,
    required this.paymentTerms,
    required this.creditLimit,
    required this.currentBalance,
    required this.territory,
    required this.salesPerson,
    required this.notes,
    required this.createdDate,
    required this.lastOrderDate,
    required this.orderFrequency,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PhysicalAddress {
  final String street;
  final String building;
  final String city;
  final String region;
  final String postalCode;

  PhysicalAddress({
    required this.street,
    required this.building,
    required this.city,
    required this.region,
    required this.postalCode,
  });

  factory PhysicalAddress.fromJson(Map<String, dynamic> json) =>
      _$PhysicalAddressFromJson(json);

  Map<String, dynamic> toJson() => _$PhysicalAddressToJson(this);
}

@JsonSerializable()
class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
