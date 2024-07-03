import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'cross_border_ecommerce.db');
    print('Database path: $path'); // 添加这行来打印路径
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId TEXT,
            productName TEXT,
            status TEXT,
            image TEXT,
            brand TEXT,
            price TEXT,
            original_price TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertOrder(Map<String, String> order) async {
    final db = await database;
    await db.insert('orders', order);
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final db = await database;
    return await db.query('orders');
  }

  Future<void> updateOrder(int id, Map<String, String> order) async {
    final db = await database;
    await db.update('orders', order, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteOrder(int id) async {
    final db = await database;
    await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }
}
