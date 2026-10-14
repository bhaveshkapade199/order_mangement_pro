import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String mobileNumber;
  final String role; // 'customer', 'dealer', 'plumber', 'admin'
  final String name;
  final String? email;
  final bool isVerified;
  final bool zohoVerified;
  final String? zohoContactId;
  final double creditLimit;
  final double creditUsed;
  final bool credit30Allowed;
  final bool credit90Allowed;
  final String? plumberVerificationStatus;
  final String? plumberCertificationNo;
  final double plumberRating;

  const UserModel({
    required this.id,
    required this.mobileNumber,
    required this.role,
    required this.name,
    this.email,
    this.isVerified = false,
    this.zohoVerified = false,
    this.zohoContactId,
    this.creditLimit = 0.0,
    this.creditUsed = 0.0,
    this.credit30Allowed = false,
    this.credit90Allowed = false,
    this.plumberVerificationStatus,
    this.plumberCertificationNo,
    this.plumberRating = 4.8,
  });

  double get availableCredit => creditLimit - creditUsed;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      role: json['role'] ?? 'customer',
      name: json['name'] ?? 'User',
      email: json['email'],
      isVerified: json['isVerified'] ?? false,
      zohoVerified: json['zohoVerified'] ?? false,
      zohoContactId: json['zohoContactId'],
      creditLimit: (json['creditLimit'] ?? 0).toDouble(),
      creditUsed: (json['creditUsed'] ?? 0).toDouble(),
      credit30Allowed: json['credit30Allowed'] ?? false,
      credit90Allowed: json['credit90Allowed'] ?? false,
      plumberVerificationStatus: json['plumberVerificationStatus'],
      plumberCertificationNo: json['plumberCertificationNo'],
      plumberRating: (json['plumberRating'] ?? 4.8).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobileNumber': mobileNumber,
      'role': role,
      'name': name,
      'email': email,
      'isVerified': isVerified,
      'zohoVerified': zohoVerified,
      'zohoContactId': zohoContactId,
      'creditLimit': creditLimit,
      'creditUsed': creditUsed,
      'credit30Allowed': credit30Allowed,
      'credit90Allowed': credit90Allowed,
      'plumberVerificationStatus': plumberVerificationStatus,
      'plumberCertificationNo': plumberCertificationNo,
      'plumberRating': plumberRating,
    };
  }

  @override
  List<Object?> get props => [
        id,
        mobileNumber,
        role,
        name,
        isVerified,
        zohoVerified,
        creditLimit,
        creditUsed,
        credit30Allowed,
        credit90Allowed,
      ];
}
