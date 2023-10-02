import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tphotos/action_listeners/phone_login_action_listener.dart';
import 'package:tphotos/bloc/base/data/base_bloc_builder.dart';
import 'package:tphotos/bloc/base/data/base_bloc_listener.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_builder.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_bloc_listener.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_state.dart';
import 'package:tphotos/bloc/phone_number_login/data/phone_number_login_bloc.dart';
import 'package:tphotos/bloc/phone_number_login/data/phone_number_login_even.dart';
import 'package:tphotos/bloc/phone_number_login/data/phone_number_login_state.dart';
import 'package:tphotos/bloc/phone_number_login/nav/phone_number_login_nav_bloc.dart';
import 'package:tphotos/data/data_manager_impl.dart';
import 'package:tphotos/dispatchers/otp_dispatcher.dart';
import 'package:tphotos/dispatchers/password_dispatcher.dart';
import 'package:tphotos/ui/screens/phone_number_login_screen.dart';

class PhoneNumberLoginDispatcher extends StatefulWidget {
  const PhoneNumberLoginDispatcher({super.key});

  @override
  State<StatefulWidget> createState() => _PhoneNumberLoginDispatcherState();

  static Widget buildPhoneNumberLoginScreen() {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => PhoneNumberLoginBloc(
              DataManagerImpl.getInstance().preferencesIdApi),
        ),
        BlocProvider(create: (_) => PhoneNumberLoginNavigationBloc())
      ],
      child: const PhoneNumberLoginDispatcher(),
    );
  }
}

class _PhoneNumberLoginDispatcherState extends State<PhoneNumberLoginDispatcher>
    with PhoneLoginActionListener {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseNavigatorBlocListener(
      bloc: context.read<PhoneNumberLoginNavigationBloc>(),
      navListener: (_, navState) {
        if (navState is PhoneNumberOtpRequiredState) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (ctx) => OtpDispatcher.buildOtpScreen()),
              (route) => false);
        } else if (navState is PhoneNumberPasswordRequiredState) {
          //   Open password screen
        } else if (navState is PhoneNumberSentState) {
          // Open main screen
        }
      },
      child: BaseNavigatorBlocBuilder(
        bloc: context.read<PhoneNumberLoginNavigationBloc>(),
        navigatorBlocWidgetBuilder:
            (BuildContext context, BaseNavigatorState state) {
          return BaseBlocListener(
            bloc: context.read<PhoneNumberLoginBloc>(),
            navigatorBloc: context.read<PhoneNumberLoginNavigationBloc>(),
            listener: (ctx, dataState) {
              if (dataState is PhoneNumberPasswordRequiredState) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (ctx) =>
                            PasswordDispatcher.buildPasswordScreen()),
                    (route) => false);
              } else if (dataState is PhoneNumberOtpRequiredState) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (ctx) => OtpDispatcher.buildOtpScreen()),
                    (route) => false);
              } else if (dataState is PhoneNumberSentState) {
              } else if (dataState is PhoneNumberSendingNumberState) {
              } else if (dataState is PhoneNumberErrorState) {}
            },
            child: BaseBlocBuilder(
                bloc: context.read<PhoneNumberLoginBloc>(),
                builder: (dataCtx, state) {
                  return PhoneNumberLoginScreen(
                      phoneLoginActionListener: this, formKey: _formKey);
                }),
          );
        },
      ),
    );
  }

  @override
  void onSendPressed(String phoneNumber) {
    if (_formKey.currentState?.validate() ?? false) {
      context
          .read<PhoneNumberLoginBloc>()
          .add(PhoneNumberLoginSendEvent(phoneNumber));
    }
  }
}
