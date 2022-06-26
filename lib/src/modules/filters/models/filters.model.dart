import 'package:collection/collection.dart';

import '../../car/model/car.model.dart';

class CarMake {
  final String name;
  final String logo;

  const CarMake(this.name, this.logo);
}

class Car {
  final CarMake make;
  final String model;

  const Car(this.make, this.model);
}

const kCarMakes = <CarMake>[
  CarMake('BMW',
      'https://raw.githubusercontent.com/filippofilip95/car-logos-dataset/master/logos/optimized/bmw.png'),
  CarMake('Lotus',
      'http://www.logo-voiture.com/wp-content/uploads/2021/01/Lotus-logo-2019-1800x1800-grand.png'),
  CarMake('Porsche',
      'http://assets.stickpng.com/images/580b585b2edbce24c47b2cac.png'),
  CarMake('Volvo',
      'https://upload.wikimedia.org/wikipedia/commons/3/3c/Volvo_Trucks_Logo.png'),
];

final kCars = <Car>[
  Car(kCarMakes[0], 'M2'),
  Car(kCarMakes[0], 'M3'),
  Car(kCarMakes[1], 'Elise'),
  Car(kCarMakes[1], 'Exige'),
  Car(kCarMakes[1], 'Evora'),
  Car(kCarMakes[2], '911 997'),
  Car(kCarMakes[3], 'S60R'),
  Car(kCarMakes[3], 'V70R'),
];

class Filters {
  CarMake? _make;
  Car? model;
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
    final carMake = data['make'] != null
        ? kCarMakes.firstWhereOrNull((make) => make.name == data['make'])
        : null;
    return Filters(
      make: carMake,
      model: carMake != null && data['model'] != null
          ? kCars.firstWhereOrNull(
              (car) =>
                  car.make.name == carMake.name && car.model == data['model'],
            )
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
      'model': model?.model,
      'minYear': minYear,
      'maxYear': maxYear,
      'minHP': minHP,
      'maxHP': maxHP,
      'handDrive': handDrive?.index,
    };
  }
}
