import 'package:flutter/material.dart';
import 'package:tphotos/action_listeners/phone_login_action_listener.dart';
import 'package:tphotos/rich_button/rich_button_builder.dart';
import 'package:tphotos/rich_button/rich_button_state_manager.dart';
import 'package:tphotos/ui/widgets/buttons/button_login_loading.dart';
import 'package:tphotos/ui/widgets/buttons/button_login_registration_initial.dart';

class PhoneNumberLoginScreen extends StatelessWidget {
  final PhoneLoginActionListener phoneLoginActionListener;
  final GlobalKey formKey;
  final TextEditingController _phoneEditingController = TextEditingController();

  PhoneNumberLoginScreen(
      {super.key,
      required this.phoneLoginActionListener,
      required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Authentication'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("Insert the phone number"),
          Form(
            key: formKey,
            child: TextFormField(
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              decoration: const InputDecoration(
                hintText: "1223455",
              ),
              maxLines: 1,
              validator: (value) {
                if (value == null || value.length < 3) {
                  return "Invalid phone number";
                }
                return null;
              },
              controller: _phoneEditingController,
            ),
          ),
          RichButton(
              buttonFacesBuilder: RichButtonBuilder(
            initialStateWidget:
                const ButtonLoginRegistrationInitial(title: "Send"),
            loadingStateWidget: const ButtonLoginLoading(),
            onClick: () {
              phoneLoginActionListener
                  .onSendPressed(_phoneEditingController.text);
            },
          ))
        ],
      ),
    );
  }
}
