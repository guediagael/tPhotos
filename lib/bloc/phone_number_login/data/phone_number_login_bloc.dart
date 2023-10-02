import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/bloc/base/data/base_data_bloc.dart';
import 'package:tphotos/bloc/base/data/base_state.dart';
import 'package:tphotos/bloc/phone_number_login/data/phone_number_login_even.dart';
import 'package:tphotos/data/local/preferences/preferences_id_api.dart';

import 'phone_number_login_state.dart';

class PhoneNumberLoginBloc extends BaseBloc {
  PhoneNumberLoginBloc(PreferencesIdApi preferencesIdApi)
      : super(const PhoneNumberLoginStateInitial(), preferencesIdApi) {
    on<PhoneNumberLoginSendEvent>(_onSendPhoneNumber);
  }

  void _onSendPhoneNumber(PhoneNumberLoginSendEvent phoneNumberLoginSendEvent,
      Emitter<BaseState> emitter) {
    // emitter(PhoneNumberSentState());
    // emitter(PhoneNumberOtpRequiredState());
    emitter(PhoneNumberPasswordRequiredState());
  }
}
