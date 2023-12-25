class FishModel {
  final Fish? fish;
  final bool isSuccess;
  final int statusCode;
  final String? message;

  FishModel({
    required this.fish,
    required this.isSuccess,
    required this.statusCode,
    this.message,
  });

  factory FishModel.fromJson(dynamic json) {
    return FishModel(
      fish: json['data'] != null ? Fish.fromJson(json) : null,
      isSuccess: json['isSuccess'],
      statusCode: json['statusCode'],
      message: json['message'],
    );
  }
}

class Fish {
  final FishBaseInfo baseInfo;
  final List<FishItems> mazayaItems;
  final List<FishItems> kosorItems;

  Fish({
    required this.baseInfo,
    required this.mazayaItems,
    required this.kosorItems,
  });

  factory Fish.fromJson(Map json) {
    return Fish(
      baseInfo: FishBaseInfo.fromJson(json['data']['baseInfo']),
      mazayaItems: json['data']['mazayaItems'] != null
          ? List.from(json['data']['mazayaItems'])
              .map(
                (e) => FishItems.fromJson(e),
              )
              .toList()
          : [],
      kosorItems: json['data']['kosorItems'] != null
          ? List.from(json['data']['kosorItems'])
              .map(
                (e) => FishItems.fromJson(e),
              )
              .toList()
          : [],
    );
  }
}

class FishBaseInfo {
  final String? personelCode;
  final String? fullName;
  final String? year;
  final String? month;
  final String? accountNumber;
  final int mazayaSumLong;
  final int kosorSumLong;
  final int khalesPayLong;
  final String? mazayaSum;
  final String? kosorSum;
  final String? khalesPay;

  FishBaseInfo({
    this.personelCode,
    this.fullName,
    this.year,
    this.month,
    this.accountNumber,
    required this.mazayaSumLong,
    required this.kosorSumLong,
    required this.khalesPayLong,
    this.mazayaSum,
    this.kosorSum,
    this.khalesPay,
  });

  factory FishBaseInfo.fromJson(Map json) {
    return FishBaseInfo(
      personelCode: json['personelCode'],
      fullName: json['fullName'],
      year: json['year'],
      month: json['month'],
      accountNumber: json['accountNumber'],
      mazayaSumLong: json['mazayaSumLong'],
      kosorSumLong: json['kosorSumLong'],
      khalesPayLong: json['khalesPayLong'],
      mazayaSum: json['mazayaSum'],
      kosorSum: json['kosorSum'],
      khalesPay: json['khalesPay'],
    );
  }
}

class FishItems {
  final String title;
  final String price;
  final int priceLong;

  FishItems({
    required this.title,
    required this.price,
    required this.priceLong,
  });

  factory FishItems.fromJson(Map json) {
    return FishItems(
      title: json['title'],
      price: json['price'],
      priceLong: json['priceLong'],
    );
  }
}

class FishFileModel {
  final String? data;
  final bool? isSuccess;
  final int? statusCode;
  final String? message;

  FishFileModel({
    this.data,
    this.isSuccess,
    this.statusCode,
    this.message,
  });

  factory FishFileModel.fromJson(Map json) {
    return FishFileModel(
      data: json['data'].toString(),
      isSuccess: json['isSuccess'],
      statusCode: json['statusCode'],
      message: json['message'],
    );
  }
}
