import 'dart:convert';
import 'package:expoleap/models/social.dart';
import 'package:expoleap/models/address.dart';

List<Sponsor> sponsorsFromJson(List<dynamic> events) =>
    (events).map((event) => new Sponsor.fromMap(event)).toList();

class Sponsor {
  final int id;
  final String? url;
  final String name;
  final String? logo;
  final String event;
  final String? label;
  final String? phone;
  final String? email;
  final Social social;
  final Address? address;
  final String? createdAt;
  final String? updatedAt;
  final String? description;
  final SponsorCategory? category;
  Sponsor({
    this.url,
    this.logo,
    this.label,
    this.phone,
    this.email,
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
      'event': event,
      'label': label,
      'phone': phone,
      'email': email,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'social': social.toMap(),
      'description': description,
      'address': address?.toMap(),
      'category': category?.toMap(),
    };
  }

  factory Sponsor.fromMap(Map<String, dynamic> map) {
    return Sponsor(
      id: map['id'],
      url: map['url'],
      name: map['name'],
      logo: map['logo'],
      event: map['event'],
      label: map['label'],
      phone: map['phone'],
      email: map['email'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      social: Social.fromMap(map['social']),
      description: map['description'],
      address: Address.fromMap(map['address']),
      category: map['category'] != null
          ? SponsorCategory?.fromMap(map['category'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sponsor.fromJson(String source) =>
      Sponsor.fromMap(json.decode(source));
}

class SponsorCategory {
  final int? id;
  final String? name;
  final int? priority;
  final String? event;
  final String? createdAt;
  final String? updatedAt;

  SponsorCategory(
      {this.id,
      this.name,
      this.event,
      this.priority,
      this.createdAt,
      this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'priority': priority,
      'event': event,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory SponsorCategory.fromMap(Map<String, dynamic> map) {
    return SponsorCategory(
      id: null,
      name: null,
      priority: null,
      event: null,
      createdAt: null,
      updatedAt: null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SponsorCategory.fromJson(String source) =>
      SponsorCategory.fromMap(json.decode(source));
}
