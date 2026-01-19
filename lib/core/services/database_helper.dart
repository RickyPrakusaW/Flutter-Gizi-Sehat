import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gizi_sehat.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        doctorId TEXT PRIMARY KEY,
        name TEXT,
        specialty TEXT,
        imageUrl TEXT,
        rating REAL,
        price TEXT
      )
    ''');
  }

  Future<void> addFavorite(Map<String, dynamic> doctor) async {
    final db = await instance.database;
    await db.insert(
      'favorites',
      {
        'doctorId': doctor['id'],
        'name': doctor['name'],
        'specialty': doctor['specialty'],
        'imageUrl': doctor['imageUrl'],
        'rating': doctor['rating'],
        'price': doctor['price'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String doctorId) async {
    final db = await instance.database;
    await db.delete(
      'favorites',
      where: 'doctorId = ?',
      whereArgs: [doctorId],
    );
  }

  Future<bool> isFavorite(String doctorId) async {
    final db = await instance.database;
    final maps = await db.query(
      'favorites',
      where: 'doctorId = ?',
      whereArgs: [doctorId],
    );
    return maps.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await instance.database;
    return await db.query('favorites');
  }
}
