import 'package:tphotos/bloc/base/data/base_event.dart';

abstract class PhoneNumberLoginEvent extends BaseEvent {
  const PhoneNumberLoginEvent(List<Object?> properties) : super(properties);
}

class PhoneNumberLoginSendEvent extends PhoneNumberLoginEvent {
  final String phoneNumber;

  PhoneNumberLoginSendEvent(this.phoneNumber) : super([phoneNumber]);
}
