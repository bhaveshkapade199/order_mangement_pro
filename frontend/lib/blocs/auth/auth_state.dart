import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthOtpSent extends AuthState {
  final String mobileNumber;
  final String role;
  final String? debugOtp;

  const AuthOtpSent({
    required this.mobileNumber,
    required this.role,
    this.debugOtp,
  });

  @override
  List<Object?> get props => [mobileNumber, role, debugOtp];
}

class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
