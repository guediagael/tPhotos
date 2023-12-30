import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tphotos/action_listeners/password_action_listener.dart';
import 'package:tphotos/bloc/base/data/base_bloc_builder.dart';
import 'package:tphotos/bloc/base/data/base_bloc_listener.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_builder.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_listener.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_event.dart';
import 'package:tphotos/bloc/password/data/password_bloc.dart';
import 'package:tphotos/bloc/password/data/password_event.dart';
import 'package:tphotos/bloc/password/data/password_state.dart';
import 'package:tphotos/bloc/password/nav/password_nav_bloc.dart';
import 'package:tphotos/data/data_manager_impl.dart';
import 'package:tphotos/dispatchers/otp_dispatcher.dart';
import 'package:tphotos/rich_button/rich_button_state_manager.dart';
import 'package:tphotos/ui/screens/password_screen.dart';

class PasswordDispatcher extends StatefulWidget {
  const PasswordDispatcher({super.key});

  @override
  State<StatefulWidget> createState() => _PasswordDispatcherState();

  static Widget buildPasswordScreen() {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => PasswordNavigationBloc()),
        BlocProvider(
            create: (_) =>
                PasswordBloc(DataManagerImpl.getInstance().preferencesIdApi))
      ],
      child: const PasswordDispatcher(),
    );
  }
}

class _PasswordDispatcherState extends State<PasswordDispatcher>
    with PasswordActionListener {
  late final RichButtonState _sendPasswordRichButtonState =
      RichButtonState.initial;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseNavigatorBlocListener(
      bloc: context.read<PasswordNavigationBloc>(),
      navListener: (_, __) {},
      child: BaseNavigatorBlocBuilder(
        bloc: context.read<PasswordNavigationBloc>(),
        navigatorBlocWidgetBuilder: (navCtx, navState) {
          return BaseBlocListener(
            bloc: context.read<PasswordBloc>(),
            navigatorBloc: context.read<PasswordNavigationBloc>(),
            listener: (ctx, state) {
              if (state is PasswordOtpRequiredState) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (ctx) => OtpDispatcher.buildOtpScreen()),
                    (route) => false);
              }
            },
            child: BaseBlocBuilder(
              bloc: context.read<PasswordBloc>(),
              builder: (context, state) {
                return PasswordScreen(
                    passwordActionListener: this,
                    buttonState: _sendPasswordRichButtonState,
                    formKey: _formKey);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void onReturnToRegistration() {
    context
        .read<PasswordNavigationBloc>()
        .add(const BaseNavigatorEventShowLogin());
  }

  @override
  void onSendPressed(String password) {
    if (_formKey.currentState?.validate() ?? false) {
      debugPrint("password_screen::onSendPressed password non empty $password");
      context.read<PasswordBloc>().add(PasswordSendEvent(password));
    }
  }
}
