import 'package:cloud_firestore/cloud_firestore.dart';

import '../../car/model/car.model.dart';

class SettingsCarsService {
  CollectionReference<Car> _getCarRef() {
    return FirebaseFirestore.instance.collection('cars').withConverter<Car>(
          fromFirestore: (snapshot, _) => Car.fromJson(snapshot.data()!),
          toFirestore: (car, _) => car.toJson(),
        );
  }

  Future<String?> _getCarDocumentId(String carUUID) async {
    final snap =
        await _getCarRef().where('uuid', isEqualTo: carUUID).limit(1).get();
    if (snap.docs.isEmpty) return null;
    return snap.docs.first.id;
  }

  Future<List<Car>> getCars() async {
    final data = await _getCarRef().orderBy('adDate', descending: true).get();
    return data.docs.map((doc) => doc.data()).toList();
  }

  Future<String> addCar(Car car) async {
    final carAdded = await _getCarRef().add(car);
    return carAdded.id;
  }

  Future<void> updateCar(Car car) async {
    final carDocId = await _getCarDocumentId(car.uuid);
    if (carDocId == null) return;

    await _getCarRef().doc(carDocId).update(car.toJson());
  }
}
