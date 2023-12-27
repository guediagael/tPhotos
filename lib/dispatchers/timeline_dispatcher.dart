import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/action_listeners/timeline_action_listener.dart';
import 'package:tphotos/bloc/base/data/base_bloc_builder.dart';
import 'package:tphotos/bloc/base/data/base_bloc_listener.dart';
import 'package:tphotos/bloc/base/data/base_state.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_builder.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_listener.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_event.dart';
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
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    debugPrint("timeline_dispatcher::didChangeDependencies");
    context.read<TimelineBloc>().add(TimelineEventLoad(DateTime.now()));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BaseNavigatorBlocListener(
      bloc: context.read<TimelineNavigatorBloc>(),
      navListener: (navContext, navState) {
        if (navState is TimelineNavigatorStateShowFullPicture) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const Text("Details")));
        }
      },
      child: BaseNavigatorBlocBuilder(
        bloc: context.read<TimelineNavigatorBloc>(),
        buildWhenCondition: (prevState, currentState) {
          debugPrint(
              "timeline_dispatcher(BaseNavigatorBlocBuilder)::buildWhenCondition "
              "prevState $prevState "
              "currentState $currentState");
          return !BaseNavigatorBlocBuilder.isCommonNavigatorState(
                  currentState) &&
              ((prevState != currentState) ||
                  (currentState is! TimelineNavigatorStateShowFullPicture));
        },
        navigatorBlocWidgetBuilder:
            (BuildContext context, BaseNavigatorState state) {
          return BaseBlocListener(
            bloc: context.read<TimelineBloc>(),
            navigatorBloc: context.read<TimelineNavigatorBloc>(),
            listener: (context, state) {
              debugPrint("timeline_dispatcher::bloclistener $state");
            },
            child: BaseBlocBuilder(
              bloc: context.read<TimelineBloc>(),
              buildWhenCondition: (prevState, currentState) {
                debugPrint("timeline_dispatcher::buildWhenCondition: prevState:"
                    " $prevState, currentState: $currentState");
                if ((currentState is TimelineStateLoaded) &&
                    (prevState is TimelineStateLoaded)) {
                  debugPrint("prev items: ${prevState.groupedPhotos}");

                  debugPrint("current items: ${currentState.groupedPhotos}");
                }
                return !BaseBlocBuilder.isCommonState(currentState) &&
                    ((prevState != currentState) ||
                        (currentState is TimelineStateInitial));
              },
              builder: (BuildContext context, BaseState state) {
                debugPrint(
                    "timeline_dispatcher::blocBuilder building new $state");
                if (state is TimelineStateInitial ||
                    state is TimelineStateLoading) {
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
                  mediaCount: state.mediaCount,
                  zoomLevel: state.zoomLevel,
                  isLastPage: state.isLastPage,
                  fetchMoreError: state.loadingErrorMessage,
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
    context.read<TimelineBloc>().add(const TimelineEventOnCancelSelections());
  }

  @override
  void onDeleteSelection() {
    debugPrint("timeline_dispatcher::onDeleteSelection");
    context.read<TimelineNavigatorBloc>().add(
        BaseNavigatorEventShowActionableDialog(
            title: "Delete Selected medias",
            errorMessage:
                "It will be deleted from the folder and from telegram.",
            onPositiveTap: () {
              debugPrint(
                  "timeline_dispatcher::onDeleteSelection::onPositiveTap");
              context
                  .read<TimelineBloc>()
                  .add(const TimelineEventDeletePictures());
            },
            onNegativeTap: () {}));
  }

  @override
  void onPhotoLongPress(PhotoListItem photoListItem, DateTime groupDate) {
    context.read<TimelineBloc>().add(TimelineEventOnItemSelected(
        newSelection: photoListItem, groupDate: groupDate));
  }

  @override
  void onPhotoPressed(PhotoListItem photoListItem) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => PhotoDetailsScreen(photoListItem: photoListItem)));
  }

  @override
  void onDatePressed(DateTime dateListItem) {
    context
        .read<TimelineBloc>()
        .add(TimelineEventOnDateItemSelected(newSelection: dateListItem));
  }

  @override
  void onRefresh() {
    // TODO: implement onRefresh
  }

  @override
  void onSortByUpdated(newSorting) {
    context
        .read<TimelineBloc>()
        .add(TimelineEventOnSortUpdated(zoomLevel: newSorting));
  }

  @override
  void loadMore(DateTime dateTime) {
    debugPrint("timeline_dispatcher::loadMore $dateTime");
    context.read<TimelineBloc>().add(TimelineEventLoadMore(dateTime));
  }
}
