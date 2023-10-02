import 'package:flutter/widgets.dart';

enum RichButtonState { initial, activated, deactivated, error, loading }

class RichButton extends InheritedWidget {
  final RichButtonState newState;

  const RichButton(
      {Key? key,
      required Widget buttonFacesBuilder,
      this.newState = RichButtonState.initial})
      : super(key: key, child: buttonFacesBuilder);

  @override
  bool updateShouldNotify(RichButton oldWidget) {
    return newState != oldWidget.newState;
  }

  static RichButton? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RichButton>();
  }
}
