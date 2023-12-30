import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tphotos/data/local/databases/media_database_api.dart';
import 'package:tphotos/data/models/media.dart';

class DatabaseImpl extends MediaDatabase {
  final Database db;
  static const databaseFile = 'media_database.db';

  DatabaseImpl(this.db);

  static Future<DatabaseImpl> open() async {
    String dbPath = await getDatabasesPath();
    String mediaDbPath = join(dbPath, databaseFile);
    Database database =
    await openDatabase(mediaDbPath, onCreate: (db, version) {
      return db.execute('CREATE TABLE ${MediaDatabase.mediaTable} '
          '(${Media.messageIdField} INTEGER, '
          '${Media.mediaHashField} TEXT NOT NULL UNIQUE PRIMARY KEY, '
          '${Media.captionField} TEXT NOT NULL, '
          '${Media.mediaDateField} INTEGER NOT NULL, '
          '${Media.uploadedDateField} INTEGER, '
          '${Media.tgMessageDateField} INTEGER, '
          '${Media.createdDateField} INTEGER NOT NULL, '
          '${Media.fileNameField} TEXT NOT NULL, '
          '${Media.filePathField} TEXT NOT NULL, '
          '${Media.mimeTypeField} TEXT NOT NULL, '
          '${Media.syncAllowedField} INTEGER NOT NULL DEFAULT 1,'
          '${Media.exifDataField} TEXT)');
    }, version: 1);

    return DatabaseImpl(database);
  }

  @override
  Future<void> addMedias(List<Media> medias) async {
    for (Media media in medias) {
      debugPrint("database_impl::addMedias adding media:  $media");
      int added = await db.insert(MediaDatabase.mediaTable, media.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
      debugPrint("database_impl::addMedias  media $media added $added");
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
  Future<void> unSyncMedias(List<Media> medias) async {
    for (Media media in medias) {
      await db.update(MediaDatabase.mediaTable, media.toMap(),
          where: '${Media.mediaDateField} = ?', whereArgs: [media.mediaHash]);
    }
  }

  @override
  Future<List<Media>> loadMedias(DateTime createdDate, {int limit = 20}) async {
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
  Future<List<Media>> loadUploadQueue(int limit, {int offset = 0}) async {
    final List<Map<String, dynamic>> mediasMaps = await db.rawQuery(
        'SELECT * '
            'FROM ${MediaDatabase.mediaTable} WHERE ${Media.uploadedDateField} '
            'IS NULL ORDER BY ${Media
            .uploadedDateField} DESC LIMIT ? OFFSET ? ',
        [limit, offset]);
    return List.generate(
        mediasMaps.length, (index) => Media.fromMap(mediasMaps[index]));
  }

  @override
  Future<int> countQueue() async {
    return db
        .rawQuery(
        'SELECT COUNT(*) as queue FROM ${MediaDatabase.mediaTable} WHERE'
            ' ${Media.uploadedDateField} IS NULL')
        .then((value) => value[0]['queue'] as int);
  }

  @override
  Future<void> updateMedias(List<Media> medias) async {
    for (Media media in medias) {
      await db.update(MediaDatabase.mediaTable, media.toMap(),
          where: '${Media.mediaHashField} = ?', whereArgs: [media.mediaHash]);
    }
  }
}
