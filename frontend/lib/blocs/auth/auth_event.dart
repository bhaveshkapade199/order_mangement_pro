import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthSendOtpRequested extends AuthEvent {
  final String mobileNumber;
  final String role;

  const AuthSendOtpRequested({
    required this.mobileNumber,
    required this.role,
  });

  @override
  List<Object?> get props => [mobileNumber, role];
}

class AuthVerifyOtpRequested extends AuthEvent {
  final String mobileNumber;
  final String otp;
  final String role;

  const AuthVerifyOtpRequested({
    required this.mobileNumber,
    required this.otp,
    required this.role,
  });

  @override
  List<Object?> get props => [mobileNumber, otp, role];
}

class AuthLogoutRequested extends AuthEvent {}
