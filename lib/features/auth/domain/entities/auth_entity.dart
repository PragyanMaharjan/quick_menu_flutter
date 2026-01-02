import 'package:equatable/equatable.dart';

/// Domain entity (pure business object)
/// Does NOT know about Hive, passwords, or storage details
class AuthEntity extends Equatable {
  final String? userID;
  final String fullName;
  final String email;
  final String phoneNumber;

  const AuthEntity({
    this.userID,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [
    userID,
    fullName,
    email,
    phoneNumber,
  ];
}
