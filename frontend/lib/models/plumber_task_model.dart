import 'package:equatable/equatable.dart';

class PlumberTaskModel extends Equatable {
  final String id;
  final String taskNumber;
  final String title;
  final String description;
  final String customerName;
  final String customerMobile;
  final String status; // 'assigned', 'in_progress', 'completed'
  final DateTime scheduledDate;
  final String? street;
  final String? city;
  final String? pincode;
  final String? completionNotes;

  const PlumberTaskModel({
    required this.id,
    required this.taskNumber,
    required this.title,
    required this.description,
    required this.customerName,
    required this.customerMobile,
    required this.status,
    required this.scheduledDate,
    this.street,
    this.city,
    this.pincode,
    this.completionNotes,
  });

  String get fullAddress => [street, city, pincode].where((s) => s != null && s.isNotEmpty).join(', ');

  factory PlumberTaskModel.fromJson(Map<String, dynamic> json) {
    final addr = json['serviceAddress'] as Map<String, dynamic>? ?? {};

    return PlumberTaskModel(
      id: json['id'] ?? json['_id'] ?? '',
      taskNumber: json['taskNumber'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      customerName: json['customerName'] ?? 'Customer',
      customerMobile: json['customerMobile'] ?? '',
      status: json['status'] ?? 'assigned',
      scheduledDate: json['scheduledDate'] != null ? DateTime.parse(json['scheduledDate']) : DateTime.now(),
      street: addr['street'],
      city: addr['city'],
      pincode: addr['pincode'],
      completionNotes: json['completionNotes'],
    );
  }

  @override
  List<Object?> get props => [id, taskNumber, status];
}
