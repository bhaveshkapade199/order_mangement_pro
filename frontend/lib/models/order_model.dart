import 'package:equatable/equatable.dart';

class OrderItemModel extends Equatable {
  final String productId;
  final String name;
  final String sku;
  final double unitPrice;
  final int quantity;
  final double subtotal;

  const OrderItemModel({
    required this.productId,
    required this.name,
    required this.sku,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] is Map ? json['productId']['_id'] : json['productId'].toString(),
      name: json['name'] ?? '',
      sku: json['sku'] ?? '',
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'sku': sku,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'subtotal': subtotal,
      };

  @override
  List<Object?> get props => [productId, name, quantity, subtotal];
}

class TrackingStageModel extends Equatable {
  final String status;
  final String note;
  final DateTime? timestamp;

  const TrackingStageModel({
    required this.status,
    required this.note,
    this.timestamp,
  });

  factory TrackingStageModel.fromJson(Map<String, dynamic> json) {
    return TrackingStageModel(
      status: json['status'] ?? '',
      note: json['note'] ?? '',
      timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp']) : null,
    );
  }

  @override
  List<Object?> get props => [status, note, timestamp];
}

class OrderModel extends Equatable {
  final String id;
  final String orderNumber;
  final double totalAmount;
  final double netPayable;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final int creditDays;
  final DateTime? creditDueDate;
  final List<OrderItemModel> items;
  final List<TrackingStageModel> trackingUpdates;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.totalAmount,
    required this.netPayable,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    this.creditDays = 0,
    this.creditDueDate,
    required this.items,
    this.trackingUpdates = const [],
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final rawUpdates = json['trackingUpdates'] as List<dynamic>? ?? [];

    return OrderModel(
      id: json['id'] ?? json['_id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      netPayable: (json['netPayable'] ?? json['totalAmount'] ?? 0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? 'upfront',
      paymentStatus: json['paymentStatus'] ?? 'pending',
      orderStatus: json['orderStatus'] ?? 'placed',
      creditDays: json['creditDays'] ?? 0,
      creditDueDate: json['creditDueDate'] != null ? DateTime.tryParse(json['creditDueDate']) : null,
      items: rawItems.map((i) => OrderItemModel.fromJson(i)).toList(),
      trackingUpdates: rawUpdates.map((t) => TrackingStageModel.fromJson(t)).toList(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, orderNumber, netPayable, paymentMethod, orderStatus];
}
