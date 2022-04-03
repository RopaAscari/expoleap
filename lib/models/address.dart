import 'dart:convert';

class Address {
  final int id;
  final String region;
  final String address1;
  final String address2;
  final String locality;
  final String postalCode;
  final CountryModel country;

  Address(
      {required this.id,
      required this.address1,
      required this.address2,
      required this.locality,
      required this.region,
      required this.postalCode,
      required this.country});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'region': region,
      'address1': address1,
      'address2': address2,
      'locality': locality,
      'postalCode': postalCode,
      'country': country.toMap(),
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: 0,
      region: map['region'],
      address1: map['address1'],
      address2: map['address2'],
      locality: map['locality'],
      postalCode: map['postalCode'],
      country: CountryModel.fromMap(map['country']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source));
}

class CountryModel {
  final String code;
  final String name;

  CountryModel({required this.code, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
    };
  }

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return CountryModel(
      code: map['code'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CountryModel.fromJson(String source) =>
      CountryModel.fromMap(json.decode(source));
}
