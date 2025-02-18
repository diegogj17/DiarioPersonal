// lib/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Carta.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'diario.db');
    return await openDatabase(
      path,
      version: 2, // Increment the version number if needed
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cartas (
        description TEXT,
        fechaHora TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE cartas ADD COLUMN fechaHora TEXT');
    }
  }

  Future<void> insertUsuario(String email, String password) async {
    final db = await database;
    await db.insert('usuarios', {'email': email, 'password': password}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> loginUsuario(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return maps.isNotEmpty;
  }

  Future<List<Carta>> getCarta() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cartas');
    return List.generate(maps.length, (i) {
      return Carta.fromMap(maps[i]);
    });
  }

  Future<int> updateCarta(Carta task) async {
    final db = await database;
    return await db.update(
      'cartas',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> insertCarta(Carta carta) async {
    final db = await database;
    await db.insert('cartas', carta.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteCarta(int id) async {
    final db = await database;
    await db.delete('cartas', where: 'id = ?', whereArgs: [id]);
  }
}