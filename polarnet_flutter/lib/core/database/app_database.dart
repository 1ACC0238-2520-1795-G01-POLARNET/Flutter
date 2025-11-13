import 'dart:developer' as developer;

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase _instance = AppDatabase._();
  factory AppDatabase() => _instance;

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database as Database;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'polarnet.db');
    developer.log('📁 Ruta de la base de datos: $path', name: 'PolarNet');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla de usuarios
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        full_name TEXT,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        company_name TEXT,
        phone TEXT,
        location TEXT,
        created_at TEXT
      )
    ''');

    /* Tabla de equipos
    await db.execute('''
      CREATE TABLE equipment (
        id INTEGER PRIMARY KEY,
        providerId INTEGER NOT NULL,
        name TEXT NOT NULL,
        brand TEXT,
        model TEXT,
        category TEXT NOT NULL,
        description TEXT,
        thumbnail TEXT,
        specifications TEXT,
        available INTEGER NOT NULL,
        location TEXT,
        pricePerMonth REAL NOT NULL,
        purchasePrice REAL NOT NULL,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');

    // Tabla de solicitudes de servicio
    await db.execute('''
      CREATE TABLE service_requests (
        id INTEGER PRIMARY KEY,
        clientId INTEGER NOT NULL,
        equipmentId INTEGER NOT NULL,
        requestType TEXT NOT NULL,
        description TEXT,
        startDate TEXT,
        endDate TEXT,
        status TEXT NOT NULL,
        totalPrice REAL NOT NULL,
        notes TEXT,
        createdAt TEXT
      )
    ''');

    // Tabla de equipos del cliente
    await db.execute('''
      CREATE TABLE client_equipment (
        id INTEGER PRIMARY KEY,
        clientId INTEGER NOT NULL,
        equipmentId INTEGER NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT,
        status TEXT NOT NULL
      )
    ''');*/
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('users');
    await db.delete('equipment');
    await db.delete('service_requests');
    await db.delete('client_equipment');
  }

  Future<void> resetDatabase() async {
    final path = join(await getDatabasesPath(), 'polarnet.db');
    await deleteDatabase(path);
    developer.log('🧨 Base de datos local borrada', name: 'PolarNet');
    _database = null; // Limpia la referencia actual
    await _initDatabase();
  }
}
