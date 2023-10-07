import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/bloc/base/data/base_data_bloc.dart';
import 'package:tphotos/bloc/base/data/base_state.dart';
import 'package:tphotos/ui/models/photo_list_item.dart';
import 'package:tphotos/ui/models/timelie_group_by.dart';

import 'timeline_event.dart';
import 'timeline_state.dart';

class TimelineBloc extends BaseBloc {
  TimelineBloc() : super(const TimelineStateInitial()) {
    on<TimelineEventLoad>(_loadTimeline);
    on<TimelineEventDeletePictures>(_deletePictures);
    on<TimelineEventOnItemLongPress>(_imagesSelected);
    on<TimelineEventOnCancelSelections>(_onCancelSelections);
    on<TimelineEventOnSortUpdated>(_sortTimeline);
    on<TimelineEventOnDateItemPress>(_dateSelected);
  }

  void _loadTimeline(TimelineEventLoad eventLoad, Emitter<BaseState> emitter) {
    final groupedItems = generateMockList(TimelineGroupBy.month);
    emitter(TimelineStateLoaded(
        groupedPhotos: groupedItems, zoomLevel: TimelineGroupBy.month));
  }

  void _sortTimeline(TimelineEventOnSortUpdated eventOnSortUpdated,
      Emitter<BaseState> emitter) {
    final groupedItems =
        sortList(eventOnSortUpdated.zoomLevel, eventOnSortUpdated.loadedList);
    emitter(TimelineStateLoaded(
        groupedPhotos: groupedItems, zoomLevel: eventOnSortUpdated.zoomLevel));
  }

  void _deletePictures(TimelineEventDeletePictures eventDeletePicture,
      Emitter<BaseState> emitter) {
    final oldGroupedList = eventDeletePicture.loadedList;
    var newGroupedList = <DateTime, List<PhotoListItem>>{};
    for (var key in oldGroupedList.keys) {
      var oldList = oldGroupedList[key];
      var newList = oldList!.where((element) => !element.isSelected);
      if (newList.isNotEmpty) {
        newGroupedList[key] = newList.toList(growable: false);
      }
    }

    emitter(TimelineStateLoaded(
        groupedPhotos: newGroupedList,
        zoomLevel: (state as TimelineStateLoaded).zoomLevel));
  }

  void _dateSelected(TimelineEventOnDateItemPress eventOnDateItemPress,
      Emitter<BaseState> emitter) {
    debugPrint("timeline_bloc::_dateSelected. "
        "loadedList:${eventOnDateItemPress.loadedList}");
    debugPrint("timeline_bloc::_dateSelected. "
        "newSelection: ${eventOnDateItemPress.newSelection}");
    Map<DateTime, List<PhotoListItem>> newItems =
        <DateTime, List<PhotoListItem>>{};
    newItems.addAll(eventOnDateItemPress.loadedList);

    List<PhotoListItem> newList = <PhotoListItem>[];

    bool selection = eventOnDateItemPress
        .loadedList[eventOnDateItemPress.newSelection]!
        .any((element) => !element.isSelected);

    for (var element in eventOnDateItemPress
        .loadedList[eventOnDateItemPress.newSelection]!) {
      newList.add(element.copyWith(isSelected: selection));
    }

    newItems[eventOnDateItemPress.newSelection] = newList;
    DateTime prevDate = DateTime.now().subtract(const Duration(days: 5));
    emitter(TimelineStateLoaded(
        groupedPhotos: newItems,
        zoomLevel: (state as TimelineStateLoaded).zoomLevel));
  }

  void _imagesSelected(TimelineEventOnItemLongPress onItemLongPress,
      Emitter<BaseState> emitter) {
    debugPrint("timeline_bloc::_imagesSelected. "
        "loadedList:${onItemLongPress.loadedList}");
    debugPrint("timeline_bloc::_imagesSelected. "
        "newSelection: ${onItemLongPress.newSelection}");
    Map<DateTime, List<PhotoListItem>> newItems =
        <DateTime, List<PhotoListItem>>{};
    newItems.addAll(onItemLongPress.loadedList);

    List<PhotoListItem> newList = <PhotoListItem>[];
    DateTime key = onItemLongPress.groupDate;
    var value = onItemLongPress.loadedList[key]!;

    newList.addAll(value);
    int index = value.indexOf(value.firstWhere((el) =>
        el.photoMessageId == onItemLongPress.newSelection.photoMessageId));
    debugPrint("timeline_bloc::_imageSelected. found element at index $index");
    PhotoListItem newEl = value.elementAt(index);
    newEl = newEl.copyWith(isSelected: !newEl.isSelected);
    debugPrint("timeline_bloc::_imageSelected Adding element $newEl to list");
    newList[index] = newEl;
    newItems[key] = newList;

    emitter(TimelineStateLoaded(
        groupedPhotos: newItems,
        zoomLevel: (state as TimelineStateLoaded).zoomLevel));
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
    emitter(TimelineStateLoaded(
        groupedPhotos: onCancelSelections.loadedList,
        zoomLevel: (state as TimelineStateLoaded).zoomLevel));
  }

  static Map<DateTime, List<PhotoListItem>> generateMockList(
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
              photoMessageId: messageId,
              uri: "http://via.placeholder.com/200x150",
              date: date..add(Duration(minutes: Random().nextInt(10))));
          ungroupedItem.add(item);
        }
        // debugPrint("Photos items $items");
        // groupedItems["${date.year}/${date.month}/${date.day}"] = items;

        dayDiff--;
      }
    }
    return sortList(zoomLevel, ungroupedItem..sort((a, b) => b.date.compareTo(a.date)));
  }

  static Map<DateTime, List<PhotoListItem>> sortList(
      TimelineGroupBy zoomLevel, List<PhotoListItem> items) {
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
      result[currentDate] =[item];
    }

    return result;
  }
}
