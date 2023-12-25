class SliderModel {
  final List<SliderData>? data;
  final bool isSuccess;
  final int? statusCode;
  final String? message;

  const SliderModel({
    this.data,
    required this.isSuccess,
    this.statusCode,
    this.message,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    var sliderData = <SliderData>[];
    if (json['data'] != null) {
      json['data'].forEach((value) {
        sliderData.add(SliderData.fromJson(value));
      });
    }
    return SliderModel(
      isSuccess: json['isSuccess'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: sliderData,
    );
  }
}

class SliderData {
  final String? fileName;
  final String? description;
  final String? id;

  SliderData({
    this.fileName,
    this.description,
    this.id,
  });

  factory SliderData.fromJson(Map<String, dynamic> json) {
    return SliderData(
      fileName: json['fileName'],
      description: json['description'],
      id: json['id'],
    );
  }
}
