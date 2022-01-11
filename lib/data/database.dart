import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'diary.dart';

class DatabaseHelper {
  static const _databaseName = "diary.db";
  static const _databaseVersion = 1;
  static const diaryTable = "diary";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // https://stackoverflow.com/a/67053311/7703502
  // Resolve to Database doesn't allow null
  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $diaryTable (
      title String,
      memo String,
      image String,
      date INTEGER DEFAULT 0,
      status INTEGER DEFAULT 0
    )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<int> insertDiary(Diary diary) async {
    Database db = await instance.database;

    List<Diary> d = await getDiaryByDate(diary.date);

    if (d.isEmpty) {
      Map<String, dynamic> row = {
        "title": diary.title,
        "memo": diary.memo,
        "image": diary.image,
        "date": diary.date,
        "status": diary.status,
      };

      return await db.insert(diaryTable, row);
    } else {
      Map<String, dynamic> row = {
        "title": diary.title,
        "memo": diary.memo,
        "image": diary.image,
        "date": diary.date,
        "status": diary.status,
      };

      return await db.update(diaryTable, row, where: "date = ?", whereArgs: [diary.date]);
    }
  }

  Future<List<Diary>> getAllDiary() async {
    Database db = await instance.database;
    List<Diary> diaries = [];

    var queries = await db.query(diaryTable);

    for (var q in queries) {
      diaries.add(
        Diary(
          // sql database 에서 받아오는 결과는 object 로 인식되어 원하는 type 로 재설정해줄 것
          title: q["title"].toString(),
          memo: q["memo"].toString(),
          image: q["image"].toString(),
          date: int.parse(q["date"].toString()),
          status: int.parse(q["status"].toString()),
        ),
      );
    }

    return diaries;
  }

  Future<List<Diary>> getDiaryByDate(int? date) async {
    Database db = await instance.database;
    List<Diary> diaries = [];

    var queries = await db.query(diaryTable, where: "date = ?", whereArgs: [date]);

    for (var q in queries) {
      diaries.add(
        Diary(
          title: q["title"].toString(),
          memo: q["memo"].toString(),
          image: q["image"].toString(),
          date: int.parse(q["date"].toString()),
          status: int.parse(q["status"].toString()),
        ),
      );
    }

    return diaries;
  }
}
