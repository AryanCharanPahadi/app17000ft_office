import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseHelper {
  static final LocalDatabaseHelper _instance = LocalDatabaseHelper._internal();

  factory LocalDatabaseHelper() => _instance;

  LocalDatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'app_data.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE formData(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tourId TEXT,
            school TEXT,
            formLabel TEXT,
            data TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertFormData(String tourId, String school, String formLabel, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      'formData',
      {
        'tourId': tourId,
        'school': school,
        'formLabel': formLabel,
        'data': jsonEncode(data),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllFormData() async {
    final db = await database;
    return await db.query('formData');
  }

  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('formData');
  }
}
