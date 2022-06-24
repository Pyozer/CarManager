import '../car/model/car.model.dart';
import 'services/settings_cars.service.dart';
import 'settings.controller.dart';

class SettingsCarsController extends SettingsController<SettingsCarsService> {
  SettingsCarsController() : super(SettingsCarsService());

  List<Car> _cars = [];
  List<Car> get cars => _cars;

  @override
  Future<void> load() async {
     _cars = await service.getCars();
    notifyListeners();
  }

  Future<String> addCar(Car newCar) async {
    _cars.add(newCar);
    notifyListeners();

    final carId = await service.addCar(newCar);
    await load();

    return carId;
  }

  Future<void> updateCar(Car updatedCar) async {
    final index = _cars.indexWhere((car) => car.uuid == updatedCar.uuid);
    _cars[index] = updatedCar;
    notifyListeners();

    await service.updateCar(updatedCar);
    await load();
  }
}
