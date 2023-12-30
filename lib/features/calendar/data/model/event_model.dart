class EventModel {
  /*  {
      "title": "string",
      "description": "string",
      "holdingDate": "string",
      "location": "string",
      "holdingHours": "string",
      "totalCapacity": 0,
      "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "reservationRemaining": 0,
      "maximumReservation": 0,
      "alreadyReserved": 0,
      "isReaded": true,
      "dateCanReserved": "string"
      }*/

  final String title;
  final String? description;
  final String? holdingDate;
  final String? location;
  final String? holdingHours;
  final int totalCapacity;
  final String id;
  final int reservationRemaining;
  final int maximumReservation;
  final int alreadyReserved;
  final bool isReaded;

  EventModel({
    required this.title,
    this.description,
    this.holdingDate,
    this.location,
    this.holdingHours,
    required this.totalCapacity,
    required this.id,
    required this.reservationRemaining,
    required this.maximumReservation,
    required this.alreadyReserved,
    required this.isReaded,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      isReaded: json['isReaded'],
      alreadyReserved: json['alreadyReserved'],
      maximumReservation: json['maximumReservation'],
      reservationRemaining: json['reservationRemaining'],
      totalCapacity: json['totalCapacity'],
      description: json['description'],
      location: json['location'],
      holdingDate: json['holdingDate'],
      holdingHours: json['holdingHours'],
    );
  }
}
