import 'package:l_mobile_sales_mini/data/models/products/product_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_converter.dart';

class DatabaseService {
  static Database? _database;
  final DbConverter dbConverter = DbConverter();

  String dbName = 'l_mini_v1';
  String productsTableName = 'l_mini_products';


  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $productsTableName (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            sku TEXT NOT NULL,
            category TEXT,
            subcategory TEXT,
            description TEXT,
            price REAL NOT NULL,
            tax_rate REAL,
            stock TEXT,            -- Stored as JSON string (List<Stock>)
            unit TEXT,
            packaging TEXT,
            min_order_quantity INTEGER,
            reorder_level INTEGER,
            batch_number INTEGER,  
            serial_number INTEGER, 
            images TEXT,           -- Stored as JSON string (List<String>)
            specifications TEXT,   -- Stored as JSON string (Specifications object)
            related_products TEXT  -- Stored as JSON string (List<String>)
          )
          ''');
      },
    );
  }

  Future<List<Product>> getProductsFromDb() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(productsTableName);
    return maps.map((map) {
      var mutableMap = Map<String, dynamic>.from(map);

      mutableMap['stock'] = DbConverter.decode(mutableMap['stock']);
      mutableMap['images'] = DbConverter.decode(mutableMap['images']);
      mutableMap['specifications'] = DbConverter.decode(mutableMap['specifications']);
      mutableMap['related_products'] = DbConverter.decode(mutableMap['related_products']);
      mutableMap['batch_number'] = DbConverter.intToBool(mutableMap['batch_number']);
      mutableMap['serial_number'] = DbConverter.intToBool(mutableMap['serial_number']);

      return Product.fromJson(mutableMap);
    }).toList();
  }

  Future<void> insertAllProducts(List<Product> products) async {
    final db = await database;
    final batch = db.batch();

    for (var product in products) {
      final data = product.toJson();

      data['stock'] = DbConverter.encode(data['stock']);
      data['images'] = DbConverter.encode(data['images']);
      data['specifications'] = DbConverter.encode(data['specifications']);
      data['related_products'] = DbConverter.encode(data['related_products']);
      data['batch_number'] = DbConverter.boolToInt(product.batchNumber);
      data['serial_number'] = DbConverter.boolToInt(product.serialNumber);

      batch.insert(productsTableName, data, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }
}
