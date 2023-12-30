import 'package:tphotos/bloc/base/data/base_event.dart';

abstract class PasswordEvent extends BaseEvent {
  const PasswordEvent(super.properties);
}

class PasswordSendEvent extends PasswordEvent {
  final String password;

  PasswordSendEvent(this.password) : super([password]);
}
