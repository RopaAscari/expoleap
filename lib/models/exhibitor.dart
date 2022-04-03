import 'dart:convert';
import 'package:expoleap/models/social.dart';
import 'package:expoleap/models/address.dart';

List<Exhibitor> exhibitorsFromJson(List<dynamic> exhibitors) =>
    (exhibitors).map((exhibitor) => new Exhibitor.fromMap(exhibitor)).toList();

class Exhibitor {
  final int id;
  final String? url;
  final String name;
  final String? logo;
  final String? label;
  final String? phone;
  final String? email;
  final String event;
  final Social social;
  final Address? address;
  final String? createdAt;
  final String? updatedAt;
  final String? description;
  final ExhibitorCategory? category;

  Exhibitor({
    this.url,
    this.logo,
    this.phone,
    this.email,
    this.label,
    this.address,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.description,
    required this.id,
    required this.name,
    required this.event,
    required this.social,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'name': name,
      'logo': logo,
      'label': label,
      'phone': phone,
      'email': email,
      'event': event,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'description': description,
      'social': social.toMap(),
      'address': address?.toMap(),
      'category': category?.toMap(),
    };
  }

  factory Exhibitor.fromMap(Map<String, dynamic> map) {
    return Exhibitor(
      id: map['id'],
      url: map['url'],
      name: map['name'],
      logo: map['logo'],
      label: map['label'],
      phone: map['phone'],
      email: map['email'],
      event: map['event'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      description: map['description'],
      social: Social.fromMap(map['social']),
      address: Address.fromMap(map['address']),
      category: map['category'] != null
          ? ExhibitorCategory?.fromMap(map['category'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Exhibitor.fromJson(String source) =>
      Exhibitor.fromMap(json.decode(source));
}

class ExhibitorCategory {
  int? id;
  String? event;
  String? name;
  String? createdAt;
  String? updatedAt;

  ExhibitorCategory(
      {this.id, this.event, this.name, this.createdAt, this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event': event,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ExhibitorCategory.fromMap(Map<String, dynamic> map) {
    return ExhibitorCategory(
        id: map['id'],
        event: map['event'],
        name: map['name'],
        createdAt: map['createdAt'],
        updatedAt: map['updatedAt']);
  }

  String toJson() => json.encode(toMap());

  factory ExhibitorCategory.fromJson(String source) =>
      ExhibitorCategory.fromMap(json.decode(source));
}
