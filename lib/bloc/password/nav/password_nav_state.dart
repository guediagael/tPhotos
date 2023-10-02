import 'package:tphotos/bloc/base/navigator/base_nav_state.dart';

class PasswordNavigationInitialState extends BaseNavigatorState {
  const PasswordNavigationInitialState() : super(const []);
}

class PasswordNavigationErrorState extends BaseNavigatorState {
  final String errorMessage;

  PasswordNavigationErrorState(this.errorMessage)
      : super([errorMessage]);
}

class PasswordNavigationCodeNeededState extends BaseNavigatorState {
  const PasswordNavigationCodeNeededState() : super(const []);
}