import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_state.dart';
import 'package:tphotos/bloc/base/navigator/base_navigator_bloc.dart';

import 'welcome_nav_event.dart';
import 'welcome_nav_state.dart';

class WelcomeNavigatorBloc extends BaseNavigatorBloc {
  WelcomeNavigatorBloc() : super(const WelComeNavigatorStateInitial()) {
    on<WelcomeNavigationEventCheckCredentials>(_onCheckCredentials);
    on<WelcomeNavigationEventOpenPhoneNumberLogin>(_onOpenPhoneNumberLogin);
  }

  void _onCheckCredentials(
      WelcomeNavigationEventCheckCredentials navigationEventCheckCredentials,
      Emitter<BaseNavigatorState> emitter) {}

  void _onOpenPhoneNumberLogin(
      WelcomeNavigationEventOpenPhoneNumberLogin
          navigationEventOpenPhoneNumberLogin,
      Emitter<BaseNavigatorState> emitter) {
    emitter(const BaseNavigatorStateShowLogin());
  }
}
