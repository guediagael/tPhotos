import 'package:tphotos/bloc/base/data/base_state.dart';
import 'package:tphotos/ui/models/photo_list_item.dart';
import 'package:tphotos/ui/models/timelie_group_by.dart';

class TimelineState extends BaseState {
  const TimelineState(super.properties);
}

class TimelineStateInitial extends TimelineState {
  const TimelineStateInitial() : super(const []);
}

class TimelineStateLoading extends TimelineState {
  TimelineStateLoading() : super([]);
}

class TimelineStateLoaded extends TimelineState {
  final Map<DateTime, List<PhotoListItem>> groupedPhotos;
  final TimelineGroupBy zoomLevel;
  final int mediaCount;
  final String? loadingErrorMessage;
  final bool isLastPage;

  TimelineStateLoaded(
      {required this.groupedPhotos,
      required this.zoomLevel,
      required this.mediaCount,
      required this.isLastPage,
      this.loadingErrorMessage})
      : super([
          groupedPhotos.keys,
          groupedPhotos.entries,
          mediaCount,
          loadingErrorMessage,
          isLastPage
        ]);

  TimelineStateLoaded copyWith(
      {Map<DateTime, List<PhotoListItem>>? groupedPhotos,
      TimelineGroupBy? zoomLevel,
      int? mediaCount,
      bool? isLastPage,
      String? loadingErrorMessage}) {
    return TimelineStateLoaded(
        groupedPhotos: groupedPhotos ?? this.groupedPhotos,
        zoomLevel: zoomLevel ?? this.zoomLevel,
        mediaCount: mediaCount ?? this.mediaCount,
        isLastPage: isLastPage ?? this.isLastPage,
        loadingErrorMessage: loadingErrorMessage ?? this.loadingErrorMessage);
  }
}

class TimelineStateRequestSelectFiles extends TimelineState {
  TimelineStateRequestSelectFiles() : super([]);
}

class TimelineStateFoldersSaved extends TimelineState {
  TimelineStateFoldersSaved() : super([]);
}

class TimelineStateFoldersLoaded extends TimelineState {
  final List<String> folders;

  TimelineStateFoldersLoaded(this.folders) : super([folders]);
}
