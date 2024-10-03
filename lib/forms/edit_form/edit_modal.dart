import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'offline_form_data.db');
    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE formData (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tourId TEXT,
          school TEXT,
          formLabel TEXT,
          data TEXT
        )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertFormData(String tourId, String school, String formLabel, String data) async {
    final db = await database;
    await db.insert('formData', {
      'tourId': tourId,
      'school': school,
      'formLabel': formLabel,
      'data': data,
    });
  }

  Future<List<Map<String, dynamic>>> fetchOfflineFormData(String tourId, String school, String formLabel) async {
    final db = await database;
    return await db.query(
      'formData',
      where: 'tourId = ? AND school = ? AND formLabel = ?',
      whereArgs: [tourId, school, formLabel],
    );
  }

  Future<void> clearFormData() async {
    final db = await database;
    await db.delete('formData');
  }
}
