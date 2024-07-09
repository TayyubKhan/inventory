import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DropDownDb {
  static final DropDownDb _instance = DropDownDb._internal();
  static Database? _database;

  factory DropDownDb() {
    return _instance;
  }

  DropDownDb._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'invoice_database.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE customers(id TEXT PRIMARY KEY, name TEXT, address TEXT, phone TEXT)',
        );
        db.execute(
          'CREATE TABLE products(id TEXT PRIMARY KEY, name TEXT, price TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertCustomer(Map<String, dynamic> customer) async {
    final db = await database;
    await db.insert('customers', customer, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    await db.insert('products', product, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getCustomers() async {
    final db = await database;
    return db.query('customers');
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return db.query('products');
  }

  Future<void> deleteAllCustomers() async {
    final db = await database;
    await db.delete('customers');
  }

  Future<void> deleteAllProducts() async {
    final db = await database;
    await db.delete('products');
  }
}
