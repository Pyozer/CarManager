import 'package:collection/collection.dart';

import '../../car/model/car.model.dart';

enum CarMake {
  bmw,
  lotus,
  porsche,
  volvo;

  static CarMake? fromName(String? name) {
    if (name == 'BMW') return CarMake.bmw;
    if (name == 'Lotus') return CarMake.lotus;
    if (name == 'Porsche') return CarMake.porsche;
    if (name == 'Volvo') return CarMake.volvo;
    return null;
  }

  String get name {
    switch (this) {
      case CarMake.bmw:
        return 'BMW';
      case CarMake.lotus:
        return 'Lotus';
      case CarMake.porsche:
        return 'Porsche';
      case CarMake.volvo:
        return 'Volvo';
    }
  }

  String get logo {
    switch (this) {
      case CarMake.bmw:
        return 'https://raw.githubusercontent.com/filippofilip95/car-logos-dataset/master/logos/optimized/bmw.png';
      case CarMake.lotus:
        return 'http://www.logo-voiture.com/wp-content/uploads/2021/01/Lotus-logo-2019-1800x1800-grand.png';
      case CarMake.porsche:
        return 'http://assets.stickpng.com/images/580b585b2edbce24c47b2cac.png';
      case CarMake.volvo:
        return 'https://upload.wikimedia.org/wikipedia/commons/3/3c/Volvo_Trucks_Logo.png';
    }
  }
}

class FilterCar {
  final CarMake make;
  final String model;

  const FilterCar(this.make, this.model);
}

const kCars = <FilterCar>[
  FilterCar(CarMake.bmw, 'M2'),
  FilterCar(CarMake.bmw, 'M3'),
  FilterCar(CarMake.lotus, 'Elise'),
  FilterCar(CarMake.lotus, 'Exige S1'),
  FilterCar(CarMake.lotus, 'Exige S2'),
  FilterCar(CarMake.lotus, 'Exige S3'),
  FilterCar(CarMake.lotus, 'Evora'),
  FilterCar(CarMake.porsche, '911 997'),
  FilterCar(CarMake.volvo, 'S60R'),
  FilterCar(CarMake.volvo, 'V70R'),
];

class Filters {
  CarMake? _make;
  String? model;
  int? minYear;
  int? maxYear;
  int? minHP;
  int? maxHP;
  HandDrive? handDrive;

  Filters({
    CarMake? make,
    this.model,
    this.minYear,
    this.maxYear,
    this.minHP,
    this.maxHP,
    this.handDrive,
  }) {
    _make = make;
  }

  CarMake? get make => _make;

  set make(CarMake? newMake) {
    if (_make != newMake) {
      model = null;
    }
    _make = newMake;
  }

  void reset() {
    make = null;
    model = null;
    minYear = null;
    maxYear = null;
    minHP = null;
    maxHP = null;
    handDrive = null;
  }

  factory Filters.fromJson(dynamic data) {
    final carMake = CarMake.fromName(data['make']);
    return Filters(
      make: carMake,
      model: carMake != null && data['model'] != null
          ? kCars
              .firstWhereOrNull(
                (car) =>
                    car.make.name == carMake.name && car.model == data['model'],
              )
              ?.model
          : null,
      minYear: data['minYear'],
      maxYear: data['maxYear'],
      minHP: data['minHP'],
      maxHP: data['maxHP'],
      handDrive: data['handDrive'] != null
          ? HandDrive.values[data['handDrive']]
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'make': make?.name,
      'model': model,
      'minYear': minYear,
      'maxYear': maxYear,
      'minHP': minHP,
      'maxHP': maxHP,
      'handDrive': handDrive?.index,
    };
  }
}
