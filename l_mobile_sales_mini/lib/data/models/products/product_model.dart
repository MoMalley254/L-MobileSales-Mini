import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Product {
  final String id;
  final String name;
  final String sku;
  final String category;
  final String subcategory;
  final String description;
  final double price;
  final double taxRate;
  final List<Stock> stock;
  final String unit;
  final String packaging;
  final int minOrderQuantity;
  final int reorderLevel;
  final bool batchNumber;
  final bool serialNumber;
  final List<String> images;
  final Specifications specifications;
  final List<String> relatedProducts;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.subcategory,
    required this.description,
    required this.price,
    required this.taxRate,
    required this.stock,
    required this.unit,
    required this.packaging,
    required this.minOrderQuantity,
    required this.reorderLevel,
    required this.batchNumber,
    required this.serialNumber,
    required this.images,
    required this.specifications,
    required this.relatedProducts,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Stock {
  final String warehouseId;
  final int quantity;
  final int reserved;

  Stock({
    required this.warehouseId,
    required this.quantity,
    required this.reserved,
  });

  factory Stock.fromJson(Map<String, dynamic> json) =>
      _$StockFromJson(json);

  Map<String, dynamic> toJson() => _$StockToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Specifications {
  final String viscosity;
  final String baseType;
  final int volume;
  final String application;

  Specifications({
    required this.viscosity,
    required this.baseType,
    required this.volume,
    required this.application,
  });

  factory Specifications.fromJson(Map<String, dynamic> json) =>
      _$SpecificationsFromJson(json);

  Map<String, dynamic> toJson() => _$SpecificationsToJson(this);
}
