import 'package:equatable/equatable.dart';

abstract class BaseNavigatorState extends Equatable {
  final List<Object?> props;

  const BaseNavigatorState(this.props);
}

class BaseNavigatorStatePop extends BaseNavigatorState {
  const BaseNavigatorStatePop() : super(const []);
}

class BaseNavigatorStateShowActionableDialog extends BaseNavigatorState {
  final String title;
  final String errorMessage;
  final Function onPositiveTap;
  final Function onNegativeTap;

  BaseNavigatorStateShowActionableDialog(
      {required this.onPositiveTap,
      required this.onNegativeTap,
      required this.title,
      required this.errorMessage})
      : super([title, errorMessage]);
}

class BaseNavigatorStateShowActionableErrorDialog extends BaseNavigatorState {
  final String title;
  final String errorMessage;
  final Function onPositiveTap;
  final Function onNegativeTap;

  BaseNavigatorStateShowActionableErrorDialog(
      {required this.onPositiveTap,
      required this.onNegativeTap,
      required this.title,
      required this.errorMessage})
      : super([title, errorMessage]);
}

class BaseNavigatorStateShowInfoDialog extends BaseNavigatorState {
  final String title;
  final String errorMessage;
  final Function onPositiveTap;

  BaseNavigatorStateShowInfoDialog(
      {required this.onPositiveTap,
      required this.title,
      required this.errorMessage})
      : super([title, errorMessage]);
}

class BaseNavigatorStateShowErrorInfoDialog extends BaseNavigatorState {
  final String title;
  final String errorMessage;
  final Function onPositiveTap;

  BaseNavigatorStateShowErrorInfoDialog(
      {required this.onPositiveTap,
      required this.title,
      required this.errorMessage})
      : super([title, errorMessage]);
}

class BaseNavigatorStateLogout extends BaseNavigatorState {
  const BaseNavigatorStateLogout() : super(const []);
}

class BaseNavigatorStateShowSnackBar extends BaseNavigatorState {
  final String message;

  BaseNavigatorStateShowSnackBar(this.message) : super([message]);
}

class BaseNavigatorStateShowLoading extends BaseNavigatorState {
  const BaseNavigatorStateShowLoading() : super(const []);
}

class BaseNavigatorStateShowLogin extends BaseNavigatorState {
  const BaseNavigatorStateShowLogin() : super(const []);
}
