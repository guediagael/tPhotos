import 'package:flutter/material.dart';
import 'package:tphotos/action_listeners/welcome_action_listener.dart';
import 'package:tphotos/rich_button/rich_button_builder.dart';
import 'package:tphotos/rich_button/rich_button_state_manager.dart';
import 'package:tphotos/ui/widgets/buttons/button_login_loading.dart';
import 'package:tphotos/ui/widgets/buttons/button_login_registration_initial.dart';

class WelcomeScreen extends StatelessWidget {
  final WelcomeActionListener welcomeActionListener;
  final RichButtonState richButtonState;

  const WelcomeScreen(
      {required this.welcomeActionListener,
      required this.richButtonState,
      super.key});

  static Widget buildWelcomeScreen(
      {required BuildContext context,
      required WelcomeActionListener welcomeActionListener,
      required RichButtonState richButtonState,
      Key? key}) {
    return WelcomeScreen(
      key: key,
      welcomeActionListener: welcomeActionListener,
      richButtonState: richButtonState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
              "Welcome To T-Photo, we'll help you to back up your photos"),
          RichButton(
            buttonFacesBuilder: RichButtonBuilder(
              initialStateWidget: const ButtonLoginRegistrationInitial(
                title: "Login/Register",
              ),
              loadingStateWidget: const ButtonLoginLoading(),
              onClick: () {
                debugPrint("welcome_screen::RichButton pressed");
                welcomeActionListener.onButtonPressed();
              },
            ),
            newState: richButtonState,
          )
        ],
      ),
    );
  }
}
