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

  void uploadPictures(
      {required List<File> imageFiles,
        required int chatId,
      required Function(TdError) errorCallback,
      required Function successCallback});

  void fetchPictureIds(
      {required Function(TdError) errorCallback,
      required Function successCallback});

  void downloadPicture(
      {required int pictureId, required Function(TdError) errorCallback,
      required Function successCallback});
}
