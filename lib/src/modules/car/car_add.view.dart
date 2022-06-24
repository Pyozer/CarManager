import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:uuid/uuid.dart';

import '../../modules/car/model/car.model.dart';
import '../../utils/image.util.dart';
import '../../utils/regexp.util.dart';
import '../../utils/extensions/list.extension.dart';
import '../../utils/extensions/number.extension.dart';
import '../../utils/extensions/string.extension.dart';
import '../../utils/validators.utils.dart';
import '../../widgets/stepper_controls.widget.dart';
import '../../widgets/add_image_square.widget.dart';
import '../settings/settings_cars.controller.dart';
import '../../models/image_data.model.dart';
import 'car_location_picker.view.dart';
import 'model/car_location.model.dart';

const kCardSize = 100.0;
const kCardSpacing = 12.0;
const kPadding = 24.0 * 2;

class CarAddViewArguments {
  final Car? baseCar;

  CarAddViewArguments({this.baseCar});
}

class CarAddView extends StatefulWidget {
  final Car? baseCar;

  const CarAddView({Key? key, this.baseCar}) : super(key: key);

  static const routeName = '/car_add';

  @override
  State<CarAddView> createState() => _CarAddViewState();
}

class _CarAddViewState extends State<CarAddView> {
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _kmController;
  late final TextEditingController _monthController;
  late final TextEditingController _yearController;
  late final TextEditingController _hpController;
  late final TextEditingController _priceController;
  late final TextEditingController _adUrlController;
  late final TextEditingController _adDateController;
  late final TextEditingController _locationController;
  late final TextEditingController _plateController;
  late final TextEditingController _vinController;

  Validator? _validator;

  final ImagePicker _picker = ImagePicker();

  int _currentStep = 0;
  bool _isLoading = false;

  List<ImageData> _imagesData = [];

  Map<String, dynamic> car = {
    'uuid': const Uuid().v4(),
    'handDrive': HandDrive.left.name,
    'isSold': false,
    'isArchive': false,
  };

  @override
  void initState() {
    super.initState();
    if (widget.baseCar != null) {
      car = jsonDecode(jsonEncode(widget.baseCar!.toJson()));
    }
    _titleController = TextEditingController(text: car['title']);
    _descController = TextEditingController(text: car['description']);
    _kmController = TextEditingController(text: car['kms']?.toString());
    _monthController = TextEditingController(text: car['month']?.toString());
    _yearController = TextEditingController(text: car['year']?.toString());
    _hpController = TextEditingController(text: car['hp']?.toString());
    _priceController = TextEditingController(text: car['price']?.toString());
    _adUrlController = TextEditingController(text: car['adUrl']);
    _adDateController = TextEditingController(
      text: _formatDate(DateTime.tryParse(car['adDate'] ?? '')),
    );
    _locationController = TextEditingController(
      text: car['location']?['address'],
    );
    _plateController = TextEditingController(text: car['plate']);
    _vinController = TextEditingController(text: car['vin']);
    _imagesData = List<String>.from(car['imagesUrl'] ?? [])
        .mapList((url) => ImageURL(url));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _kmController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _hpController.dispose();
    _priceController.dispose();
    _adUrlController.dispose();
    _adDateController.dispose();
    _locationController.dispose();
    _plateController.dispose();
    _vinController.dispose();
    super.dispose();
  }

  Validator get validator {
    _validator ??= Validator(context);
    return _validator!;
  }

  String get imageStoragePath {
    return 'images/${car['uuid']}';
  }

  bool get isImagesHasChanged {
    if (widget.baseCar == null) return true;

    final imagesUrls = _imagesData.whereType<ImageURL>().mapList((e) => e.data);
    if (!listEquals(widget.baseCar!.imagesUrl, imagesUrls)) {
      return true;
    }
    if (widget.baseCar!.imagesUrl.length != _imagesData.length) {
      return true;
    }
    return false;
  }

  void _displayError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _displayHandDrive(HandDrive value) {
    if (value == HandDrive.left) {
      return 'A gauche';
    }
    return 'A droite';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    // Localizations.localeOf(context).languageCode
    return DateFormat.yMMMMEEEEd('fr').format(date).capitalize();
  }

  Future<void> _addCar() async {
    setState(() => _isLoading = true);
    try {
      if (isImagesHasChanged) {
        // Save current images
        final images = await Future.wait(_imagesData.map((imageData) {
          if (imageData is ImageURL) {
            return networkImageData(imageData.data);
          }
          return (imageData as ImageFile).data.readAsBytes();
        }));

        // Delete current stored images of car
        await deleteAllFromStorage(imageStoragePath);

        // Save images
        final imagesUrl = await Future.wait(images.mapIndexed(
          (index, data) => saveToStorage(data, imageStoragePath, index),
        ));
        car['imagesUrl'] = imagesUrl;
      }
      if (!mounted) return;

      final newCar = Car.fromJson(car);

      final settingsController = context.read<SettingsCarsController>();
      if (widget.baseCar != null) {
        await settingsController.updateCar(newCar);
      } else {
        await settingsController.addCar(newCar);
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _displayError(e);
    }
  }

  Future<void> _onAddImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if ((images?.isEmpty ?? true) || !mounted) return;

    setState(() {
      _imagesData.addAll(images!.map((file) => ImageFile(file)));
    });
  }

  void _updateCarValue(String fieldKey, dynamic value) {
    setState(() => car[fieldKey] = value);
  }

  void _onStepContinue() {
    if (_formKeys[_currentStep].currentState?.validate() ?? false) {
      setState(() => _currentStep++);
    }
  }

  void _onStepTapped(step) {
    if (step > _currentStep) {
      if (!(_formKeys[_currentStep].currentState?.validate() ?? false)) {
        return;
      }
    }
    setState(() => _currentStep = step);
  }

  void _onStepCancel() => setState(() => _currentStep--);

  Future<void> _onDateFieldTap() async {
    final date = await showDatePicker(
      context: context,
      initialDate: car['adDate'] != null
          ? DateTime.parse(car['adDate'])
          : DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (date == null || !mounted) return;

    _adDateController.text = _formatDate(date);
    _updateCarValue('adDate', date.toIso8601String());
  }

  Future<void> _onLocationFieldTap() async {
    CarLocation? location = await Navigator.of(context).pushNamed(
      CarLocationPickerView.routeName,
      arguments: CarLocationPickerViewArguments(
        initialCarLocation: car['location'] != null
            ? CarLocation.fromJson(car['location'])
            : null,
      ),
    );
    if (location == null || !mounted) return;

    _locationController.text = location.address;
    _updateCarValue('location', location.toJson());
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: SizedBox.square(
        dimension: 17.0,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2.0,
        ),
      ),
    );
  }

  InputDecoration inputDeco({String? labelText}) {
    return InputDecoration(
      labelText: labelText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      filled: true,
    );
  }

  Step _buildStep({
    required String title,
    required int stepIndex,
    required List<Widget> content,
  }) {
    return Step(
      title: Text(title),
      state: _currentStep > stepIndex ? StepState.complete : StepState.indexed,
      isActive: _currentStep == stepIndex,
      content: Form(
        key: _formKeys[stepIndex],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: content,
        ),
      ),
    );
  }

  List<Widget> _buildStepInfo() {
    return <Widget>[
      TextFormField(
        controller: _titleController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: inputDeco(labelText: 'Titre *'),
        onChanged: (value) => _updateCarValue('title', value),
        validator: validator.noEmpty,
      ),
      TextFormField(
        controller: _descController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        minLines: 5,
        maxLines: 15,
        decoration: inputDeco(labelText: 'Description *'),
        onChanged: (value) => _updateCarValue('description', value),
        validator: validator.noEmpty,
      ),
      TextFormField(
        controller: _priceController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: const TextInputType.numberWithOptions(
          signed: true,
          decimal: false,
        ),
        decoration: inputDeco(labelText: 'Prix *').copyWith(
          suffixIcon: const Icon(Icons.euro),
        ),
        onChanged: (value) => _updateCarValue('price', int.tryParse(value)),
        validator: (value) => validator.inRange(value, 1),
      ),
      TextFormField(
        controller: _adUrlController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.url,
        decoration: inputDeco(labelText: 'Lien de l\'annonce *').copyWith(
          suffixIcon: const Icon(Icons.link),
        ),
        onChanged: (value) => _updateCarValue('adUrl', value),
        validator: validator.noEmpty,
      ),
      TextFormField(
        controller: _adDateController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: inputDeco(labelText: 'Date ajout de l\'annonce *'),
        readOnly: true,
        onTap: _onDateFieldTap,
        validator: validator.noEmpty,
      ),
      TextFormField(
        controller: _locationController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: inputDeco(labelText: 'Localisation *'),
        readOnly: true,
        onTap: _onLocationFieldTap,
        validator: validator.noEmpty,
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Statut'),
          Wrap(
            spacing: 16,
            children: [false, true].mapList((isSold) {
              return ChoiceChip(
                label: Text(isSold ? 'Vendu' : 'A vendre'),
                labelStyle: isSold == car['isSold']
                    ? const TextStyle(color: Colors.white)
                    : null,
                elevation: 4,
                selectedColor: Theme.of(context).colorScheme.secondary,
                selected: isSold == car['isSold'],
                onSelected: (_) => _updateCarValue('isSold', isSold),
              );
            }),
          ),
        ],
      ),
    ].superJoin(const SizedBox(height: 24.0));
  }

  List<Widget> _buildStepTech() {
    const keyboardType = TextInputType.numberWithOptions(
      signed: true,
      decimal: false,
    );

    return <Widget>[
      TextFormField(
        controller: _kmController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: keyboardType,
        decoration: inputDeco(labelText: 'Kilométrage *').copyWith(
          suffixText: 'KM',
        ),
        onChanged: (value) => _updateCarValue('kms', int.tryParse(value)),
        validator: (value) => validator.inRange(value, 1),
      ),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _monthController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: keyboardType,
                decoration: inputDeco(labelText: 'Mois *'),
                onChanged: (value) =>
                    _updateCarValue('month', int.tryParse(value)),
                validator: (value) => validator.inRange(value, 1, 12),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: TextFormField(
                controller: _yearController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: keyboardType,
                decoration: inputDeco(labelText: 'Année *'),
                onChanged: (value) =>
                    _updateCarValue('year', int.tryParse(value)),
                validator: (value) =>
                    validator.inRange(value, 1950, DateTime.now().year + 1),
              ),
            ),
          ],
        ),
      ),
      TextFormField(
        controller: _hpController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: keyboardType,
        decoration: inputDeco(labelText: 'Puissance *').copyWith(
          suffixText: 'HP',
        ),
        onChanged: (value) => _updateCarValue('hp', int.tryParse(value)),
        validator: (value) => validator.inRange(value, 1, 1000),
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Conduite'),
          Wrap(
            spacing: 16,
            children: HandDrive.values.mapList((handDrive) {
              return ChoiceChip(
                label: Text(_displayHandDrive(handDrive)),
                labelStyle: handDrive.name == car['handDrive']
                    ? const TextStyle(color: Colors.white)
                    : null,
                elevation: 4,
                selectedColor: Theme.of(context).colorScheme.secondary,
                selected: handDrive.name == car['handDrive'],
                onSelected: (bool selected) {
                  _updateCarValue(
                    'handDrive',
                    selected ? handDrive.name : null,
                  );
                },
              );
            }),
          ),
        ],
      ),
      TextFormField(
        controller: _plateController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.text,
        decoration: inputDeco(labelText: 'Plaque immatriculation'),
        onChanged: (value) => _updateCarValue('plate', value),
        validator: (value) => validator.emptyOrRegex(value, carPlateRegExp),
      ),
      TextFormField(
        controller: _vinController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.text,
        decoration: inputDeco(labelText: 'VIN'),
        onChanged: (value) => _updateCarValue('vin', value),
        validator: (value) => validator.emptyOrRegex(value, carVINRegExp),
      ),
    ].superJoin(const SizedBox(height: 24.0));
  }

  List<Widget> _buildStepImages() {
    final width = MediaQuery.of(context).size.width;
    final cardsByRow =
        ((width - kPadding * 2 - kCardSpacing * 2) / kCardSize).round();

    return <Widget>[
      ReorderableWrap(
        spacing: kCardSpacing,
        runSpacing: kCardSpacing,
        alignment: WrapAlignment.spaceBetween,
        onReorder: (int oldIndex, int newIndex) {
          // Use "- 1" because of first card is the add image
          setState(() => _imagesData.move(oldIndex - 1, newIndex - 1));
        },
        children: List.generate(
          (_imagesData.length + 1).roundToUpperMultiple(cardsByRow),
          (index) {
            if (index > _imagesData.length) {
              return ReorderableWidget(
                key: Key('$index'),
                reorderable: false,
                child: const SizedBox.square(dimension: kCardSize),
              );
            }
            return AddImageSquare(
              imageData: index > 0 ? _imagesData[index - 1] : null,
              size: kCardSize,
              onAdd: _onAddImage,
              onImageTap: () => setState(() => _imagesData.removeAt(index - 1)),
            );
          },
        ),
      ),
      const SizedBox(height: 24.0),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add car'),
      ),
      floatingActionButton: _currentStep == 2
          ? FloatingActionButton.extended(
              onPressed: !_isLoading ? _addCar : null,
              label: _isLoading
                  ? const Text('Ajout en cours…')
                  : const Text('Ajouter'),
              icon: _isLoading ? _buildLoader() : const Icon(Icons.add),
            )
          : null,
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        controlsBuilder: (_, details) => StepperControls(
          onStepContinue: details.onStepContinue,
          onStepCancel: details.onStepCancel,
        ),
        onStepContinue: _currentStep < 2 ? _onStepContinue : null,
        onStepTapped: _onStepTapped,
        onStepCancel: _currentStep > 0 ? _onStepCancel : null,
        steps: [
          _buildStep(
            title: 'Info',
            stepIndex: 0,
            content: _buildStepInfo(),
          ),
          _buildStep(
            title: 'Technical',
            stepIndex: 1,
            content: _buildStepTech(),
          ),
          _buildStep(
            title: 'Images',
            stepIndex: 2,
            content: _buildStepImages(),
          ),
        ],
      ),
    );
  }
}
