class NegotiableModel {
  /*  {
            "subject": "string",
            "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6"
          }*/

  final String subject;
  final String id;

  NegotiableModel({
    required this.subject,
    required this.id,
  });

  factory NegotiableModel.fromJson(Map<String, dynamic> json) {
    return NegotiableModel(
      subject: json['subject'],
      id: json['id'],
    );
  }
}
