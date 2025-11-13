import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_dto.dart';

abstract class AuthLocalDataSource {
  Future<UserDto?> getCachedUser();
  Future<void> cacheUser(UserDto user);
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final AppDatabase database;

  AuthLocalDataSourceImpl(this.database);

  @override
  Future<UserDto?> getCachedUser() async {
    try {
      final db = await database.database;
      final maps = await db.query('users', limit: 1);
      
      if (maps.isEmpty) return null;
      
      return UserDto.fromDatabase(maps.first);
    } catch (e) {
      throw CacheException('Error al obtener usuario de caché');
    }
  }

  @override
  Future<void> cacheUser(UserDto user) async {
    try {
      final db = await database.database;
      await db.delete('users'); // Clear previous user
      await db.insert('users', user.toDatabase());
    } catch (e) {
      throw CacheException('Error al guardar usuario en caché');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final db = await database.database;
      await db.delete('users');
    } catch (e) {
      throw CacheException('Error al limpiar caché');
    }
  }
}
