import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tphotos/action_listeners/otp_action_listener.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_builder.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_listener.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_event.dart';
import 'package:tphotos/bloc/opt/nav/otp_nav_bloc.dart';
import 'package:tphotos/dispatchers/main_dispatcher.dart';
import 'package:tphotos/rich_button/rich_button_state_manager.dart';
import 'package:tphotos/ui/screens/otp_screen.dart';

class OtpDispatcher extends StatefulWidget {
  const OtpDispatcher({super.key});

  static Widget buildOtpScreen() {
    return MultiProvider(
      providers: [BlocProvider(create: (_) => OtpNavigationBloc())],
      child: const OtpDispatcher(),
    );
  }

  @override
  State<StatefulWidget> createState() => _OtpDispatcherState();
}

class _OtpDispatcherState extends State<OtpDispatcher> with OtpActionListener {
  final RichButtonState _richButtonState = RichButtonState.initial;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseNavigatorBlocListener(
      bloc: context.read<OtpNavigationBloc>(),
      navListener: (_, navState) {},
      child: BaseNavigatorBlocBuilder(
        bloc: context.read<OtpNavigationBloc>(),
        navigatorBlocWidgetBuilder: (ctx, state) {
          return OtpScreen(
              otpActionListener: this,
              buttonState: _richButtonState,
              formKey: _formKey);
        },
      ),
    );
  }

  @override
  void onResendOtpPressed() {
    debugPrint("otp_dispatcher::onResendOtpPressed");
  }

  @override
  void onReturnToRegistration() {
    context.read<OtpNavigationBloc>().add(const BaseNavigatorEventShowLogin());
  }

  @override
  void onSendPressed(String opt) {
    debugPrint("otp_dispatcher::onSendPressed $opt");
    if (_formKey.currentState?.validate() ?? false) {
      debugPrint("otp_dispatcher::onSendPressed otp valid");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (ctx) => MainScreenDispatcher.buildMainScreen()),
          (route) => false);
    }
  }
}
