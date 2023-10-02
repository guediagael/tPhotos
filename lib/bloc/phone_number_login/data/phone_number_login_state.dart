import 'package:tphotos/bloc/base/data/base_state.dart';

abstract class PhoneNumberLoginState extends BaseState {
  const PhoneNumberLoginState(List<Object?> properties) : super(properties);
}

class PhoneNumberLoginStateInitial extends PhoneNumberLoginState {
  const PhoneNumberLoginStateInitial() : super(const []);
}

class PhoneNumberSendingNumberState extends PhoneNumberLoginState {
  PhoneNumberSendingNumberState() : super([]);
}

class PhoneNumberErrorState extends PhoneNumberLoginState {
  final String error;

  PhoneNumberErrorState(this.error) : super([error]);
}

class PhoneNumberSentState extends PhoneNumberLoginState {
  PhoneNumberSentState() : super([]);
}

class PhoneNumberOtpRequiredState extends PhoneNumberLoginState {
  PhoneNumberOtpRequiredState() : super([]);
}

class PhoneNumberPasswordRequiredState extends PhoneNumberLoginState {
  PhoneNumberPasswordRequiredState() : super([]);
}
