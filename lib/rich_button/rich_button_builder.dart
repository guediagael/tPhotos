import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tphotos/rich_button/rich_button_state_manager.dart';

class RichButtonBuilder extends StatefulWidget {
  final StatelessWidget initialStateWidget;
  final StatelessWidget? activatedStateWidget;
  final StatelessWidget? deactivatedStateWidget;
  final StatelessWidget? loadingStateWidget;
  final StatelessWidget? errorStateWidget;
  final Function? onClick;
  final Function? onLongClick;

  const RichButtonBuilder({
    Key? key,
    this.activatedStateWidget,
    required this.initialStateWidget,
    this.deactivatedStateWidget,
    this.errorStateWidget,
    this.loadingStateWidget,
    this.onClick,
    this.onLongClick,
  })  : assert(onClick != null || onLongClick != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _RichButtonBuilderState();
}

class _RichButtonBuilderState extends State<RichButtonBuilder> {
  @override
  Widget build(BuildContext context) {
    final RichButtonState state =
        RichButton.of(context)?.newState ?? RichButtonState.activated;
    StatelessWidget widgetFace = widget.initialStateWidget;
    if(kDebugMode) print("RichButtonBuilder new state $state");
    switch (state) {
      case RichButtonState.activated:
        if (widget.activatedStateWidget != null) {
          widgetFace = widget.activatedStateWidget!;
        }
        break;
      case RichButtonState.deactivated:
        if (widget.deactivatedStateWidget != null) {
          widgetFace = widget.deactivatedStateWidget!;
        }
        break;
      case RichButtonState.error:
        if (widget.errorStateWidget != null) {
          widgetFace = widget.errorStateWidget!;
        }
        break;
      case RichButtonState.loading:
        if (widget.loadingStateWidget != null) {
          widgetFace = widget.loadingStateWidget!;
        }
        break;
      case RichButtonState.initial:
        widgetFace = widget.initialStateWidget;
        break;
    }
    return GestureDetector(
        onTap: (widget.onClick != null) ? () => widget.onClick!() : () {},
        onLongPress:
            (widget.onLongClick != null) ? () => widget.onLongClick!() : () {},
        child: widgetFace);
  }
}
