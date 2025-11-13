class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Error del servidor']);
  
  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Error de conexión']);
  
  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Error de caché']);
  
  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Error de autenticación']);
  
  @override
  String toString() => message;
}
