import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "test15_Database.db";
  static const _databaseVersion = 1;

  static const table = 'data_table';
  static const columnId = 'id';
  static const columnImage = 'image';
  static const columnMarkerImage = 'markerImage';
  static const columnDate = 'date';
  static const columnPosition = 'position';
  static const columnAddress = 'address';
  static const columnComment = 'comment';
  static const columnTag = 'tag';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnImage TEXT,
            $columnMarkerImage TEXT,
            $columnDate TEXT,
            $columnPosition TEXT,
            $columnAddress TEXT,
            $columnComment TEXT,
            $columnTag TEXT
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

// add database row
  Future<void> addData(List<String> addData) async {
    // [image,date,address,comment]
    final imagePath = addData[0];
    final markerImagePath = addData[1];
    final date = addData[2];
    final position = addData[3];
    final address = addData[4];
    final comment = addData[5];
    final tag = addData[6];

    final row = {
      DatabaseHelper.columnImage: imagePath,
      DatabaseHelper.columnMarkerImage: markerImagePath,
      DatabaseHelper.columnDate: date,
      DatabaseHelper.columnPosition: position,
      DatabaseHelper.columnAddress: address,
      DatabaseHelper.columnComment: comment,
      DatabaseHelper.columnTag: tag,
    };

    Database db = await instance.database;
    final id = await db.insert(table, row);

    print('挿入された行のid: $id');
    print(
        '挿入されたデータ: \n$imagePath \n$markerImagePath \n$date \n$position \n$address \n$comment \n$tag');
  }

// get database
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

// latest Data
  Future<List<Map<String, dynamic>>> queryLatestRows() async {
    Database db = await instance.database;
    return await db.query(
      table,
      orderBy: '$columnDate DESC',
    );
  }

// update comment
  Future<int> updateComment(int id, String comment) async {
    Database db = await instance.database;
    return await db.update(
      table,
      {columnComment: comment},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

// update tag
  Future<int> updateTag(int id, String tag) async {
    Database db = await instance.database;
    return await db.update(
      table,
      {columnTag: tag},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

// delete row
  Future<int> deleteRow(int id) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

// Total Records
  Future<String> getTotal() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT COUNT(*) as count FROM $table');

    return maps.first['count'].toString();
  }

// Total by Tag
  Future<String> getTagCount(String tagColor) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $table WHERE $columnTag = "$tagColor"');

    return maps.first['count'].toString();
  }

// find by Id
  Future<Map<String, dynamic>?> findById(int? id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }
}
