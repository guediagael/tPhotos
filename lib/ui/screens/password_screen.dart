import 'package:flutter/material.dart';
import 'package:tphotos/action_listeners/password_action_listener.dart';
import 'package:tphotos/rich_button/rich_button_builder.dart';
import 'package:tphotos/rich_button/rich_button_state_manager.dart';
import 'package:tphotos/ui/widgets/buttons/button_login_loading.dart';
import 'package:tphotos/ui/widgets/buttons/button_login_registration_initial.dart';

class PasswordScreen extends StatefulWidget {
  final PasswordActionListener passwordActionListener;
  final RichButtonState buttonState;
  final GlobalKey formKey;

  const PasswordScreen(
      {super.key,
      required this.passwordActionListener,
      required this.buttonState,
      required this.formKey});

  @override
  State<StatefulWidget> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Form(
              key: widget.formKey,
              child: TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                      hintText: "password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Input Required";
                    }
                    return null;
                  },
                  controller: _passwordController)),
          RichButton(
            buttonFacesBuilder: RichButtonBuilder(
              initialStateWidget: const ButtonLoginRegistrationInitial(
                title: "Send",
              ),
              loadingStateWidget: const ButtonLoginLoading(),
              onClick: () {
                debugPrint("password_screen::RichButton pressed");
                widget.passwordActionListener
                    .onSendPressed(_passwordController.text);
              },
            ),
            newState: widget.buttonState,
          )
        ],
      ),
    );
  }
}
