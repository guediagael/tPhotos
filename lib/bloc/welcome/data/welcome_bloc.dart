import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/bloc/base/data/base_data_bloc.dart';
import 'package:tphotos/bloc/base/data/base_state.dart';
import 'package:tphotos/data/local/preferences/preferences_id_api.dart';

import 'welcome_event.dart';
import 'welcome_state.dart';

class WelcomeBloc extends BaseBloc {
  WelcomeBloc(PreferencesIdApi preferencesIdApi)
      : super(const WelcomeStateInitial(), preferencesIdApi) {
    on<WelcomeEventCheckToken>(_checkToken);
    on<WelcomeEventLogin>(_triggerLogin);
  }

  void _checkToken(WelcomeEventCheckToken welcomeEventCheckToken,
      Emitter<BaseState> emitter) {
    if (super.preferencesIdApi!.getSessionId() != null &&
        super.preferencesIdApi!.getToken() != null) {
      emitter(const WelcomeStateTokenValid());
    } else {
      emitter(const WelcomeStateTokenInvalid());
    }
  }

  void _triggerLogin(
      WelcomeEventLogin welcomeEventLogin, Emitter<BaseState> emitter) {
    emitter(const WelcomeStateOpenLoginScreen());
  }
}
