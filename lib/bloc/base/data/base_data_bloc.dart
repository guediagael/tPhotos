import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_state.dart';

import 'package:tphotos/data/local/preferences/preferences_id_api.dart';

import 'base_event.dart';
import 'base_state.dart';

abstract class BaseBloc extends Bloc<BaseEvent, BaseState> {
  var closed = false;
  final PreferencesIdApi? preferencesIdApi;
  final Type _initialStateType;

  BaseBloc(BaseState initialState, [this.preferencesIdApi])
      : _initialStateType = initialState.runtimeType,
        super(initialState) {
    on<CommonEvent>(_commonEvent);
    on<ShowDialogEvent>(_onShowDialogEvent);
    on<PromptAuthEvent>(_onPromptAuthEvent);
    on<SendToLoginEvent>(_onSendToLoginEvent);
    on<ShowErrorScreenEvent>(_onShowErrorScreenEvent);
    on<FilesPermissionRequestEvent>(_onFilesPermissionRequestEvent);
  }

  Type get initialStateType => _initialStateType;

  void _commonEvent(CommonEvent event, Emitter<BaseState> baseEventEmitter) {
    //TODO:
  }

  void _onShowDialogEvent(
      ShowDialogEvent event, Emitter<BaseState> dialogErrorStateEmitter) {
    var e = event;
    final state = DialogLongErrorState(
        errorMessage: e.message,
        title: e.title,
        onPositiveTap: () => e.onOkayPressed!(),
        positiveButtonLabel: "Ok");
    dialogErrorStateEmitter(state);
  }

  void _onPromptAuthEvent(
      PromptAuthEvent event, Emitter<BaseState> dialogEventEmitter) {
    final state = DialogSessionExpired(
        errorMessage: event.message,
        title: event.title,
        onPositiveTap: () {
          debugPrint("positive button tapped");
          add(SendToLoginEvent());
        },
        positiveButtonLabel: "Ok");
    dialogEventEmitter(state);
  }

  void _onSendToLoginEvent(
      SendToLoginEvent event, Emitter<BaseState> sendToLoginEmitter) {
    debugPrint("base_bloc::mapEventToState yielding SendToLoginState");
    sendToLoginEmitter(SendToLoginState());
  }

  void _onShowErrorScreenEvent(
      ShowErrorScreenEvent event, Emitter<BaseState> screenErrorStateEmitter) {
    final state = ScreenErrorState(
        errorMessage: event.errorMessage,
        onRetryPressed: () {
          //TODO:
        });
    screenErrorStateEmitter(state);
  }

  @override
  @mustCallSuper
  Future<void> close() {
    closed = true;
    return super.close();
  }

  String getTag() => toString();

  void networkErrorHandler(DioException error, ErrorViewType errorViewType) {
    debugPrint("dio error: ${error.message}");
    debugPrint("dio error resp code: ${error.response?.statusCode}");
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      _addErrorToBloc("Connection Time Out : ${error.message!}", errorViewType,
          "Network Error");
    } else if (error.type == DioExceptionType.badResponse) {
      debugPrint("dio error request ${error.requestOptions.path} \n");
      debugPrint("dio error response ${error.response?.data}");
      if (error.response?.statusCode == 403) {
        add(PromptAuthEvent(
            title: "Unauthorized Access",
            message: "Please authenticate yourself"));
      } else if (error.response?.statusCode == 401) {
        add(PromptAuthEvent(
            title: "Session Expired", message: "Session Error"));
      } else {
        _addErrorToBloc(error.message!, errorViewType, "Server Error");
      }
    } else {
      _addErrorToBloc(error.message!, errorViewType, "Server Error");
    }
  }

  void errorHandler(dynamic error, ErrorViewType errorViewType) {
    if (error is DioError) {
      networkErrorHandler(error, errorViewType);
    } else {
      debugPrint("Not Dio Error string ${(error as Error).toString()}");
      debugPrint("Not Dio Error  stacktrace${error.stackTrace}");
      var er = '';
      if (error is Map) {
        (error as Map).forEach((key, value) {
          er += '$key : $value\n';
        });
      } else {
        er += "Error : ${(error).toString()}";
      }
      _addErrorToBloc(er, errorViewType, "Oops 😥");
    }
  }

  void _addErrorToBloc(String message, ErrorViewType errorViewType,
      [String? title]) {
    assert(errorViewType != ErrorViewType.dialog || title != null);
    switch (errorViewType) {
      case ErrorViewType.snackBar:
        add(ShowSnackBarMessageEvent(message));
        break;
      case ErrorViewType.dialog:
        add(ShowDialogEvent(title: title ?? "", message: message));
        break;
      case ErrorViewType.fullscreen:
        add(ShowErrorScreenEvent(errorMessage: message));
        break;
    }
  }

  FutureOr<void> _onFilesPermissionRequestEvent(
      FilesPermissionRequestEvent event, Emitter<BaseState> emitter) {
    emitter(RequestPermissionState(event.callback));
  }
}

enum ErrorViewType { snackBar, dialog, fullscreen }
