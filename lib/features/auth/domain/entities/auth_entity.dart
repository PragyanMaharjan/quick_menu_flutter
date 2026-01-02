import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userID;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? password;

  const AuthEntity({
    this.userID,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.password,
  });

  @override
  List<Object?> get props => [
    userID,
    fullName,
    email,
    phoneNumber,
    password,
  ];
}
