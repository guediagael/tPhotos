import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/bloc/base/data/base_state.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_event.dart';
import 'package:tphotos/bloc/base/navigator/base_navigator_bloc.dart';
import 'package:tphotos/copyable_mixin.dart';

import 'base_data_bloc.dart';
import 'base_event.dart';

class BaseBlocListener<E extends BaseEvent, S extends BaseState>
    extends BlocListener with CopyableWidget {
  BaseBlocListener(
      {Key? key,
      required BaseBloc bloc,
      required BaseNavigatorBloc navigatorBloc,
      required BlocWidgetListener<S> listener,
      Widget? child})
      : super(
            key: key,
            bloc: bloc,
            child: child,
            listener: (context, state) {
              debugPrint("base_bloc_listener::listener().state $state");
              if (state is SendErrorState) {
                navigatorBloc.add(BaseNavigatorShowErrorInfoDialog(
                    title: "Error",
                    errorMessage: state.errorMessage,
                    onPositiveTap: state.onOkPressed != null
                        ? () => state.onOkPressed!()
                        : () => navigatorBloc
                            .add(BaseNavigatorEventPop(navigatorBloc.state))));
              } else if (state is DialogSessionExpired) {
                navigatorBloc.add(BaseNavigatorShowErrorInfoDialog(
                    title: state.title ?? "Error",
                    errorMessage: state.errorMessage ??
                        "Session Expired.\n You will be redirected to login screen",
                    onPositiveTap: () => state.onPositiveTap()));
              } else if (state is DialogLongErrorState) {
                navigatorBloc.add(BaseNavigatorShowErrorInfoDialog(
                    title: state.title ?? "Error",
                    errorMessage:
                        state.errorMessage ?? "Something bad happened",
                    onPositiveTap: () => state.onPositiveTap()));
              } else if (state is SnackBarShortErrorState) {
                navigatorBloc
                    .add(BaseNavigatorEventShowSnackBar(state.errorMessage));
              } else if (state is ScreenErrorState) {
                navigatorBloc.add(BaseNavigatorEventShowActionableErrorDialog(
                    title: "Error ! 😥",
                    errorMessage: state.errorMessage,
                    onPositiveTap: () => state.onRetryPressed(),
                    onNegativeTap: () => navigatorBloc
                        .add(BaseNavigatorEventPop(navigatorBloc.state))));
              } else if (state is SendToLoginState) {
                debugPrint("base_bloc_listener Sending to Login");
                navigatorBloc.add(BaseNavigatorEventLogout());
              } else if (state is RequestPermissionState) {
                navigatorBloc.add(BaseNavigatorEventRequestFoldersPermissions(
                    state.callback));
              } else {
                listener(context, state);
              }
            });

  @override
  BlocListener copyWith(Widget child) {
    return BlocListener(key: key, bloc: bloc, listener: listener, child: child);
  }
}
