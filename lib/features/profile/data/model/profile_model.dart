class ProfileModel {
  final ProfileData? data;
  final bool isSuccess;
  final int? statusCode;
  final String? message;

  const ProfileModel({
    this.data,
    required this.isSuccess,
    this.statusCode,
    this.message,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      isSuccess: json['isSuccess'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: ProfileData.fromJson(json['data']),
    );
  }
}

class ProfileData {
  final String id;
  final String? fullName;
  final String? officeName;
  final String? lastLogin;
  final int? age;
  final int? gender;
  final String nationalCode;
  final String? personId;
  final String? birthDayFa;
  final String? profileImage;
  final bool isAdmin;
  final bool isShowBirthDay;
  final List<DependencyData>? dependencies;
  final String? fullPathProfileImage;
  final bool canAddMessage;

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    var dependencies = <DependencyData>[];
    if (json['dependencies'] != null) {
      json['dependencies'].forEach((v) {
        dependencies.add(DependencyData.fromJson(v));
      });
    }

    return ProfileData(
      id: json['id'],
      age: json['age'],
      gender: json['gender'],
      nationalCode: json['meliCode'],
      isAdmin: json['isAdmin'],
      isShowBirthDay: json['isShowBirthDay'],
      fullName: json['fullName'],
      profileImage: json['profileImage'],
      personId: json['personId'],
      officeName: json['officeName'],
      lastLogin: json['lastLogin'],
      birthDayFa: json['birthDayFa'],
      dependencies: dependencies,
      fullPathProfileImage: json['fullpathProfileImage'],
      canAddMessage: json['canAddMessage'],
    );
  }

  ProfileData({
    required this.id,
    this.fullName,
    this.officeName,
    this.lastLogin,
    this.age,
    this.gender,
    required this.nationalCode,
    this.personId,
    this.birthDayFa,
    this.profileImage,
    required this.isAdmin,
    required this.isShowBirthDay,
    this.dependencies,
    required this.fullPathProfileImage,
    required this.canAddMessage,
  });
}

class DependencyData {
  final String? firstName;
  final String? lastName;
  final String? birthDayFa;
  final String? meliCode;
  final String? id;
  final int gender;
  /*final RelTypeEnum relType;*/
  final String relTypeTitle;

  DependencyData({
    this.firstName,
    this.lastName,
    this.birthDayFa,
    this.meliCode,
    this.id,
    required this.gender,
    /*required this.relType,*/
    required this.relTypeTitle,
  });

  factory DependencyData.fromJson(Map<String, dynamic> json) {
/*    RelTypeEnum relTypeEnum = RelTypeEnum.self;
    switch (json['relType']) {
      case 1:
        relTypeEnum = RelTypeEnum.spouse;
        break;
      case 2:
        relTypeEnum = RelTypeEnum.mother;
        break;
      case 3:
        relTypeEnum = RelTypeEnum.father;
        break;
      case 4:
        relTypeEnum = RelTypeEnum.boy;
        break;
      case 5:
        relTypeEnum = RelTypeEnum.girl;
        break;
      case 6:
        relTypeEnum = RelTypeEnum.self;
        break;
      case 7:
        relTypeEnum = RelTypeEnum.sister;
        break;
      case 8:
        relTypeEnum = RelTypeEnum.brother;
        break;
    }*/

    return DependencyData(
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      birthDayFa: json['birthDayFa'],
      meliCode: json['meliCode'],
      /*relType: relTypeEnum,*/
      id: json['id'],
      relTypeTitle: json['relTypeTitle'],
    );
  }
}

/*// enhanced enum is more like a constant class
enum RelTypeEnum {
  spouse('همسر'),
  mother('مادر'),
  father('پدر'),
  boy('فرزند'),
  girl('فرزند'),
  self('خودم'),
  sister('خواهر'),
  brother('برادر');

  // can add more properties or getters/methods if needed
  final String value;

  // can use named parameters if you want
  const RelTypeEnum(this.value);
}*/
