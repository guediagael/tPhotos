import 'package:flutter/material.dart';
import 'package:tphotos/action_listeners/otp_action_listener.dart';
import 'package:tphotos/rich_button/rich_button_builder.dart';
import 'package:tphotos/rich_button/rich_button_state_manager.dart';
import 'package:tphotos/ui/widgets/buttons/button_login_loading.dart';
import 'package:tphotos/ui/widgets/buttons/button_login_registration_initial.dart';

class OtpScreen extends StatelessWidget {
  final OtpActionListener otpActionListener;
  final RichButtonState buttonState;
  final GlobalKey formKey;
  final TextEditingController _optController = TextEditingController();

  OtpScreen(
      {super.key,
      required this.otpActionListener,
      required this.buttonState,
      required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Form(
                    key: formKey,
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: "****"),
                        validator: (value) {
                          if ((value?.isEmpty ?? true) || value!.length < 4) {
                            return "Input Required (4 digits)";
                          }
                          return null;
                        },
                        controller: _optController)),
              ),
              ElevatedButton(
                  onPressed: otpActionListener.onResendOtpPressed,
                  child: const Text("Resend OTP"))
            ],
          ),
          RichButton(
            buttonFacesBuilder: RichButtonBuilder(
              initialStateWidget: const ButtonLoginRegistrationInitial(
                title: "Validate",
              ),
              loadingStateWidget: const ButtonLoginLoading(),
              onClick: () {
                debugPrint("otp_screen::RichButton pressed");
                otpActionListener.onSendPressed(_optController.text);
              },
            ),
            newState: buttonState,
          )
        ],
      ),
    );
  }
}
