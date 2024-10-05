import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'wancho_dictionary.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Table creation statements are unchanged
    await db.execute('''
      CREATE TABLE UpperWancho(
        ID INTEGER PRIMARY KEY,
        "English Word" TEXT,
        "Wancho Word" TEXT,
        "Word Type" TEXT,
        "English Example Sentence" TEXT,
        "Wancho Example Sentence" TEXT,
        "update enable" INTEGER,
        "Version" TEXT,
        "table" TEXT,
        "is_favorite" INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE MiddleWancho(
        ID INTEGER PRIMARY KEY,
        "English Word" TEXT,
        "Wancho Word" TEXT,
        "Word Type" TEXT,
        "English Example Sentence" TEXT,
        "Wancho Example Sentence" TEXT,
        "update enable" INTEGER,
        "Version" TEXT,
        "table" TEXT,
        "is_favorite" INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE LowerWancho(
        ID INTEGER PRIMARY KEY,
        "English Word" TEXT,
        "Wancho Word" TEXT,
        "Word Type" TEXT,
        "English Example Sentence" TEXT,
        "Wancho Example Sentence" TEXT,
        "update enable" INTEGER,
        "Version" TEXT,
        "table" TEXT,
        "is_favorite" INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE VersionControl(
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        Version TEXT,
        LastUpdated DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    await db.insert('VersionControl', {'Version': '1.0'});
    await _loadInitialData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Upgrade logic is unchanged
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE UpperWancho ADD COLUMN "is_favorite" INTEGER DEFAULT 0');
      await db.execute(
          'ALTER TABLE MiddleWancho ADD COLUMN "is_favorite" INTEGER DEFAULT 0');
      await db.execute(
          'ALTER TABLE LowerWancho ADD COLUMN "is_favorite" INTEGER DEFAULT 0');
    }
  }

  Future<void> _loadInitialData(Database db) async {
    String sql = await rootBundle.loadString('assets/sql/initial_data.sql');
    List<String> sqlStatements = sql.split(';');
    for (String statement in sqlStatements) {
      if (statement.trim().isNotEmpty) {
        await db.execute(statement);
      }
    }
  }

  Future<void> insertData(String tableName, Map<String, dynamic> data) async {
    final db = await database;
    await db.execute('''
      INSERT OR REPLACE INTO $tableName (
        "ID",
        "English Word",
        "Wancho Word",
        "Word Type",
        "English Example Sentence",
        "Wancho Example Sentence",
        "update enable",
        "Version",
        "table",
        "is_favorite"
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', [
      data["ID"],
      data["English Word"],
      data["Wancho Word"],
      data["Word Type"],
      data["English Example Sentence"],
      data["Wancho Example Sentence"],
      data["update enable"] ?? 0,
      data["Version"]?.toString() ?? "",
      data["table"] ?? "",
      data["is_favorite"] ?? 0
    ]);
  }

  // Updated fetchData to sort data by "English Word" in a case-insensitive manner
  Future<List<Map<String, dynamic>>> fetchData(String tableName) async {
    final db = await database;
    return await db.query(tableName,
        orderBy: '"English Word" COLLATE NOCASE ASC');
  }

  Future<int> updateData(
      String tableName, Map<String, dynamic> data, int id) async {
    final db = await database;
    return await db.update(tableName, data, where: 'ID = ?', whereArgs: [id]);
  }

  Future<int> deleteData(String tableName, int id) async {
    final db = await database;
    return await db.delete(tableName, where: 'ID = ?', whereArgs: [id]);
  }

  Future<void> clearTable(String tableName) async {
    final db = await database;
    await db.delete(tableName);
  }

  Future<Map<String, dynamic>?> fetchRowById(String tableName, int id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query(tableName, where: 'ID = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<String> getCurrentVersion() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT Version FROM VersionControl ORDER BY ID DESC LIMIT 1');
    return result.isNotEmpty ? result.first['Version'].toString() : '1.0';
  }

  Future<void> updateVersion(String newVersion) async {
    final db = await database;
    await db.insert('VersionControl', {'Version': newVersion});
  }

  Future<bool> isWordFavorite(String tableName, int id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(tableName,
        columns: ['is_favorite'], where: 'ID = ?', whereArgs: [id]);
    return result.isNotEmpty && result.first['is_favorite'] == 1;
  }

  Future<void> toggleFavorite(String tableName, int id, bool isFavorite) async {
    final db = await database;
    await db.update(tableName, {'is_favorite': isFavorite ? 1 : 0},
        where: 'ID = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> fetchFavorites(String tableName) async {
    final db = await database;
    return await db
        .query(tableName, where: '"is_favorite" = ?', whereArgs: [1]);
  }

  Future<int> deleteWordById(String tableName, int id) async {
    final db = await database;
    return await db.delete(tableName, where: 'ID = ?', whereArgs: [id]);
  }
}
