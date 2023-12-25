import '../../../../../core/utils/helper.dart';

class HomeDataModel {
  final HomeData? data;
  final bool isSuccess;
  final int? statusCode;
  final String? message;

  HomeDataModel({
    this.data,
    required this.isSuccess,
    this.statusCode,
    this.message,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      data: json['data'] != null ? HomeData.fromJson(json['data']) : null,
      isSuccess: json['isSuccess'],
      statusCode: json['statusCode'],
      message: json['message'],
    );
  }
}

class HomeData {
  final WeatherCurrent? weatherCurrent;
  final int? newEventCount;
  final int? newMessageCount;
  final int? newVoteCount;
  final HappyBirthdayMessage? happyBirthdayMessage;

  HomeData({
    this.weatherCurrent,
    this.newEventCount,
    this.newMessageCount,
    this.newVoteCount,
    this.happyBirthdayMessage,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    Helper.log(json.toString());
    return HomeData(
      weatherCurrent: json['weatherCurrent'] != null
          ? WeatherCurrent.fromJson(json['weatherCurrent'])
          : null,
      newEventCount: json['newEventCount'],
      newMessageCount: json['newMessageCount'],
      newVoteCount: json['newVoteCount'],
      happyBirthdayMessage: json['happyBirthdayMessage'] != null
          ? HappyBirthdayMessage.fromJson(json['happyBirthdayMessage'])
          : null,
    );
  }
}

class WeatherCurrent {
  final String? cityName;
  final int? bandarID;
  final String? summary;
  final String? icon;
  final String? temperature;
  final int? id;
  final String? date;
  final int? status;

  WeatherCurrent({
    this.cityName,
    this.bandarID,
    this.summary,
    this.icon,
    this.temperature,
    this.id,
    this.date,
    this.status,
  });

  factory WeatherCurrent.fromJson(Map<String, dynamic> json) {
    return WeatherCurrent(
      cityName: json['cityName'],
      bandarID: json['bandarID'],
      summary: json['summary'],
      icon: json['icon'],
      temperature: json['temperature'],
      id: json['id'],
      date: json['date'],
      status: json['status'],
    );
  }
}

class HappyBirthdayMessage {
  final Message? message;
  final UserInfo? userInfo;

  HappyBirthdayMessage({this.message, this.userInfo});

  factory HappyBirthdayMessage.fromJson(Map<String, dynamic> json) {
    return HappyBirthdayMessage(
      message:
          json['message'] != null ? Message.fromJson(json['message']) : null,
      userInfo:
          json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null,
    );
  }
}

class Message {
  final String? message;
  final int? countForShow;
  final int? id;

  Message({this.message, this.countForShow, this.id});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      countForShow: json['countForShow'],
      id: json['id'],
    );
  }
}

class UserInfo {
  final String? firstName;
  final String? lastName;
  final String? personId;
  final String? officeTitle;
  final int? gender;
  final String? profileImage;
  final int? countReaded;
  final String? id;
  final bool? isGreeted;

  UserInfo({
    this.firstName,
    this.lastName,
    this.personId,
    this.officeTitle,
    this.gender,
    this.profileImage,
    this.countReaded,
    this.id,
    this.isGreeted,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      firstName: json['firstName'],
      lastName: json['lastName'],
      personId: json['personId'],
      officeTitle: json['officeTitle'],
      gender: json['gender'],
      profileImage: json['profileImage'],
      countReaded: json['countReaded'],
      id: json['id'],
      isGreeted: json['isGreeted'],
    );
  }
}
