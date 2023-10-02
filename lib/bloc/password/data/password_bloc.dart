import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/bloc/base/data/base_data_bloc.dart';
import 'package:tphotos/bloc/base/data/base_state.dart';
import 'package:tphotos/data/local/preferences/preferences_id_api.dart';

import 'password_event.dart';
import 'password_state.dart';

class PasswordBloc extends BaseBloc {
  PasswordBloc(PreferencesIdApi preferencesIdApi)
      : super(const PasswordLoginStateInitial(), preferencesIdApi) {
    on<PasswordSendEvent>(_onSendPassword);
  }

  void _onSendPassword(PasswordSendEvent passwordLoginSendEvent,
      Emitter<BaseState> emitter) {
    // emitter(PasswordSentState());
    emitter(PasswordOtpRequiredState());
  }
}