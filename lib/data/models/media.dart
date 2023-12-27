class Media {
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
      this.tgMessageDate});

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'pictureHash': mediaHash,
      'caption': caption,
      'mediaDate': mediaDate,
      'uploadedDate': uploadedDate,
      'tgMessageDate': tgMessageDate,
      'createdDate': createdDate,
      'fileName': fileName,
      'filePath': filePath,
      'mimeType': mimeType
    };
  }

  Media.fromMap(Map<String, dynamic> mediaMap)
      : mediaHash = mediaMap['mediaHash']!,
        caption = mediaMap['caption']!,
        mediaDate = mediaMap['mediaDate']!,
        createdDate = mediaMap['createdDate']!,
        fileName = mediaMap['fileName']!,
        filePath = mediaMap['filePath']!,
        mimeType = mediaMap['mimeType']!,
        messageId = mediaMap['messageId'],
        uploadedDate = mediaMap['uploadedDate'],
        tgMessageDate = mediaMap['tgMessageDate'];

  @override
  String toString() {
    return 'Media{messageId: $messageId, mediaHash: $mediaHash, '
        'caption: $caption, '
        'mediaDate: ${DateTime.fromMillisecondsSinceEpoch(mediaDate)}, '
        'uploadedDate: ${DateTime.fromMillisecondsSinceEpoch(uploadedDate ?? 0)}, '
        'tgMessageDate: ${DateTime.fromMillisecondsSinceEpoch(tgMessageDate ?? 0)}, '
        'createdDate: ${DateTime.fromMillisecondsSinceEpoch(createdDate)}, '
        'fileName: $fileName, filePath: $filePath, mimeType: $mimeType}';
  }
}
