import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/InvoiceModel.dart';

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'invoices.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE invoices('
              'id INTEGER PRIMARY KEY AUTOINCREMENT,'
              'order_id TEXT,'
              'discount TEXT,'
              'subtotal TEXT,'
              'grand_total TEXT,'
              'c_name TEXT,'
              'c_address TEXT,'
              'c_phone TEXT,'
              'date TEXT,'
              'user TEXT'
              ')',
        );
      },
    );
  }

  Future<void> insertInvoice(Invoices invoice) async {
    final db = await database;
    await db.insert(
      'invoices',
      invoice.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Invoices>> getInvoices() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('invoices');

    return List.generate(maps.length, (i) {
      return Invoices.fromJson(maps[i]);
    });
  }

  Future<void> deleteInvoices() async {
    final db = await database;
    await db.delete('invoices');
  }
}
