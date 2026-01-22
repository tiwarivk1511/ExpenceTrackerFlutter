import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:expence_tracker/models/expense_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expenses.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _onUpgradeDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE expenses (
  id $idType,
  userId $intType,
  title $textType,
  amount $doubleType,
  date $textType,
  imageUrl TEXT,
  isSynced $boolType
)
''');
  }

  void _onUpgradeDB(Database db, int oldVersion, int newVersion) {
    if (oldVersion < 2) {
      db.execute("ALTER TABLE expenses ADD COLUMN userId INTEGER NOT NULL DEFAULT 0");
    }
  }

  Future<void> insertExpense(Expense expense) async {
    final db = await instance.database;
    await db.insert(
      'expenses',
      toMap(expense),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await instance.database;
    await db.update(
      'expenses',
      toMap(expense),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<void> deleteExpense(String id) async {
    final db = await instance.database;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Expense>> getExpenses(int userId) async {
    final db = await instance.database;
    final maps = await db.query(
      'expenses',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
    });
  }

  Map<String, dynamic> toMap(Expense expense) {
    return {
      'id': expense.id,
      'userId': expense.userId,
      'title': expense.title,
      'amount': expense.amount,
      'date': expense.date.toIso8601String(),
      'imageUrl': expense.imageUrl,
      'isSynced': expense.isSynced ? 1 : 0,
    };
  }

  Expense fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      userId: map['userId'] as int,
      title: map['title'] as String,
      amount: map['amount'] as double,
      date: DateTime.parse(map['date'] as String),
      imageUrl: map['imageUrl'] as String?,
      isSynced: (map['isSynced'] as int) == 1,
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
