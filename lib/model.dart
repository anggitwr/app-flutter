class Dataa{

  int? id;
  String? title;
  DateTime? date;

  Dataa({this.title, this.date});

  Dataa.withId({this.id, this.title, this.date});

  Map<String,dynamic> toMap(){
    final map = Map<String,dynamic>();

    if(id != null){
      map['id'] = id;
    }
    map['title'] = title;
    map['date'] = date!.toIso8601String();
    return map;
  }
  factory Dataa.fromMap(Map<String,dynamic> map){
    return Dataa.withId(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
    );
  }
}