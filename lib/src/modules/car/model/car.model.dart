import 'package:intl/intl.dart';

import '../../../utils/extensions/number.extension.dart';
import '../../filters/models/filters.model.dart';
import 'car_location.model.dart';

enum HandDrive {
  lhd,
  rhd;

  String get name {
    switch (this) {
      case HandDrive.lhd:
        return 'LHD';
      case HandDrive.rhd:
        return 'RHD';
    }
  }

  String get rawName {
    switch (this) {
      case HandDrive.lhd:
        return 'lhd';
      case HandDrive.rhd:
        return 'rhd';
    }
  }
}

class Car {
  final String uuid;
  final CarMake make;
  final String model;
  final String title;
  final List<String> imagesUrl;
  final String description;
  final int kms;
  final int year;
  final int month;
  final int hp;
  final int price;
  final HandDrive handDrive;
  bool isSold;
  final String adUrl;
  final DateTime adDate;
  final CarLocation location;
  final String? plate;
  final String? vin;

  Car({
    required this.uuid,
    required this.make,
    required this.model,
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
    required this.location,
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
    return NumberFormat.currency(decimalDigits: 0, symbol: '€', locale: 'fr')
        .format(price);
  }

  factory Car.fromJson(dynamic data) {
    return Car(
      uuid: data['uuid'],
      make: CarMake.fromName(data['make'])!,
      model: data['model'],
      title: data['title'],
      imagesUrl: List.from(data['imagesUrl']),
      description: data['description'],
      kms: data['kms'],
      year: data['year'],
      month: data['month'],
      hp: data['hp'],
      price: data['price'],
      handDrive: HandDrive.values.firstWhere(
        (v) => v.rawName == data['handDrive'],
        orElse: () => HandDrive.lhd,
      ),
      isSold: data['isSold'],
      adUrl: data['adUrl'],
      adDate: DateTime.parse(data['adDate']),
      location: CarLocation.fromJson(data['location']),
      plate: data['plate'],
      vin: data['vin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'make': make.name,
      'model': model,
      'title': title,
      'imagesUrl': imagesUrl,
      'description': description,
      'kms': kms,
      'year': year,
      'month': month,
      'hp': hp,
      'price': price,
      'handDrive': handDrive.rawName,
      'isSold': isSold,
      'adUrl': adUrl,
      'adDate': adDate.toIso8601String(),
      'location': location.toJson(),
      'plate': plate,
      'vin': vin,
    };
  }
}
