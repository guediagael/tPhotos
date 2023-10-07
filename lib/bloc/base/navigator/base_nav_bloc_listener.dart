import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_event.dart';
import 'package:tphotos/copyable_mixin.dart';
import 'package:tphotos/dispatchers/phone_number_dispatcher.dart';
import 'package:tphotos/dispatchers/welcome_dispatcher.dart';
import 'package:tphotos/ui/screens/loading.dart';
import 'package:tphotos/ui/widgets/dialogs/dialog_alert.dart';
import 'package:tphotos/ui/widgets/dialogs/dialog_binary_action.dart';

import 'base_nav_state.dart';
import 'base_navigator_bloc.dart';

class BaseNavigatorBlocListener<B extends BaseNavigatorBloc,
    S extends BaseNavigatorState> extends BlocListener with CopyableWidget {
  final B bloc;
  final Widget? child;

  BaseNavigatorBlocListener(
      {Key? key,
      required this.bloc,
      this.child,
      required BlocWidgetListener<S> navListener})
      : super(
            key: key,
            bloc: bloc,
            child: child,
            listener: (context, state) async {
              debugPrint("new State ($state) detected in $context");
              if (state is BaseNavigatorStatePop) {
                Navigator.pop(context);
              } else if (state is BaseNavigatorStateShowSnackBar) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                ));
              } else if (state is BaseNavigatorStateShowActionableDialog) {
                showDialog(
                    context: context,
                    builder: (ctx) => DialogBinaryAction(
                          alertMessage: state.errorMessage,
                          alertTitle: state.title,
                          onPositivePress: () {
                            debugPrint(
                                "base_nav_bloc_listener::BaseNavigatorBlocListener::"
                                "listener->\n state: "
                                "BaseNavigatorStateShowActionableDialog ->"
                                " dialog closed on positive tap");
                            bloc.add(BaseNavigatorEventPop(state));
                            state.onPositiveTap();
                          },
                          onNegativePress: () {
                            debugPrint(
                                "base_nav_bloc_listener::BaseNavigatorBlocListener::"
                                "listener->\n state: "
                                "BaseNavigatorStateShowActionableDialog ->"
                                " dialog closed on negative tap");
                            bloc.add(BaseNavigatorEventPop(state));
                            state.onNegativeTap();
                          },
                        ));
                //     .then((value) {
                //   debugPrint(
                //       "base_nav_bloc_listener::BaseNavigatorBlocListener::"
                //           "listener->\n state: "
                //           "BaseNavigatorStateShowActionableDialog ->"
                //           " dialog closed with value:$value");
                //   if (value != null && value == true) {
                //     bloc.add(BaseNavigatorEventPop(state));
                //     state.onPositiveTap();
                //   } else {
                //     bloc.add(BaseNavigatorEventPop(state));
                //     state.onNegativeTap();
                //   }
                // });
              } else if (state is BaseNavigatorStateShowActionableErrorDialog) {
                showDialog(
                    context: context,
                    builder: (ctx) => DialogBinaryAction(
                          alertMessage: state.errorMessage,
                          alertTitle: state.title,
                          titleColor: Colors.red,
                          onPositivePress: () {
                            debugPrint(
                                "base_nav_bloc_listener::BaseNavigatorBlocListener::"
                                "listener->\n state: "
                                "BaseNavigatorStateShowActionableErrorDialog ->"
                                " dialog closed on positive tap");
                            bloc.add(BaseNavigatorEventPop(state));
                            state.onPositiveTap();
                          },
                          onNegativePress: () {
                            debugPrint(
                                "base_nav_bloc_listener::BaseNavigatorBlocListener::"
                                "listener->\n state: "
                                "BaseNavigatorStateShowActionableErrorDialog ->"
                                " dialog closed on negative tap");
                            bloc.add(BaseNavigatorEventPop(state));
                            state.onNegativeTap();
                          },
                        ));
                //   .then((value) {
                // debugPrint(
                //     "base_nav_bloc_listener::BaseNavigatorBlocListener::"
                //     "listener->\n state: "
                //     "BaseNavigatorStateShowActionableErrorDialog ->"
                //     " dialog closed with value:$value");
                // if (value != null && value == true) {
                //   state.onPositiveTap();
                // } else {
                //   state.onNegativeTap();
                // }
                // }
                // );
              } else if (state is BaseNavigatorStateShowInfoDialog) {
                showDialog(
                    context: context,
                    builder: (ctx) => DialogAlert(
                        alertMessage: state.errorMessage,
                        onOkayPressed: () => state.onPositiveTap(),
                        alertTitle: state.title));
              } else if (state is BaseNavigatorStateShowErrorInfoDialog) {
                showDialog(
                    context: context,
                    builder: (ctx) => DialogAlert(
                          alertMessage: state.errorMessage,
                          onOkayPressed: () => state.onPositiveTap(),
                          alertTitle: state.title,
                          titleColor: Colors.red,
                        ));
              } else if (state is BaseNavigatorStateShowLoading) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const LoadingScreen()));
              } else if (state is BaseNavigatorStateLogout) {
                final packageInfo = await PackageInfo.fromPlatform();
                final appVersion = packageInfo.version;

                final keysFile =
                    await rootBundle.loadString('secrets/keys.json');
                final keys = await json.decode(keysFile);
                final tgHash = keys['telegram_api_hash'];
                final tgAppId = keys['telegram_app_id'];

                final welcomeScreen = WelcomeDispatcher.buildWelcomeScreen(
                    apiHash: tgHash,
                    appVersion: appVersion,
                    applicationId: tgAppId);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (ctx) => welcomeScreen),
                    (route) => false);
              } else if (state is BaseNavigatorStateShowLogin) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PhoneNumberLoginDispatcher
                            .buildPhoneNumberLoginScreen()),
                    (route) => false);
              } else {
                navListener(context, state);
              }
            });

  @override
  Widget copyWith(Widget child) {
    return BlocListener(listener: listener, key: key, bloc: bloc, child: child);
  }
}
