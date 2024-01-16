class InfoResponse {
  String status;
  List<Info> infos;

  InfoResponse({required this.status, required this.infos});

  factory InfoResponse.fromJson(Map<String, dynamic> json) {
    List<Info> infos = <Info>[];
    infos = json['info'].map<Info>((json) => Info.fromJson(json)).toList();
    //here delete infos that are isDeleted
    infos.removeWhere((element) => element.isDeleted);
    //order infos by date
    infos.sort((a, b) => b.date.compareTo(a.date));
    return InfoResponse(
      status: json['status'],
      infos: infos,
    );
  }
}

class Info {
  final int id;
  final String name;
  final String details;
  final bool isDeleted;
  DateTime date;

  Info({
    required this.id,
    required this.name,
    required this.details,
    required this.isDeleted,
    required this.date,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      id: json['id'],
      name: json['name'],
      details: json['details'],
      isDeleted: json['isDeleted'] == 1,
      date: DateTime.parse(json['date']),
    );
  }
}
