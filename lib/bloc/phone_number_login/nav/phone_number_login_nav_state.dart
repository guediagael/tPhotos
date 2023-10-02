import 'package:tphotos/bloc/base/navigator/base_nav_state.dart';

class PhoneNumberLoginNavigationInitialState extends BaseNavigatorState {
  const PhoneNumberLoginNavigationInitialState() : super(const []);
}

class PhoneNumberLoginNavigationErrorState extends BaseNavigatorState {
  final String errorMessage;

  PhoneNumberLoginNavigationErrorState(this.errorMessage)
      : super([errorMessage]);
}

class PhoneNumberLoginNavigationCodeNeededState extends BaseNavigatorState {
  const PhoneNumberLoginNavigationCodeNeededState() : super(const []);
}

class PhoneNumberLoginNavigationCodePasswordNeededState
    extends BaseNavigatorState {
  const PhoneNumberLoginNavigationCodePasswordNeededState() : super(const []);
}
