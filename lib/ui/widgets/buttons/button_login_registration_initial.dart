import 'package:flutter/material.dart';

class ButtonLoginRegistrationInitial extends StatelessWidget {
  final String title;
  const ButtonLoginRegistrationInitial({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:  [const Icon(Icons.send), Text(title)]
    );
  }
}
