import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'customer_model.dart';

class CustomerDatabaseHelper {
  static final CustomerDatabaseHelper _instance = CustomerDatabaseHelper._internal();

  factory CustomerDatabaseHelper() {
    return _instance;
  }

  CustomerDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'customers.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE customers(
            id TEXT PRIMARY KEY,
            name TEXT,
            phone TEXT,
            address TEXT,
            area TEXT,
            owner TEXT,
            cnic TEXT,
            day TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertCustomer(CustomerModel customer) async {
    final db = await database;
    await db.insert(
      'customers',
      customer.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CustomerModel>> getCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return List.generate(maps.length, (i) {
      return CustomerModel.fromJson(maps[i]);
    });
  }

  Future<void> deleteCustomers() async {
    final db = await database;
    await db.delete('customers');
  }
}
