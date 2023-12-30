import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_nav_state.dart';
import 'base_navigator_bloc.dart';

class BaseNavigatorBlocBuilder
    extends BlocBuilder<BaseNavigatorBloc, BaseNavigatorState> {
  final BlocBuilderCondition<BaseNavigatorState>? buildWhenCondition;
  final BlocWidgetBuilder<BaseNavigatorState> navigatorBlocWidgetBuilder;

  BaseNavigatorBlocBuilder(
      {super.key,
      required BaseNavigatorBloc super.bloc,
      this.buildWhenCondition,
      required this.navigatorBlocWidgetBuilder})
      : super(
            builder: navigatorBlocWidgetBuilder,
            buildWhen: buildWhenCondition ??
                (BaseNavigatorState prevState, BaseNavigatorState newState) {
                  return !isCommonNavigatorState(newState) &&
                      ((prevState != newState) ||
                          (newState.runtimeType == bloc.initialStateType));
                });

  @override
  Widget build(BuildContext context, BaseNavigatorState state) {
    return builder(context, state);
  }

  static bool isCommonNavigatorState(BaseNavigatorState state) {
    return (state.runtimeType == BaseNavigatorStatePop) ||
        (state.runtimeType == BaseNavigatorStateShowSnackBar) ||
        (state.runtimeType == BaseNavigatorStateShowActionableDialog) ||
        (state.runtimeType == BaseNavigatorStateShowActionableErrorDialog) ||
        (state.runtimeType == BaseNavigatorStateShowInfoDialog) ||
        (state.runtimeType == BaseNavigatorStateShowErrorInfoDialog) ||
        (state.runtimeType == BaseNavigatorStateShowLoading) ||
        (state.runtimeType == BaseNavigatorStateLogout) ||
        (state.runtimeType == BaseNavigatorStateShowLogin);
  }
}
