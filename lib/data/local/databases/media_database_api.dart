import 'package:tphotos/data/models/media.dart';

abstract class MediaDatabase{
  static const String mediaTable = "medias";
  Future<void> addMedias(List<Media> medias);
  Future<void> deleteMedias(List<Media> medias);
  Future<void> updateMedias(List<Media> medias);
  Future<List<Media>> loadMedias(DateTime createdDate, {int limit});
  Future<List<Media>> loadUploadQueue(int limit, {int offset});
  Future<int> countQueue();
  Future<void> unSyncMedias(List<Media> medias);
}