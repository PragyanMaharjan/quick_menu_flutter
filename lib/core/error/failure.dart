import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = "Cache failure"]);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = "Auth failure"]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = "Something went wrong"]);
}
