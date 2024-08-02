import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final List? properties;

  const Failure({this.properties});

  @override
  List<Object?> get props => [properties];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({super.properties});
}

class CacheFailure extends Failure {
  const CacheFailure({super.properties});
}

class InvalidInputFailure extends Failure {}
