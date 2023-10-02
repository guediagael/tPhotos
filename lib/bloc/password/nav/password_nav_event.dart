import 'package:tphotos/bloc/base/navigator/base_nav_event.dart';

class PasswordNavigationSendPasswordEvent extends BaseNavigatorEvent {
  final String password;

  PasswordNavigationSendPasswordEvent(this.password) : super([password]);
}
