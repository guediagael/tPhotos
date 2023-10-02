import 'package:tphotos/bloc/base/data/base_state.dart';

abstract class PasswordLoginState extends BaseState {
  const PasswordLoginState(List<Object?> properties) : super(properties);
}

class PasswordLoginStateInitial extends PasswordLoginState {
  const PasswordLoginStateInitial() : super(const []);
}

class PasswordSendingPasswordState extends PasswordLoginState {
  PasswordSendingPasswordState() : super([]);
}

class PasswordErrorState extends PasswordLoginState {
  final String error;

  PasswordErrorState(this.error) : super([error]);
}

class PasswordSentState extends PasswordLoginState {
  PasswordSentState() : super([]);
}

class PasswordOtpRequiredState extends PasswordLoginState {
  PasswordOtpRequiredState() : super([]);
}