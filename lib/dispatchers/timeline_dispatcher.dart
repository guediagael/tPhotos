import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/action_listeners/timeline_action_listener.dart';
import 'package:tphotos/bloc/base/data/base_bloc_builder.dart';
import 'package:tphotos/bloc/base/data/base_bloc_listener.dart';
import 'package:tphotos/bloc/base/data/base_state.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_builder.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_listener.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_state.dart';
import 'package:tphotos/bloc/timeline/data/timeline_bloc.dart';
import 'package:tphotos/bloc/timeline/data/timeline_event.dart';
import 'package:tphotos/bloc/timeline/data/timeline_state.dart';
import 'package:tphotos/bloc/timeline/nav/timeline_nav_bloc.dart';
import 'package:tphotos/bloc/timeline/nav/timeline_nav_state.dart';
import 'package:tphotos/ui/models/photo_list_item.dart';
import 'package:tphotos/ui/screens/photo_details_screen.dart';
import 'package:tphotos/ui/screens/timeline_screen.dart';

class TimelineDispatcher extends StatefulWidget {
  const TimelineDispatcher({super.key});

  @override
  State<StatefulWidget> createState() => _TimelineDispatcherState();

  static Widget buildTimelineScreen({Key? key}) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (_) => TimelineNavigatorBloc()),
      BlocProvider(create: (_) => TimelineBloc())
    ], child: TimelineDispatcher(key: key));
  }
}

class _TimelineDispatcherState extends State<TimelineDispatcher>
    with TimelineActionListener {
  @override
  void didChangeDependencies() {
    context.read<TimelineBloc>().add(TimelineEventLoad(DateTime.now()));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BaseNavigatorBlocListener(
      bloc: context.watch<TimelineNavigatorBloc>(),
      navListener: (navContext, navState) {
        if (navState is TimelineNavigatorStateShowFullPicture) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const Text("Details")));
        }
      },
      child: BaseNavigatorBlocBuilder(
        bloc: context.watch<TimelineNavigatorBloc>(),
        buildWhenCondition: (prevState, currentState) {
          return (prevState != currentState) ||
              (currentState is! TimelineNavigatorStateShowFullPicture);
        },
        navigatorBlocWidgetBuilder:
            (BuildContext context, BaseNavigatorState state) {
          return BaseBlocListener(
            bloc: context.watch<TimelineBloc>(),
            navigatorBloc: context.watch<TimelineNavigatorBloc>(),
            listener: (context, state) {
              debugPrint("timeline_dispatcher::bloclistener $state");
            },
            child: BaseBlocBuilder(
              bloc: context.watch<TimelineBloc>(),
              buildWhenCondition: (prevState, currentState) {
                return (prevState != currentState) ||
                    (currentState is TimelineStateInitial);
              },
              builder: (BuildContext context, BaseState state) {
                debugPrint("timeline_dispatcher::blocBuilder $state");
                if (state is TimelineStateInitial) {
                  return const Scaffold(
                    body: CustomScrollView(
                      shrinkWrap: true,
                      primary: false,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Text("Loading..."),
                        )
                      ],
                    ),
                  );
                }
                return TimelineScreen(
                  timelineActionListener: this,
                  timelinePhotos: (state as TimelineStateLoaded).groupedPhotos,
                  zoomLevel: 1,
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void onCancelSelection() {
    Map<DateTime, List<PhotoListItem>> loadedPhotos =
        (context.read<TimelineBloc>().state as TimelineStateLoaded)
            .groupedPhotos;
    context
        .read<TimelineBloc>()
        .add(TimelineEventOnCancelSelections(loadedPhotos));
  }

  @override
  void onDeleteSelection() {
    Map<DateTime, List<PhotoListItem>> loadedPhotos =
        (context.read<TimelineBloc>().state as TimelineStateLoaded)
            .groupedPhotos;
    context.read<TimelineBloc>().add(TimelineEventDeletePictures(loadedPhotos));
  }

  @override
  void onPhotoLongPress(PhotoListItem photoListItem, DateTime groupDate) {
    Map<DateTime, List<PhotoListItem>> loadedPhotos =
        (context.read<TimelineBloc>().state as TimelineStateLoaded)
            .groupedPhotos;

    context.read<TimelineBloc>().add(TimelineEventOnItemLongPress(
        loadedList: loadedPhotos,
        newSelection: photoListItem,
        groupDate: groupDate));
  }

  @override
  void onPhotoPressed(PhotoListItem photoListItem) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => PhotoDetailsScreen(photoListItem: photoListItem)));
  }

  @override
  void onDatePressed(DateTime dateListItem) {
    Map<DateTime, List<PhotoListItem>> loadedPhotos =
        (context.read<TimelineBloc>().state as TimelineStateLoaded)
            .groupedPhotos;

    context.read<TimelineBloc>().add(TimelineEventOnDateItemPress(
        loadedList: loadedPhotos, newSelection: dateListItem));
  }

  @override
  void onRefresh() {
    // TODO: implement onRefresh
  }

  @override
  void onZoomIn() {
    // TODO: implement onZoomIn
  }

  @override
  void onZoomOut() {
    // TODO: implement onZoomOut
  }
}
