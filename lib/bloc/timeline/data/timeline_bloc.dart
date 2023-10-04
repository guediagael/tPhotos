import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/bloc/base/data/base_data_bloc.dart';
import 'package:tphotos/bloc/base/data/base_state.dart';
import 'package:tphotos/ui/models/photo_list_item.dart';

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
    final groupedItems = generateMockList(1);
    DateTime lastDate = DateTime.now().subtract(const Duration(days: 5));
    emitter(TimelineStateLoaded(
        prevLastDate: lastDate, groupedPhotos: groupedItems));
  }

  void _sortTimeline(TimelineEventOnSortUpdated eventOnSortUpdated,
      Emitter<BaseState> emitter) {
    final groupedItems = generateMockList(eventOnSortUpdated.zoomLevel);
    DateTime lastDate = DateTime.now().subtract(const Duration(days: 5));
    emitter(TimelineStateLoaded(
        prevLastDate: lastDate, groupedPhotos: groupedItems));
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

    DateTime prevDate = DateTime.now().subtract(const Duration(days: 5));

    emitter(TimelineStateLoaded(
        prevLastDate: prevDate, groupedPhotos: newGroupedList));
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
    emitter(
        TimelineStateLoaded(prevLastDate: prevDate, groupedPhotos: newItems));
  }

  void _imagesSelected(TimelineEventOnItemLongPress onItemLongPress,
      Emitter<BaseState> emitter) {
    debugPrint("timeline_bloc::_imagesSelected. "
        "loadedList:${onItemLongPress.loadedList}");
    debugPrint("timeline_bloc::_imagesSelected. "
        "newSelection: ${onItemLongPress.newSelection}");
    Map<DateTime, List<PhotoListItem>> newItems = onItemLongPress.loadedList;

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

    DateTime prevDate = DateTime.now().subtract(const Duration(days: 5));
    emitter(
        TimelineStateLoaded(prevLastDate: prevDate, groupedPhotos: newItems));
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
    DateTime lastDate = DateTime.now().subtract(const Duration(days: 5));
    emitter(TimelineStateLoaded(
        prevLastDate: lastDate, groupedPhotos: onCancelSelections.loadedList));
  }

  static Map<DateTime, List<PhotoListItem>> generateMockList(int zoomLevel) {
    DateTime start = DateTime.now().subtract(const Duration(days: 4));
    DateTime end = DateTime.now();
    Set<int> photoIds = HashSet<int>();

    final groupedItems = <DateTime, List<PhotoListItem>>{};
    var dayDiff = end.difference(start).inDays;
    while (dayDiff > 0) {
      final items = <PhotoListItem>[];
      final date = DateTime.now().add(Duration(days: dayDiff));
      for (int i = 0; i < 5; i++) {
        int messageId = Random().nextInt(200) + Random().nextInt(100);
        while (photoIds.contains(messageId)) {
          messageId = Random().nextInt(200) + Random().nextInt(100);
        }
        photoIds.add(messageId);

        var item = PhotoListItem(
            photoMessageId: messageId,
            uri: "http://via.placeholder.com/200x150",
            date: date..add(Duration(minutes: Random().nextInt(10))));
        items.add(item);
      }
      debugPrint("Photos items $items");
      // groupedItems["${date.year}/${date.month}/${date.day}"] = items;
      groupedItems[date] = items;

      dayDiff--;
    }
    return groupedItems;
  }

  static Map<DateTime, List<PhotoListItem>> sortList(
      int zoomLevel, List<PhotoListItem> items) {
    DateTime start = DateTime.now().subtract(const Duration(days: 4));
    DateTime end = DateTime.now();
    Set<int> photoIds = HashSet<int>();

    final groupedItems = <DateTime, List<PhotoListItem>>{};
    var dayDiff = end.difference(start).inDays;
    while (dayDiff > 0) {
      final items = <PhotoListItem>[];
      final date = DateTime.now().add(Duration(days: dayDiff));
      for (int i = 0; i < 5; i++) {
        int messageId = Random().nextInt(200) + Random().nextInt(100);
        while (photoIds.contains(messageId)) {
          messageId = Random().nextInt(200) + Random().nextInt(100);
        }
        photoIds.add(messageId);
        var item = PhotoListItem(
            photoMessageId: messageId,
            uri: "http://via.placeholder.com/200x150",
            date: date..add(Duration(minutes: Random().nextInt(10))));
        items.add(item);
      }
      // groupedItems["${date.year}/${date.month}/${date.day}"] = items;
      groupedItems[date] = items;

      dayDiff--;
    }
    return groupedItems;
  }
}
