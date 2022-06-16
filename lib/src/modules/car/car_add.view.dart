import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:reorderables/reorderables.dart';
import 'package:uuid/uuid.dart';

import '../../modules/car/model/car.model.dart';
import '../../utils/image.util.dart';
import '../../utils/regexp.util.dart';
import '../../utils/list.extension.dart';
import '../../utils/string.extension.dart';
import '../../utils/validators.utils.dart';
import '../../widgets/stepper_controls.widget.dart';
import '../../widgets/add_image_square.widget.dart';
import '../settings/settings.controller.dart';
import 'widget/add_image_dialog.widget.dart';

class CarAddViewArguments {
  final Car? baseCar;

  CarAddViewArguments({this.baseCar});
}

class CarAddView extends StatefulWidget {
  final SettingsController controller;
  final Car? baseCar;

  const CarAddView({Key? key, required this.controller, this.baseCar})
      : super(key: key);

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
  late final TextEditingController _plateController;
  late final TextEditingController _vinController;

  late final Validator _validator;

  int _currentStep = 0;
  bool _isLoading = false;

  List<String> _imagesUrl = [];
  Map<String, dynamic> car = {
    'uuid': const Uuid().v4(),
    'handDrive': HandDrive.left.name,
    'isSold': false,
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
    _adDateController = TextEditingController(text: car['adDate']);
    _plateController = TextEditingController(text: car['plate']);
    _vinController = TextEditingController(text: car['vin']);
    _imagesUrl = List<String>.from(car['imagesUrl'] ?? []);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _validator = Validator(context);
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
    _plateController.dispose();
    _vinController.dispose();
    super.dispose();
  }

  Future<void> _addCar() async {
    setState(() => _isLoading = true);

    if (widget.baseCar == null ||
        !listEquals(widget.baseCar!.imagesUrl, _imagesUrl)) {
      // Download all images
      final imagesData = await Future.wait(
        _imagesUrl.mapIndexed((index, imageUrl) => networkImageData(imageUrl)),
      );

      // Delete current saved images to avoid duplicates in storage
      final imageStoragePath = 'images/${car['uuid']}';
      await deleteAllFromStorage(imageStoragePath);

      // Upload images previously downloaded
      final imagesStorageUrls = await Future.wait(
        imagesData.whereNotNull().mapIndexed((index, imageUrl) {
          return saveToStorage(imageUrl, imageStoragePath, index);
        }),
      );

      if (imagesStorageUrls.any((img) => img == null)) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Error during image saving to storage !',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }

      car['imagesUrl'] = imagesStorageUrls;
    }
    final newCar = Car.fromJson(car);

    if (widget.baseCar != null) {
      final index = widget.controller.carsSaved.indexWhere(
        (car) => car.uuid == widget.baseCar!.uuid,
      );
      widget.controller.carsSaved[index] = newCar;
      await widget.controller.updateCar(newCar);
    } else {
      await widget.controller.addCar(newCar);
    }
    Navigator.of(context).pop();
  }

  void _updateCarValue(String fieldKey, dynamic value) {
    setState(() => car[fieldKey] = value);
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.only(right: 8),
      child: SizedBox.square(
        dimension: 17,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      ),
    );
  }

  String _displayHandDrive(HandDrive value) {
    if (value == HandDrive.left) {
      return 'A gauche';
    }
    return 'A droite';
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
        validator: _validator.noEmpty,
      ),
      TextFormField(
        controller: _descController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        minLines: 5,
        maxLines: 15,
        decoration: inputDeco(labelText: 'Description *'),
        onChanged: (value) => _updateCarValue('description', value),
        validator: _validator.noEmpty,
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
        validator: (value) => _validator.inRange(value, 1),
      ),
      TextFormField(
        controller: _adUrlController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.url,
        decoration: inputDeco(labelText: 'Lien de l\'annonce *').copyWith(
          suffixIcon: const Icon(Icons.link),
        ),
        onChanged: (value) => _updateCarValue('adUrl', value),
        validator: _validator.noEmpty,
      ),
      TextFormField(
        controller: _adDateController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.url,
        decoration: inputDeco(labelText: 'Date ajout de l\'annonce *'),
        readOnly: true,
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: car['adDate'] != null
                ? DateTime.parse(car['adDate'])
                : DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now(),
          );
          if (date == null) return;

          _adDateController.text = DateFormat.yMMMMEEEEd(
            Localizations.localeOf(context).languageCode,
          ).format(date).capitalize();
          _updateCarValue('adDate', date.toIso8601String());
        },
        validator: _validator.noEmpty,
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Statut'),
          Wrap(
            spacing: 16,
            children: [false, true].map((isSold) {
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
            }).toList(),
          ),
        ],
      ),
    ].superJoin(const SizedBox(height: 24));
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
        validator: (value) => _validator.inRange(value, 1),
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
                validator: (value) => _validator.inRange(value, 1, 12),
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
                    _validator.inRange(value, 1950, DateTime.now().year + 1),
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
        validator: (value) => _validator.inRange(value, 1, 1000),
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Conduite'),
          Wrap(
            spacing: 16,
            children: HandDrive.values.map((handDrive) {
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
            }).toList(),
          ),
        ],
      ),
      TextFormField(
        controller: _plateController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.text,
        decoration: inputDeco(labelText: 'Plaque immatriculation'),
        onChanged: (value) => _updateCarValue('plate', value),
        validator: (value) => _validator.emptyOrRegex(value, carPlateRegExp),
      ),
      TextFormField(
        controller: _vinController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.text,
        decoration: inputDeco(labelText: 'VIN'),
        onChanged: (value) => _updateCarValue('vin', value),
        validator: (value) => _validator.emptyOrRegex(value, carVINRegExp),
      ),
    ].superJoin(const SizedBox(height: 24));
  }

  List<Widget> _buildStepImages() {
    return <Widget>[
      ReorderableWrap(
        spacing: 12,
        runSpacing: 12,
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            String imageUrl = _imagesUrl.removeAt(oldIndex - 1);
            _imagesUrl.insert(newIndex - 1, imageUrl);
          });
        },
        children: List.generate(_imagesUrl.length + 1, (index) {
          return AddImageSquare(
            imageUrl: index > 0 ? _imagesUrl[index - 1] : null,
            onAdd: () async {
              final imageUrl = await showDialog(
                context: context,
                builder: (_) => const AddImageDialog(),
              );
              if (imageUrl == null) return;

              if (Uri.tryParse(imageUrl)?.hasAbsolutePath ?? false) {
                setState(() => _imagesUrl.add(imageUrl));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Invalid image url !',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            onImageTap: () {
              setState(() => _imagesUrl.removeAt(index - 1));
            },
          );
        }),
      ),
      const SizedBox(height: 24),
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
        onStepContinue: _currentStep < 2
            ? () {
                if (_formKeys[_currentStep].currentState?.validate() ?? false) {
                  setState(() => _currentStep++);
                }
              }
            : null,
        onStepTapped: (step) {
          if (step > _currentStep) {
            if (!(_formKeys[_currentStep].currentState?.validate() ?? false)) {
              return;
            }
          }
          setState(() => _currentStep = step);
        },
        onStepCancel: _currentStep > 0
            ? () {
                setState(() => _currentStep--);
              }
            : null,
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
