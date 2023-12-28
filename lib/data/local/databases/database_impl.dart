import 'package:sqflite/sqflite.dart';
import 'package:tphotos/data/local/databases/media_database_api.dart';
import 'package:tphotos/data/models/media.dart';
import 'package:path/path.dart';

class DatabaseImpl extends MediaDatabase {
  final Database db;
  static const databaseFile = 'media_database.db';

  DatabaseImpl(this.db);

  static Future<DatabaseImpl> open() async {
    String dbPath = await getDatabasesPath();
    String mediaDbPath = join(dbPath, databaseFile);
    Database database =
        await openDatabase(mediaDbPath, onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE medias (messageId INTEGER, mediaHash TEXT NOT NULL UNIQUE PRIMARY KEY, '
          'caption TEXT NOT NULL, mediaDate INTEGER NOT NULL, uploadedDate INTEGER, tgMessageDate INTEGER, '
          'createdDate INTEGER NOT NULL, fileName TEXT NOT NULL, filePath TEXT NOT NULL, mimetype TEXT NOT NULL)');
    }, version: 1);

    return DatabaseImpl(database);
  }

  @override
  Future<void> addMedias(List<Media> medias) async {
    for (Media media in medias) {
      await db.insert(MediaDatabase.mediaTable, media.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  @override
  Future<void> deleteMedias(List<Media> medias) async {
    for (Media media in medias) {
      await db.delete(MediaDatabase.mediaTable,
          where: '${Media.mediaHashField} = ?', whereArgs: [media.mediaHash]);
    }
  }

  @override
  Future<List<Media>> loadMedias(DateTime createdDate, [int limit = 20]) async {
    final List<Map<String, dynamic>> mediasMaps = await db.query(
        MediaDatabase.mediaTable,
        limit: limit,
        orderBy: Media.mediaDateField,
        where: '${Media.mediaDateField} <= ?',
        whereArgs: [createdDate.millisecondsSinceEpoch]);
    return List.generate(
        mediasMaps.length, (index) => Media.fromMap(mediasMaps[index]));
  }

  @override
  Future<void> updateMedias(List<Media> medias) async {
    for (Media media in medias) {
      await db.update(MediaDatabase.mediaTable, media.toMap(),
          where: '${Media.mediaHashField} = ?', whereArgs: [media.mediaHash]);
    }
  }
}
