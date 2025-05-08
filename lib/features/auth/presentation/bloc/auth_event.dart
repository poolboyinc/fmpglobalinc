import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class GoogleSignInRequested extends AuthEvent {}

class AppleSignInRequested extends AuthEvent {}

class EmailSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const EmailSignUpRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

class EmailSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const EmailSignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignOutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
