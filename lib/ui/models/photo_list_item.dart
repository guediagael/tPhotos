import 'dart:math';

import 'package:tphotos/utils/list_extension.dart';

class PhotoListItem {
  final int photoMessageId;
  final String uri;
  final String? caption;
  final DateTime date;
  final StringList? tags;
  final double? latitude, longitude;
  final bool isSelected;
  final bool isSynced;

  PhotoListItem(
      {required this.photoMessageId,
      this.caption,
      required this.uri,
      required this.date,
      this.isSynced = false,
      this.tags,
      this.longitude,
      this.latitude,
      this.isSelected = false})
      : assert((latitude == null && longitude == null) ||
            (longitude != null && latitude != null));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoListItem &&
          runtimeType == other.runtimeType &&
          uri == other.uri &&
          date == other.date &&
          tags == other.tags &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          photoMessageId == other.photoMessageId &&
          caption == other.caption;

  @override
  int get hashCode =>
      uri.hashCode ^
      date.hashCode ^
      tags.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      photoMessageId.hashCode ^
      caption.hashCode;

  @override
  String toString() {
    return 'PhotoListItem{messageId:$photoMessageId, caption:$caption, uri: $uri, date: $date, latitude: $latitude, longitude: $longitude, isSelected $isSelected, isSynced: $isSynced}';
  }

  PhotoListItem copyWith(
      {String? uri,
      int? photoMessageId,
      String? caption,
      DateTime? date,
      bool? isSynced,
      StringList? tags,
      double? longitude,
      double? latitude,
      bool? isSelected}) {
    return PhotoListItem(
        uri: uri ?? this.uri,
        date: date ?? this.date,
        isSynced: isSynced ?? this.isSynced,
        isSelected: isSelected ?? this.isSelected,
        tags: tags ?? this.tags,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        photoMessageId: photoMessageId ?? this.photoMessageId,
        caption: caption ?? this.caption);
  }
}
