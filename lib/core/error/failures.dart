abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);

  @override
  toString() => message;
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);

  @override
  toString() => message;
}

class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);

  @override
  toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);

  @override
  toString() => message;
} 