import 'dart:convert';

class Name {
  final int id;
  final String title;
  final String first;
  final String last;

  Name(
      {required this.id,
      required this.title,
      required this.first,
      required this.last});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'first': first,
      'last': last,
    };
  }

  factory Name.fromMap(Map<String, dynamic> map) {
    return Name(
      id: map['id'],
      title: map['title'],
      first: map['first'],
      last: map['last'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Name.fromJson(String source) => Name.fromMap(json.decode(source));
}
