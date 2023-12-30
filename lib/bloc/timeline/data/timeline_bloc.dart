import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:tphotos/bloc/base/data/base_data_bloc.dart';
import 'package:tphotos/bloc/base/data/base_state.dart';
import 'package:tphotos/data/data_manager_impl.dart';
import 'package:tphotos/data/models/media.dart';
import 'package:tphotos/ui/models/photo_list_item.dart';
import 'package:tphotos/ui/models/timelie_group_by.dart';
import 'package:crypto/crypto.dart';

import 'timeline_event.dart';
import 'timeline_state.dart';

class TimelineBloc extends BaseBloc {
  TimelineBloc() : super(const TimelineStateInitial()) {
    on<TimelineEventLoad>(_loadTimeline);
    on<TimelineEventDeletePictures>(_deletePictures);
    on<TimelineEventOnItemSelected>(_imagesSelected);
    on<TimelineEventOnCancelSelections>(_onCancelSelections);
    on<TimelineEventOnSortUpdated>(_sortTimeline);
    on<TimelineEventOnDateItemSelected>(_dateSelected);
    on<TimelineEventLoadMore>(_loadMoreItems);

    on<TimelineEventLoadFolders>(_onRequestPermissions);
    on<TimelineEventFoldersUpdated>(_onFoldersUpdated);
  }

  Future<void> _loadTimeline(
      TimelineEventLoad eventLoad, Emitter<BaseState> emitter) async {
    debugPrint("Timeline_bloc::_loadTimeline bloc: $eventLoad");
    List<String> rootPaths =
        DataManagerImpl.getInstance().preferencesSettingsApi.getSyncedFolders();
    debugPrint("Timeline_bloc rootPathsIsEmpty ${rootPaths.isEmpty}");
    if (rootPaths.isEmpty) {
      final MapEntry<int, Map<DateTime, List<PhotoListItem>>> groupedItems =
          generateMockList(TimelineGroupBy.month);
      emitter(TimelineStateLoaded(
          groupedPhotos: groupedItems.value,
          mediaCount: groupedItems.key,
          isLastPage: false,
          zoomLevel: TimelineGroupBy.month));
    } else {
      debugPrint("Timeline_bloc rootPaths $rootPaths");
      debugPrint("Timeline_bloc emitter is done ${emitter.isDone}");
      List<FileSystemEntity> files =
          await _loadFiles(eventLoad.initialDate, rootPaths);
      final MapEntry<int, Map<DateTime, List<PhotoListItem>>> groupedItems =
          MapEntry(
              files.length,
              sortList(
                  TimelineGroupBy.month,
                  files
                      .map((e) => PhotoListItem(
                          // photoMessageId: e.path,
                          date: e.statSync().modified,
                          localPath: e.path))
                      .toList()));
      debugPrint("Timeline_bloc emitter is done ${emitter.isDone}");
      if (!emitter.isDone) {
        emitter(TimelineStateLoaded(
            groupedPhotos: groupedItems.value,
            mediaCount: groupedItems.key,
            isLastPage: true, //TODO: Remove this and add pagination
            zoomLevel: TimelineGroupBy.month));
      }
    }
  }

  void _loadMoreItems(
      TimelineEventLoadMore loadMoreEvent, Emitter<BaseState> emitter) {
    final oldList = (state as TimelineStateLoaded).groupedPhotos;
    final zoomLevel = (state as TimelineStateLoaded).zoomLevel;
    bool shouldLoadMore = Random().nextBool();
    if (shouldLoadMore) {
      final sortedNewItems = generateMore(loadMoreEvent.initialDate, zoomLevel);
      if (((zoomLevel == TimelineGroupBy.year) &&
              oldList.keys.last.year == sortedNewItems.key.year) ||
          ((zoomLevel == TimelineGroupBy.month) &&
              (oldList.keys.last.year == sortedNewItems.key.year) &&
              (oldList.keys.last.month == sortedNewItems.key.month)) ||
          ((zoomLevel == TimelineGroupBy.day) &&
              (oldList.keys.last.year == sortedNewItems.key.year) &&
              (oldList.keys.last.month == sortedNewItems.key.month) &&
              (oldList.keys.last.day == sortedNewItems.key.day))) {
        oldList[oldList.keys.last]!.addAll(sortedNewItems.value);
      } else {
        oldList.addEntries([sortedNewItems]);
      }
      emitter((state as TimelineStateLoaded)
          .copyWith(groupedPhotos: oldList, isLastPage: true));
    } else {
      emitter((state as TimelineStateLoaded)
          .copyWith(loadingErrorMessage: "Failed to load more"));
    }
  }

  void _sortTimeline(TimelineEventOnSortUpdated eventOnSortUpdated,
      Emitter<BaseState> emitter) {
    final groupedItems = sortList(
        eventOnSortUpdated.zoomLevel,
        (state as TimelineStateLoaded)
            .groupedPhotos
            .values
            .reduce((value, element) => value + element));
    final newLoadedState = (state as TimelineStateLoaded).copyWith(
        groupedPhotos: groupedItems, zoomLevel: eventOnSortUpdated.zoomLevel);

    emitter(newLoadedState);
  }

  void _deletePictures(TimelineEventDeletePictures eventDeletePicture,
      Emitter<BaseState> emitter) {
    // final oldGroupedList = eventDeletePicture.loadedList;
    final oldGroupedList = (state as TimelineStateLoaded).groupedPhotos;
    var newGroupedList = <DateTime, List<PhotoListItem>>{};
    int itemCount = 0;
    for (var key in oldGroupedList.keys) {
      var oldList = oldGroupedList[key];
      var newList = oldList!.where((element) => !element.isSelected);
      if (newList.isNotEmpty) {
        newGroupedList[key] = newList.toList(growable: false);
      }
      itemCount += newList.length;
    }

    final newLoadedState = (state as TimelineStateLoaded)
        .copyWith(groupedPhotos: newGroupedList, mediaCount: itemCount);
    emitter(newLoadedState);
  }

  void _dateSelected(TimelineEventOnDateItemSelected eventOnDateItemPress,
      Emitter<BaseState> emitter) {
    Map<DateTime, List<PhotoListItem>> loadedMedias =
        (state as TimelineStateLoaded).groupedPhotos;

    debugPrint("timeline_bloc::_dateSelected. "
        "loadedList:$loadedMedias");
    debugPrint("timeline_bloc::_dateSelected. "
        "newSelection: ${eventOnDateItemPress.newSelection}");
    Map<DateTime, List<PhotoListItem>> newItems =
        <DateTime, List<PhotoListItem>>{};
    newItems.addAll(loadedMedias);

    List<PhotoListItem> newList = <PhotoListItem>[];

    bool selection = loadedMedias[eventOnDateItemPress.newSelection]!
        .any((element) => !element.isSelected);

    for (var element in loadedMedias[eventOnDateItemPress.newSelection]!) {
      newList.add(element.copyWith(isSelected: selection));
    }

    newItems[eventOnDateItemPress.newSelection] = newList;

    final newState =
        (state as TimelineStateLoaded).copyWith(groupedPhotos: newItems);
    emitter(newState);
  }

  void _imagesSelected(
      TimelineEventOnItemSelected onItemLongPress, Emitter<BaseState> emitter) {
    Map<DateTime, List<PhotoListItem>> loadedMedias =
        (state as TimelineStateLoaded).groupedPhotos;
    debugPrint("timeline_bloc::_imagesSelected. "
        "loadedList:$loadedMedias");
    debugPrint("timeline_bloc::_imagesSelected. "
        "newSelection: ${onItemLongPress.newSelection}");
    Map<DateTime, List<PhotoListItem>> newItems =
        <DateTime, List<PhotoListItem>>{};
    newItems.addAll(loadedMedias);

    List<PhotoListItem> newList = <PhotoListItem>[];
    DateTime key = onItemLongPress.groupDate;
    var value = loadedMedias[key]!;

    newList.addAll(value);
    int index = value.indexOf(value.firstWhere((el) =>
        el.photoMessageId == onItemLongPress.newSelection.photoMessageId));
    debugPrint("timeline_bloc::_imageSelected. found element at index $index");
    PhotoListItem newEl = value.elementAt(index);
    newEl = newEl.copyWith(isSelected: !newEl.isSelected);
    debugPrint("timeline_bloc::_imageSelected Adding element $newEl to list");
    newList[index] = newEl;
    newItems[key] = newList;

    final newState =
        (state as TimelineStateLoaded).copyWith(groupedPhotos: newItems);
    emitter(newState);
  }

  void _onCancelSelections(TimelineEventOnCancelSelections onCancelSelections,
      Emitter<BaseState> emitter) {
    (state as TimelineStateLoaded).groupedPhotos.forEach((k, v) {
      for (int index = 0; index < v.length; index++) {
        PhotoListItem el = v.elementAt(index);
        el = el.copyWith(isSelected: false);
        v[index] = el;
      }
    });

    final newState = (state as TimelineStateLoaded).copyWith();
    emitter(newState);
  }

  static MapEntry<int, Map<DateTime, List<PhotoListItem>>> generateMockList(
      TimelineGroupBy zoomLevel) {
    Set<int> photoIds = HashSet<int>();

    List<DateTime> groups = [];
    groups.add(DateTime(2022, 12, 10));
    groups.add(DateTime(2023, 1, 14));
    groups.add(DateTime(2023, 2, 10));

    final ungroupedItem = <PhotoListItem>[];

    for (int i = 0; i < groups.length; i++) {
      DateTime start = groups[i];
      DateTime end;
      if (i < 2) {
        end = groups[i + 1];
      } else {
        end = groups[i].add(const Duration(days: 10));
      }
      var dayDiff = end.difference(start).inDays;
      while (dayDiff > 0) {
        final date = start.add(Duration(days: dayDiff));
        for (int j = 0; j < 5; j++) {
          int messageId = Random().nextInt(200) + Random().nextInt(100);
          while (photoIds.contains(messageId)) {
            messageId = Random().nextInt(2000) + Random().nextInt(100);
          }
          photoIds.add(messageId);

          var item = PhotoListItem(
              photoMessageId: messageId.toString(),
              uri: "http://via.placeholder.com/200x150",
              date: date..add(Duration(minutes: Random().nextInt(10))));
          ungroupedItem.add(item);
        }
        dayDiff--;
      }
    }
    return MapEntry(
        ungroupedItem.length,
        sortList(zoomLevel,
            ungroupedItem..sort((a, b) => b.date.compareTo(a.date))));
  }

  static MapEntry<DateTime, List<PhotoListItem>> generateMore(
      DateTime dateTime, TimelineGroupBy zoomLevel) {
    DateTime start = dateTime;
    DateTime end = dateTime.add(const Duration(days: 3));
    Set<int> photoIds = HashSet<int>();
    final ungroupedItem = <PhotoListItem>[];

    var dayDiff = end.difference(start).inDays;
    while (dayDiff > 0) {
      final date = start.add(Duration(days: dayDiff));
      for (int j = 0; j < 5; j++) {
        int messageId = Random().nextInt(200) + Random().nextInt(100) + 301;
        while (photoIds.contains(messageId)) {
          messageId = Random().nextInt(2000) + Random().nextInt(100) + 2101;
        }
        photoIds.add(messageId);

        var item = PhotoListItem(
            photoMessageId: messageId.toString(),
            uri: "http://via.placeholder.com/200x150",
            date: date..add(Duration(minutes: Random().nextInt(10))));
        ungroupedItem.add(item);
      }
      dayDiff--;
    }
    return sortList(
            zoomLevel, ungroupedItem..sort((a, b) => b.date.compareTo(a.date)))
        .entries
        .first;
  }

  static Map<DateTime, List<PhotoListItem>> sortList(
      TimelineGroupBy zoomLevel, List<PhotoListItem> items) {
    if (items.isEmpty) return {};
    DateTime currentDate = items.first.date;
    Map<DateTime, List<PhotoListItem>> result = {};
    result[currentDate] = [];

    for (PhotoListItem item in items) {
      if (zoomLevel == TimelineGroupBy.year) {
        if (currentDate.year == item.date.year) {
          result[currentDate]!.add(item);
          continue;
        }
      } else if (zoomLevel == TimelineGroupBy.month) {
        if (currentDate.month == item.date.month) {
          result[currentDate]!.add(item);
          continue;
        }
      } else {
        if (currentDate.day == item.date.day) {
          result[currentDate]!.add(item);
          continue;
        }
      }
      currentDate = item.date;
      result[currentDate] = [item];
    }

    return result;
  }

  void _onRequestPermissions(
      TimelineEventLoadFolders eventLoadFolders, Emitter<BaseState> emitter) {}

  void _onFoldersUpdated(TimelineEventFoldersUpdated eventFoldersUpdated,
      Emitter<BaseState> emitter) {
    DataManagerImpl.getInstance()
        .preferencesSettingsApi
        .updateSyncedFoldersList(eventFoldersUpdated.folders);

    emitter(TimelineStateFoldersSaved());
  }

  Future<List<FileSystemEntity>> _loadFiles(
      DateTime loadFrom, List<String> rootPaths) async {
    debugPrint(
        "timeline_bloc::_loadFiles from date $loadFrom in rootPath: $rootPaths");
    List<FileSystemEntity> result = [];
    for (String path in rootPaths) {
      Directory folder = Directory(path);
      debugPrint("timeline_bloc::_loadFiles folder: $folder");
      if (folder.existsSync()) {
        for (FileSystemEntity fileSystemEntity
            in folder.listSync(recursive: true)) {
          debugPrint("timeline_bloc::_loadFiles file ${fileSystemEntity.path}");
          String mimeType = lookupMimeType(fileSystemEntity.path) ?? "";
          debugPrint("timeline_bloc::_loadFiles file mime $mimeType");
          var value = await fileSystemEntity.stat();
          debugPrint(
              "timeline_bloc::_loadFiles file stats ${value.toString()}");
          if ((value.modified.compareTo(loadFrom) <= 0 &&
                  (value.type == FileSystemEntityType.file) &&
                  (mimeType.startsWith('image')) ||
              (mimeType.startsWith('video')))) {
            result.add(fileSystemEntity);
            if (kDebugMode) {
              var exifData =
                  await readExifFromFile(File(fileSystemEntity.path));
              debugPrint("timeline_bloc::_loadFiles file exif $exifData");
            }
          }
          if (result.length > 50) {
            return result;
          }
        }
      } else {
        debugPrint("timeline_bloc::_loadFiles folder $folder doesn't exist");
      }
    }
    return result;
  }
}
