class MessageModel {
  final List<MessageEntity>? data;
  final bool? isSuccess;
  final int? statusCode;
  final String? message;

  MessageModel({this.data, this.isSuccess, this.statusCode, this.message});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    var data = <MessageEntity>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(MessageEntity.fromJson(v));
      });
    }
    return MessageModel(
      isSuccess: json['isSuccess'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: data,
    );
  }
}

class MessageEntity {
  final String? title;
  final String? fullText;
  final String? img;
  final String? id;
  final String? date;
  final bool isReaded;
  final bool canYouComment;
  final List<Images>? images;
  final List<Videos>? videos;
  final List<Voices>? voices;

  MessageEntity({
    this.title,
    this.fullText,
    this.img,
    this.id,
    this.date,
    this.isReaded = false,
    this.canYouComment = false,
    this.images,
    this.videos,
    this.voices,
  });

  factory MessageEntity.fromJson(Map<String, dynamic> json) {
    var images = <Images>[];
    var videos = <Videos>[];
    var voices = <Voices>[];

    if (json['images'] != null) {
      json['images'].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
    if (json['videos'] != null) {
      json['videos'].forEach((v) {
        videos.add(Videos.fromJson(v));
      });
    }
    if (json['voices'] != null) {
      json['voices'].forEach((v) {
        voices.add(Voices.fromJson(v));
      });
    }
    return MessageEntity(
      title: json['title'],
      fullText: json['fullText'],
      img: json['img'],
      id: json['id'],
      date: json['date'],
      isReaded: json['isReaded'],
      canYouComment: json['canYouComment'],
      images: images,
      videos: videos,
      voices: voices,
    );
  }
}

class Images {
  final String? fileTitle;
  final int? type;
  final String? fileName;
  final String? fileExtention;
  final String? folder;
  final int? size;
  final String? time;

  Images({
    this.fileTitle,
    this.type,
    this.fileName,
    this.fileExtention,
    this.folder,
    this.size,
    this.time,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      fileTitle: json['fileTitle'],
      type: json['type'],
      fileName: json['fileName'],
      fileExtention: json['fileExtention'],
      folder: json['folder'],
      size: json['size'],
      time: json['time'],
    );
  }
}

class Videos {
  final String? fileTitle;
  final int? type;
  final String? fileName;
  final String? fileExtention;
  final String? folder;
  final int? size;
  final String? time;

  Videos({
    this.fileTitle,
    this.type,
    this.fileName,
    this.fileExtention,
    this.folder,
    this.size,
    this.time,
  });

  factory Videos.fromJson(Map<String, dynamic> json) {
    return Videos(
      fileTitle: json['fileTitle'],
      type: json['type'],
      fileName: json['fileName'],
      fileExtention: json['fileExtention'],
      folder: json['folder'],
      size: json['size'],
      time: json['time'],
    );
  }
}

class Voices {
  final String? fileTitle;
  final int? type;
  final String? fileName;
  final String? fileExtention;
  final String? folder;
  final int? size;
  final String? time;

  Voices({
    this.fileTitle,
    this.type,
    this.fileName,
    this.fileExtention,
    this.folder,
    this.size,
    this.time,
  });

  factory Voices.fromJson(Map<String, dynamic> json) {
    return Voices(
      fileTitle: json['fileTitle'],
      type: json['type'],
      fileName: json['fileName'],
      fileExtention: json['fileExtention'],
      folder: json['folder'],
      size: json['size'],
      time: json['time'],
    );
  }
}
