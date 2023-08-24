import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'UserInfo.dart';

class DataBase {
  static final _databaseName = 'user_database.db';
  static final _databaseVersion = 1;

  static final users = 'users';
  static final userId = 'userId';
  static final firstName = 'first_name';
  static final lastName = 'last_name';
  static final dateOfBirth = 'date_of_birth';

  DataBase.privateConstructor();
  static final DataBase instance = DataBase.privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDB('users.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
 final dbPath = await getDatabasesPath();
 final path = join(dbPath, filePath);

 return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $users (
        $userId TEXT PRIMARY KEY,
        $firstName TEXT NOT NULL,
        $lastName TEXT NOT NULL,
        $dateOfBirth TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertUser(UserInfo user) async {
    await _database!.insert(users, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<UserInfo>> getAllUsers() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> maps = await db!.query(users);
    return List.generate(maps.length, (i) {
      return UserInfo.fromMap(maps[i]);
    });
  }

  Future<void> deleteUser(String userId) async {
    final db = await instance.database;
    await db!.delete('users', where: 'userId = ?', whereArgs: [userId]);
  }
}
