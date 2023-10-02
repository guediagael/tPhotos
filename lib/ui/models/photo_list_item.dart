import 'dart:math';

import 'package:tphotos/utils/list_extension.dart';

class PhotoListItem {
  final String uri;
  final DateTime date;
  final StringList? tags;
  final double? latitude, longitude;
  final bool isSelected;

  PhotoListItem(
      {required this.uri,
      required this.date,
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
          longitude == other.longitude;

  @override
  int get hashCode =>
      uri.hashCode ^
      date.hashCode ^
      tags.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;

  @override
  String toString() {
    return 'PhotoListItem{uri: $uri, date: $date, latitude: $latitude, longitude: $longitude}';
  }
}
