import 'dart:convert';

class Social {
  final int id;
  final String facebook;
  final String instagram;
  final String linkedin;
  final String twitter;
  final String youtube;

  Social(
      {required this.id,
      required this.facebook,
      required this.instagram,
      required this.linkedin,
      required this.twitter,
      required this.youtube});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'facebook': facebook,
      'instagram': instagram,
      'linkedin': linkedin,
      'twitter': twitter,
      'youtube': youtube,
    };
  }

  factory Social.fromMap(Map<String, dynamic> map) {
    return Social(
      id: 0,
      facebook: map['facebook'],
      instagram: map['instagram'],
      linkedin: map['linkedin'],
      twitter: map['twitter'],
      youtube: map['youtube'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Social.fromJson(String source) => Social.fromMap(json.decode(source));
}
