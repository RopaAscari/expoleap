import 'dart:convert';

class Contact {
  final String? email;
  final String? phone;
  final String? website;

  Contact({required this.email, required this.phone, required this.website});

  Map<String, dynamic> toMap() {
    return {'email': email, 'phone': phone, 'website': website};
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
        email: map['email'], phone: map['phone'], website: map['website']);
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) =>
      Contact.fromMap(json.decode(source));
}
