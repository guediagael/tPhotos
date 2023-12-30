import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  final List<Object?> properties;

  const BaseState(this.properties);

  @override
  List<Object?> get props => properties;

  @override
  String toString() => '$runtimeType';
}

abstract class CommonState extends BaseState {
  const CommonState(super.properties);
}

class SendErrorState extends CommonState {
  final dynamic sentForm;
  final String errorMessage;
  final Function? onOkPressed;

  SendErrorState(this.sentForm, this.errorMessage, [this.onOkPressed])
      : super([sentForm, errorMessage, onOkPressed]);
}

class SnackBarShortErrorState extends CommonState {
  final String errorMessage;

  SnackBarShortErrorState(this.errorMessage) : super([errorMessage]);
}

class DialogLongErrorState extends CommonState {
  final String? errorMessage, title, positiveButtonLabel;
  final bool closeAfterTap, hideCancelIcon;
  final Function onPositiveTap;

  DialogLongErrorState(
      {this.errorMessage,
      this.title,
      this.positiveButtonLabel,
      this.closeAfterTap = true,
      this.hideCancelIcon = true,
      required this.onPositiveTap})
      : super([
          errorMessage,
          title,
          positiveButtonLabel,
          closeAfterTap,
          hideCancelIcon,
          onPositiveTap
        ]);
}

class DialogSessionExpired extends DialogLongErrorState {
  DialogSessionExpired(
      {required String super.errorMessage,
      required String super.title,
      required String super.positiveButtonLabel,
      required super.onPositiveTap});
}

class ScreenErrorState extends BaseState {
  final String errorMessage;
  final Function onRetryPressed;

  ScreenErrorState({required this.errorMessage, required this.onRetryPressed})
      : super([errorMessage, onRetryPressed]);
}

class SendToLoginState extends CommonState {
  SendToLoginState() : super([]);
}

class RequestPermissionState extends CommonState {
  final Function(bool) callback;
  RequestPermissionState(this.callback) : super([callback]);
}
