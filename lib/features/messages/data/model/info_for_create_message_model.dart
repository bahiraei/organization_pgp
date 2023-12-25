class InfoForeCreateMessageModel {
  /*{
  "data": {
    "events": [
      {
        "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "title": "string"
      }
    ],
    "personelGroups": [
      {
        "id": 0,
        "title": "string"
      }
    ],
    "personelCategories": [
      {
        "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "title": "string"
      }
    ]
  },
  "isSuccess": true,
  "statusCode": 0,
  "message": "string"
}*/

  List<Event> events;
  List<PersonnelGroup> personnelGroups;
  List<PersonnelCategory> personnelCategories;

  InfoForeCreateMessageModel({
    required this.events,
    required this.personnelGroups,
    required this.personnelCategories,
  });

  factory InfoForeCreateMessageModel.fromJson(dynamic json) {
    final data = json['data'];

    return InfoForeCreateMessageModel(
      events: (data['events'] as List)
          .map(
            (event) => Event.fromJson(event),
          )
          .toList(),
      personnelGroups: (data['personelGroups'] as List)
          .map(
            (group) => PersonnelGroup.fromJson(group),
          )
          .toList(),
      personnelCategories: (data['personelCategories'] as List)
          .map(
            (category) => PersonnelCategory.fromJson(category),
          )
          .toList(),
    );
  }
}

class Event {
  String id;
  String title;

  Event({required this.id, required this.title});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
    );
  }

  @override
  String toString() {
    return 'Event ID: $id, Title: $title';
  }
}

class PersonnelGroup {
  int id;
  String title;

  PersonnelGroup({required this.id, required this.title});

  factory PersonnelGroup.fromJson(Map<String, dynamic> json) {
    return PersonnelGroup(
      id: json['id'],
      title: json['title'],
    );
  }

  @override
  String toString() {
    return 'Personnel Group ID: $id, Title: $title';
  }
}

class PersonnelCategory {
  String id;
  String title;

  PersonnelCategory({required this.id, required this.title});

  factory PersonnelCategory.fromJson(Map<String, dynamic> json) {
    return PersonnelCategory(
      id: json['id'],
      title: json['title'],
    );
  }

  @override
  String toString() {
    return 'Personnel Category ID: $id, Title: $title';
  }
}
