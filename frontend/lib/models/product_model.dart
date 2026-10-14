import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String zohoItemId;
  final String name;
  final String sku;
  final String category;
  final double price; // Retail Price
  final double? dealerPrice; // Wholesale Dealer Price
  final double effectivePrice;
  final bool inStock;
  final int? stockQuantity; // Nullable: Hidden from Customers, Visible to Dealers!
  final String unit;
  final String description;
  final String imageUrl;

  const ProductModel({
    required this.id,
    required this.zohoItemId,
    required this.name,
    required this.sku,
    required this.category,
    required this.price,
    this.dealerPrice,
    required this.effectivePrice,
    required this.inStock,
    this.stockQuantity,
    required this.unit,
    required this.description,
    required this.imageUrl,
  });

  bool get canViewStock => stockQuantity != null;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final retail = (json['price'] ?? json['retailPrice'] ?? 0).toDouble();
    final wholesale = json['dealerPrice'] != null ? (json['dealerPrice']).toDouble() : null;
    final effective = json['effectivePrice'] != null ? (json['effectivePrice']).toDouble() : (wholesale ?? retail);

    return ProductModel(
      id: json['id'] ?? json['_id'] ?? '',
      zohoItemId: json['zohoItemId'] ?? '',
      name: json['name'] ?? '',
      sku: json['sku'] ?? '',
      category: json['category'] ?? '',
      price: retail,
      dealerPrice: wholesale,
      effectivePrice: effective,
      inStock: json['inStock'] ?? (json['stockQuantity'] != null ? (json['stockQuantity'] > 0) : true),
      stockQuantity: json['stockQuantity'], // Present ONLY for dealers and admins
      unit: json['unit'] ?? 'pcs',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'zohoItemId': zohoItemId,
      'name': name,
      'sku': sku,
      'category': category,
      'price': price,
      'dealerPrice': dealerPrice,
      'effectivePrice': effectivePrice,
      'inStock': inStock,
      'stockQuantity': stockQuantity,
      'unit': unit,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [id, zohoItemId, name, sku, price, stockQuantity];
}
