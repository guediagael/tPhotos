import 'package:equatable/equatable.dart';

import 'base_nav_state.dart';

abstract class BaseNavigatorEvent extends Equatable {
  final List<Object?> props;

  const BaseNavigatorEvent(this.props);
}

class BaseNavigatorEventShowLoading extends BaseNavigatorEvent {
  const BaseNavigatorEventShowLoading() : super(const []);
}

class BaseNavigatorEventPop extends BaseNavigatorEvent {
  final BaseNavigatorState previousState;

  BaseNavigatorEventPop(this.previousState) : super([previousState]);
}

class BaseNavigatorEventLogout extends BaseNavigatorEvent {
  BaseNavigatorEventLogout() : super([]);
}

class BaseNavigatorEventShowActionableDialog extends BaseNavigatorEvent {
  final String title;
  final String errorMessage;
  final Function onPositiveTap;
  final Function onNegativeTap;

  BaseNavigatorEventShowActionableDialog(
      {required this.title,
      required this.errorMessage,
      required this.onPositiveTap,
      required this.onNegativeTap})
      : super([title, errorMessage, onPositiveTap, onNegativeTap]);
}

class BaseNavigatorEventShowActionableErrorDialog extends BaseNavigatorEvent {
  final String title;
  final String errorMessage;
  final Function onPositiveTap;
  final Function onNegativeTap;

  BaseNavigatorEventShowActionableErrorDialog(
      {required this.title,
      required this.errorMessage,
      required this.onPositiveTap,
      required this.onNegativeTap})
      : super([title, errorMessage, onPositiveTap, onNegativeTap]);
}

class BaseNavigatorEventShowSnackBar extends BaseNavigatorEvent {
  final String message;

  BaseNavigatorEventShowSnackBar(this.message) : super([message]);
}

class BaseNavigatorShowInfoDialog extends BaseNavigatorEvent {
  final String title;
  final String errorMessage;
  final Function onPositiveTap;

  BaseNavigatorShowInfoDialog(
      {required this.title,
      required this.errorMessage,
      required this.onPositiveTap})
      : super([title, errorMessage, onPositiveTap]);
}

class BaseNavigatorShowErrorInfoDialog extends BaseNavigatorEvent {
  final String title;
  final String errorMessage;
  final Function onPositiveTap;

  BaseNavigatorShowErrorInfoDialog(
      {required this.title,
      required this.errorMessage,
      required this.onPositiveTap})
      : super([title, errorMessage, onPositiveTap]);
}

class BaseNavigatorEventShowLogin extends BaseNavigatorEvent{
  const BaseNavigatorEventShowLogin(): super(const[]);
}
