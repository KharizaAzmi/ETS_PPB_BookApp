import 'package:sqflite/sqflite.dart';
import 'package:bookshelf/db/book_database.dart';
import 'package:bookshelf/model/book.dart';

class BookDB {
  final tableName = 'book';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
    "id" INTEGER NOT NULL,
    "image" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "date" INTEGER NOT NULL,
    "description" TEXT NOT NULL,
    PRIMARY KEY("id" AUTOINCREMENT)
    );""");
  }

  Future<int> create({required String title}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tableName (title) VALUES (?)''',
    );
  }

  Future<List<Book>> fetchAll() async {
    final database = await DatabaseService().database;
    final books = await database.rawQuery(
        '''SELECT * from $tableName''');
    return books.map((book) => Book.fromSqfliteDatabase(book)).toList();
  }

  Future<Book> fetchId(int id) async {
    final database = await DatabaseService().database;
    final book = await database.rawQuery(
        '''SELECT * from $tableName WHERE id = ?''', [id]);
    return Book.fromSqfliteDatabase(book.first);
  }

  Future<int> update({required int id, String? title}) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        if (title != null) 'title': title,
      },
      where:  'id = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete('''DELETE FROM $tableName WHERE id = ?''', [id]);
  }

}