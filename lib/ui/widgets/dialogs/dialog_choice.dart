import 'package:flutter/material.dart';
import 'package:tphotos/ui/models/dialog_item_choice.dart';

class DialogChoice extends StatelessWidget {
  final DialogItemChoiceList choices;
  final String title;
  final String? body;

  const DialogChoice(
      {super.key, required this.choices, required this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: List.generate(
          choices.length,
              (index) =>
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  choices[index].onSelected();
                },
                child: Text(choices[index].text),
              )),
    );
  }
}
