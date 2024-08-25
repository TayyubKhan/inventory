import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseHelper {
  static final LocalDatabaseHelper _instance = LocalDatabaseHelper._internal();
  factory LocalDatabaseHelper() => _instance;
  LocalDatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'invoice.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE invoices(id INTEGER PRIMARY KEY AUTOINCREMENT, data TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertInvoice(String data) async {
    final db = await database;
    await db.insert(
      'invoices',
      {'data': data},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getInvoices() async {
    final db = await database;
    return await db.query('invoices');
  }

  Future<void> deleteInvoice(int id) async {
    final db = await database;
    await db.delete(
      'invoices',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
