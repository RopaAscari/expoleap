import 'dart:convert';

import 'package:expoleap/models/address.dart';
import 'package:expoleap/models/social.dart';

class Company {
  final int? id;
  final String? url;
  final String? logo;
  final String? name;
  final String? phone;
  final String? email;
  final String? createdAt;
  final String? updatedAt;
  final Social? social;
  final Address? address;

  Company(
      {this.id,
      this.name,
      this.url,
      this.logo,
      this.phone,
      this.email,
      this.address,
      this.social,
      this.createdAt,
      this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'logo': logo,
      'name': name,
      'phone': phone,
      'email': email,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'social': social?.toMap(),
      'address': address?.toMap(),
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: null,
      url: null,
      logo: null,
      name: null,
      phone: null,
      email: null,
      createdAt: null,
      updatedAt: null,
      social: null,
      address: null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Company.fromJson(String source) =>
      Company.fromMap(json.decode(source));
}
