
import 'package:tphotos/bloc/base/data/base_event.dart';

abstract class WelcomeEvent extends BaseEvent{
  const WelcomeEvent(List<Object?> properties) : super(properties);
}



class WelcomeEventCheckToken extends WelcomeEvent{
  const WelcomeEventCheckToken() : super(const []);
}

class WelcomeEventLogin extends WelcomeEvent{
  const WelcomeEventLogin():super(const[]);
}
