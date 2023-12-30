import 'package:flutter/widgets.dart';

enum RichButtonState { initial, activated, deactivated, error, loading }

class RichButton extends InheritedWidget {
  final RichButtonState newState;

  const RichButton(
      {super.key,
      required Widget buttonFacesBuilder,
      this.newState = RichButtonState.initial})
      : super(child: buttonFacesBuilder);

  @override
  bool updateShouldNotify(RichButton oldWidget) {
    return newState != oldWidget.newState;
  }

  static RichButton? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RichButton>();
  }
}
