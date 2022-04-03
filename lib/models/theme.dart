import 'dart:convert';

class ApplicationTheme {
  final String theme;

  ApplicationTheme({required this.theme}) : super();

  Map<String, dynamic> toMap() {
    return {
      'theme': theme,
    };
  }

  factory ApplicationTheme.fromMap(Map<String, dynamic> map) {
    return ApplicationTheme(
      theme: map['theme'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ApplicationTheme.fromJson(String source) =>
      ApplicationTheme.fromMap(json.decode(source));
}
