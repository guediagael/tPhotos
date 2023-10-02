import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_nav_event.dart';
import 'base_nav_state.dart';

abstract class BaseNavigatorBloc
    extends Bloc<BaseNavigatorEvent, BaseNavigatorState> {
  final Type _initialStateType;

  BaseNavigatorBloc(BaseNavigatorState initialState)
      : _initialStateType = initialState.runtimeType,
        super(initialState) {
    on<BaseNavigatorEventShowLoading>(_onShowLoading);
    on<BaseNavigatorEventPop>(_onPop);
    on<BaseNavigatorEventLogout>(_onLogout);
    on<BaseNavigatorEventShowActionableDialog>(_onShowActionableDialog);
    on<BaseNavigatorEventShowActionableErrorDialog>(
        _onShowActionAbleErrorDialog);
    on<BaseNavigatorShowInfoDialog>(_onShowInfoDialog);
    on<BaseNavigatorShowErrorInfoDialog>(_onShowErrorInfoDialog);
    on<BaseNavigatorEventShowLogin>(_onShowLogin);
  }

  Type get initialStateType => _initialStateType;

  void _onShowLoading(BaseNavigatorEventShowLoading event,
      Emitter<BaseNavigatorState> emitter) {
    emitter(const BaseNavigatorStateShowLoading());
  }

  void _onPop(
      BaseNavigatorEventPop eventPop, Emitter<BaseNavigatorState> emitter) {
    emitter(const BaseNavigatorStatePop());
  }

  void _onLogout(BaseNavigatorEventLogout eventLogout,
      Emitter<BaseNavigatorState> emitter) {
    emitter(const BaseNavigatorStateLogout());
  }

  void _onShowActionableDialog(
      BaseNavigatorEventShowActionableDialog eventShowActionableDialog,
      Emitter<BaseNavigatorState> emitter) {
    emitter(BaseNavigatorStateShowActionableDialog(
        onPositiveTap: () => eventShowActionableDialog.onNegativeTap(),
        onNegativeTap: () => eventShowActionableDialog.onNegativeTap(),
        title: eventShowActionableDialog.title,
        errorMessage: eventShowActionableDialog.errorMessage));
  }

  void _onShowActionAbleErrorDialog(
      BaseNavigatorEventShowActionableErrorDialog errorDialogEvent,
      Emitter<BaseNavigatorState> emitter) {
    emitter(BaseNavigatorStateShowActionableErrorDialog(
        onPositiveTap: () => errorDialogEvent.onPositiveTap(),
        onNegativeTap: () => errorDialogEvent.onNegativeTap(),
        title: errorDialogEvent.title,
        errorMessage: errorDialogEvent.errorMessage));
  }

  void _onShowInfoDialog(
      BaseNavigatorShowInfoDialog baseNavigatorShowInfoDialog,
      Emitter<BaseNavigatorState> emitter) {
    emitter(BaseNavigatorStateShowInfoDialog(
        onPositiveTap: () => baseNavigatorShowInfoDialog.onPositiveTap(),
        title: baseNavigatorShowInfoDialog.title,
        errorMessage: baseNavigatorShowInfoDialog.errorMessage));
  }

  void _onShowErrorInfoDialog(
      BaseNavigatorShowErrorInfoDialog errorInfoDialogEvent,
      Emitter<BaseNavigatorState> emitter) {
    final baseNavigatorState = BaseNavigatorStateShowErrorInfoDialog(
        onPositiveTap: () => errorInfoDialogEvent.onPositiveTap(),
        title: errorInfoDialogEvent.title,
        errorMessage: errorInfoDialogEvent.errorMessage);
    emitter(baseNavigatorState);
  }

  void _onShowLogin(BaseNavigatorEventShowLogin eventShowLogin,
      Emitter<BaseNavigatorState> emitter) {
    emitter(const BaseNavigatorStateShowLogin());
  }
}
