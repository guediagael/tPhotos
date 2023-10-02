import 'package:tphotos/data/remote/api/telegram_api_helper.dart';
import 'package:tphotos/services/telegram.dart';
import 'package:tdlib/td_api.dart';

class TelegramHelperImplementation extends TelegramApiHelper {
  final TelegramService telegramService;

  TelegramHelperImplementation(this.telegramService);

  @override
  void fetchPictureIds(
      {required Function errorCallback, required Function successCallback}) {
    // TODO: implement fetchPictures
    throw UnimplementedError();
  }

  @override
  void downloadPicture(
      {required int pictureId,
      required Function(TdError p1) errorCallback,
      required Function successCallback}) {
    telegramService.send(DownloadFile(
        fileId: pictureId,
        offset: 0,
        limit: 0,
        synchronous: true,
        priority: 1));
  }

  @override
  void login(
      {required String phoneNumber,
      required Function(TdError) errorCallback,
      required Function successCallback}) {
    telegramService
        .setAuthenticationPhoneNumber(phoneNumber, onError: errorCallback)
        .then((value) {
      successCallback();
    });
  }

  @override
  void sendOtp(
      {required int otp,
      required Function(TdError) errorCallback,
      required Function successCallback}) {
    telegramService
        .checkAuthenticationCode(otp.toString(), onError: errorCallback)
        .then((value) {
      successCallback();
    });
  }

  @override
  void uploadPictures(
      {required List<File> imageFiles,
      required int chatId,
      required Function errorCallback,
      required Function successCallback}) {
    assert(imageFiles.length < 33);
    for (int fileX = 0; fileX < imageFiles.length; fileX++) {
      File file = imageFiles[fileX];
      final inputMessageContent = InputMessagePhoto(
          photo: InputFileLocal(path: file.local.path),
          addedStickerFileIds: [],
          width: 0,
          //TODO
          height: 0,
          //TODO
          selfDestructTime: 0,
          hasSpoiler: false,
          caption: const FormattedText(text: "Hashtags", entities: []));
      final message = SendMessage(
          chatId: chatId,
          messageThreadId: 0,
          replyTo: const MessageReplyTo(),
          inputMessageContent: inputMessageContent);
      telegramService.send(
          message,
          callback: successCallback(),
          errorCallback: errorCallback());
    }
  }
}
