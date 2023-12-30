import 'package:tdlib/td_api.dart';

abstract class TelegramApiHelper {
  void login(
      {required String phoneNumber,
      required Function(TdError) errorCallback,
      required Function successCallback});

  void sendOtp(
      {required int otp,
      required Function(TdError) errorCallback,
      required Function successCallback});

  void uploadMedia(
      {required List<File> mediaFiles,
        required int chatId,
      required Function(TdError) errorCallback,
      required Function successCallback});

  void fetchMediaIds(
      {required Function(TdError) errorCallback,
      required Function successCallback});

  void downloadMedia(
      {required int pictureId, required Function(TdError) errorCallback,
      required Function successCallback});
}
