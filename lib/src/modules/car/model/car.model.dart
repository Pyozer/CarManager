import 'dart:convert';

import 'package:intl/intl.dart';

import '../../../utils/number.extension.dart';

enum HandDrive { left, right }

class Car {
  final int id;
  final String title;
  final List<String> imagesUrl;
  final String description;
  final int kms;
  final int year;
  final int month;
  final int price;
  final HandDrive handDrive;
  final bool isSold;
  final String adUrl;
  final String? plate;
  final String? vin;

  const Car({
    required this.id,
    required this.title,
    required this.imagesUrl,
    required this.description,
    required this.kms,
    required this.year,
    required this.month,
    required this.price,
    required this.handDrive,
    required this.isSold,
    required this.adUrl,
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
      'id': id,
      'title': title,
      'imagesUrl': imagesUrl,
      'description': description,
      'kms': kms,
      'year': year,
      'month': month,
      'price': price,
      'handDrive': handDrive.name,
      'isSold': isSold,
      'adUrl': adUrl,
      'plate': plate,
      'vin': vin,
    });
  }

  static Car fromJSON(dynamic data) {
    return Car(
      id: data['id'],
      title: data['title'],
      imagesUrl: List.from(data['imagesUrl']),
      description: data['description'],
      kms: data['kms'],
      year: data['year'],
      month: data['month'],
      price: data['price'],
      handDrive: HandDrive.values.firstWhere(
        (v) => v.name == data['handDrive'],
      ),
      isSold: data['isSold'],
      adUrl: data['adUrl'],
      plate: data['plate'],
      vin: data['vin'],
    );
  }
}
