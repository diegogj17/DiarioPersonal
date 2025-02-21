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
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'diario.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cartas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        fechaHora TEXT,
        userId INTEGER,
        FOREIGN KEY (userId) REFERENCES usuarios(id)
      )
    ''');
  }

  Future<int> idPorEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return maps.first['id'] as int;
    }
    return 0;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE cartas ADD COLUMN fechaHora TEXT');
    }
  }

  Future<int?> insertUsuario(String email, String password) async {
    final db = await database;
    final id = await db.insert(
        'usuarios', {'email': email, 'password': password},
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int?> loginUsuario(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      return maps.first['id'] as int?;
    }
    return null;
  }

  Future<List<Carta>> getCarta(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cartas',
      where: 'userId = ?',
      whereArgs: [userId],
    );
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
    await db.insert('cartas', carta.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteCarta(int id) async {
    final db = await database;
    await db.delete('cartas', where: 'id = ?', whereArgs: [id]);
  }
}
