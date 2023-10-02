import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_data_bloc.dart';
import 'base_state.dart';

class BaseBlocBuilder extends BlocBuilder<BaseBloc, BaseState> {
  final BlocBuilderCondition<BaseState>? buildWhenCondition;
  final Function? onRetry;

  BaseBlocBuilder(
      {Key? key,
      required BaseBloc bloc,
      this.buildWhenCondition,
      required BlocWidgetBuilder<BaseState> builder,
      this.onRetry})
      : super(
            key: key,
            builder: builder,
            bloc: bloc,
            buildWhen: buildWhenCondition ??
                (BaseState prevState, BaseState newState) {
                  return (prevState != newState) ||
                      (newState.runtimeType == bloc.initialStateType);
                });

  @override
  Widget build(BuildContext context, BaseState state) {
    return builder(context, state);
  }
}
