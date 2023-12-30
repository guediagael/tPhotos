class Media {
  static const messageIdField = "messageId";
  static const mediaHashField = "mediaHash";
  static const captionField = "caption";
  static const mediaDateField = "mediaDate";
  static const uploadedDateField = "uploadedDate";
  static const tgMessageDateField = "tgMessageDate";
  static const createdDateField = "createdDate";
  static const fileNameField = "fileName";
  static const filePathField = "filePath";
  static const mimeTypeField = "mimeType";
  static const syncAllowedField = "syncAllowed";
  static const exifDataField = "exifData";

  int? messageId;
  String mediaHash;
  String caption;
  int mediaDate;
  int? uploadedDate;
  int? tgMessageDate;
  int createdDate;
  String fileName;
  String filePath;
  String mimeType;
  bool syncAllowed;
  String? exifData;

  Media(
      {required this.mediaHash,
      required this.caption,
      required this.mediaDate,
      required this.createdDate,
      required this.fileName,
      required this.filePath,
      required this.mimeType,
      this.messageId,
      this.uploadedDate,
      this.tgMessageDate,
      this.syncAllowed = true,
      this.exifData});

  Map<String, dynamic> toMap() {
    return {
      messageIdField: messageId,
      mediaHashField: mediaHash,
      captionField: caption,
      mediaDateField: mediaDate,
      uploadedDateField: uploadedDate,
      tgMessageDateField: tgMessageDate,
      createdDateField: createdDate,
      fileNameField: fileName,
      filePathField: filePath,
      mimeTypeField: mimeType,
      syncAllowedField: syncAllowed,
      exifDataField: exifData
    };
  }

  Media.fromMap(Map<String, dynamic> mediaMap)
      : mediaHash = mediaMap[mediaHashField]!,
        caption = mediaMap[captionField]!,
        mediaDate = mediaMap[mediaDateField]!,
        createdDate = mediaMap[createdDateField]!,
        fileName = mediaMap[fileNameField]!,
        filePath = mediaMap[filePathField]!,
        mimeType = mediaMap[mimeTypeField]!,
        messageId = mediaMap[messageIdField],
        uploadedDate = mediaMap[uploadedDateField],
        tgMessageDate = mediaMap[tgMessageDateField],
        syncAllowed = mediaMap[syncAllowedField] == 1,
        exifData = mediaMap[exifDataField];

  @override
  String toString() {
    return 'Media{$messageIdField: $messageId, $mediaHashField: $mediaHash, '
        '$captionField: $caption, '
        '$mediaDateField: ${DateTime.fromMillisecondsSinceEpoch(mediaDate)}, '
        '$uploadedDateField: ${DateTime.fromMillisecondsSinceEpoch(uploadedDate ?? 0)}, '
        '$tgMessageDateField: ${DateTime.fromMillisecondsSinceEpoch(tgMessageDate ?? 0)}, '
        '$createdDateField: ${DateTime.fromMillisecondsSinceEpoch(createdDate)}, '
        '$fileNameField: $fileName, $filePathField: $filePath, $mimeTypeField: $mimeType,'
        '$syncAllowedField: $syncAllowed, '
        '$exifDataField: $exifData}';
  }
}
