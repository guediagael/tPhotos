import 'package:tphotos/bloc/base/navigator/base_nav_event.dart';

class PhoneNumberLoginNavigationSendNumberEvent extends BaseNavigatorEvent {
  final String phoneNumber;

  PhoneNumberLoginNavigationSendNumberEvent(this.phoneNumber)
      : super([phoneNumber]);
}
