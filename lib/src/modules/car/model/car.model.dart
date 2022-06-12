import 'dart:convert';

import 'package:intl/intl.dart';

import '../../../utils/number.extension.dart';

enum HandDrive { left, right }

class Car {
  final String uuid;
  final String title;
  final List<String> imagesUrl;
  final String description;
  final int kms;
  final int year;
  final int month;
  final int hp;
  final int price;
  final HandDrive handDrive;
  final bool isSold;
  final String adUrl;
  final DateTime adDate;
  final String? plate;
  final String? vin;

  const Car({
    required this.uuid,
    required this.title,
    required this.imagesUrl,
    required this.description,
    required this.kms,
    required this.year,
    required this.month,
    required this.hp,
    required this.price,
    required this.handDrive,
    required this.isSold,
    required this.adUrl,
    required this.adDate,
    this.plate,
    this.vin,
  });

  String get displayDate {
    return '${month.toStringLeading()}/${year.toStringLeading()}';
  }

  String get displayKMs {
    return '${NumberFormat.decimalPattern().format(kms)} km';
  }

  String get displayPrice {
    return NumberFormat.currency(decimalDigits: 0, symbol: '€').format(price);
  }

  String get displayHandDrive {
    return handDrive == HandDrive.right ? 'RHD' : 'LHD';
  }

  String toJSON() {
    return jsonEncode({
      'uuid': uuid,
      'title': title,
      'imagesUrl': imagesUrl,
      'description': description,
      'kms': kms,
      'year': year,
      'month': month,
      'hp': hp,
      'price': price,
      'handDrive': handDrive.name,
      'isSold': isSold,
      'adUrl': adUrl,
      'adDate': adDate.toIso8601String(),
      'plate': plate,
      'vin': vin,
    });
  }

  static Car fromJSON(dynamic data) {
    return Car(
      uuid: data['uuid'],
      title: data['title'],
      imagesUrl: List.from(data['imagesUrl']),
      description: data['description'],
      kms: data['kms'],
      year: data['year'],
      month: data['month'],
      hp: data['hp'],
      price: data['price'],
      handDrive: HandDrive.values.firstWhere(
        (v) => v.name == data['handDrive'],
        orElse: () => HandDrive.left,
      ),
      isSold: data['isSold'],
      adUrl: data['adUrl'],
      adDate: DateTime.parse(data['adDate']),
      plate: data['plate'],
      vin: data['vin'],
    );
  }
}
