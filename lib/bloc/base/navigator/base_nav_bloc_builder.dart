import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_nav_state.dart';
import 'base_navigator_bloc.dart';

class BaseNavigatorBlocBuilder
    extends BlocBuilder<BaseNavigatorBloc, BaseNavigatorState> {
  final BlocBuilderCondition<BaseNavigatorState>? buildWhenCondition;
  final BlocWidgetBuilder<BaseNavigatorState> navigatorBlocWidgetBuilder;

  BaseNavigatorBlocBuilder(
      {Key? key,
      required BaseNavigatorBloc bloc,
      this.buildWhenCondition,
      required this.navigatorBlocWidgetBuilder})
      : super(
            key: key,
            builder: navigatorBlocWidgetBuilder,
            bloc: bloc,
            buildWhen: buildWhenCondition ??
                (BaseNavigatorState prevState, BaseNavigatorState newState) {
                  return (prevState != newState) ||
                      (newState.runtimeType == bloc.initialStateType);
                });

  @override
  Widget build(BuildContext context, BaseNavigatorState state) {
    return builder(context, state);
  }
}
