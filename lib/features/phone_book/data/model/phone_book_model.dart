class PhoneBookModel {
  final List<Phone> phones;
  final bool isSuccess;
  final int? statusCode;
  final String? message;

  PhoneBookModel({
    required this.phones,
    required this.isSuccess,
    this.statusCode,
    this.message,
  });

  factory PhoneBookModel.fromJson(Map<String, dynamic> json) {
    return PhoneBookModel(
      phones: json['data'] != null
          ? List.from(json['data'])
              .map(
                (e) => Phone.fromJson(e),
              )
              .toList()
          : [],
      isSuccess: json['isSuccess'],
      statusCode: json['statusCode'],
      message: json['message'],
    );
  }
}

class Phone {
  final String? unitTitle;
  final String? personName;
  final String? phone;
  final String? description;
  final String? bohkt;
  final String? centerOutput;
  final String? id;

  Phone({
    this.unitTitle,
    this.personName,
    this.phone,
    this.description,
    this.bohkt,
    this.centerOutput,
    this.id,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      unitTitle: json['unitTitle'],
      personName: json['personName'],
      phone: json['phone'],
      description: json['description'],
      bohkt: json['bohkt'],
      centerOutput: json['centerOutput'],
      id: json['id'],
    );
  }

  Map toJson() => {
        'unitTitle': unitTitle,
        'personName': personName,
        'phone': phone,
        'description': description,
        'bohkt': bohkt,
        'centerOutput': centerOutput,
        'id': id,
      };
}
