import 'package:tphotos/bloc/base/data/base_state.dart';

abstract class WelcomeState extends BaseState {
  const WelcomeState(super.properties);
}

class WelcomeStateInitial extends WelcomeState {
  const WelcomeStateInitial() : super(const []);
}

class WelcomeStateTokenValid extends WelcomeState {
  const WelcomeStateTokenValid() : super(const []);
}

class WelcomeStateTokenInvalid extends WelcomeState {
  const WelcomeStateTokenInvalid() : super(const []);
}

class WelcomeStateOpenLoginScreen extends WelcomeState {
  const WelcomeStateOpenLoginScreen() : super(const []);
}
