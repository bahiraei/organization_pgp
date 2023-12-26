class MemberModel {
  /* {
  "fullName": "string",
  "gender": 1,
  "profileImage": "string",
  "categoryTitle": "string"
  }*/

  final String fullName;
  final int gender;
  final String? profileImage;
  final String? categoryTitle;

  MemberModel({
    required this.fullName,
    required this.gender,
    this.profileImage,
    this.categoryTitle,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      fullName: json['fullName'],
      gender: json['gender'],
      profileImage: json['profileImage'],
      categoryTitle: json['categoryTitle'],
    );
  }
}
