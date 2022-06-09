import 'package:car_manager/src/modules/settings/settings.controller.dart';
import 'package:car_manager/src/widgets/image_network_loader.widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../modules/car/model/car.model.dart';
import '../../utils/regexp.util.dart';
import '../../utils/string.extension.dart';

class CarAddView extends StatefulWidget {
  final SettingsController controller;

  const CarAddView({Key? key, required this.controller}) : super(key: key);

  static const routeName = '/car_add';

  @override
  State<CarAddView> createState() => _CarAddViewState();
}

class _CarAddViewState extends State<CarAddView> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> car = {'imagesUrl': List<String>.from([])};

  String? _checkNoEmpty(String? value) {
    if (value?.isEmpty ?? true) return 'Field required';
    return null;
  }

  String? _checkEmptyOrRegex(String? value, RegExpInfo regExpInfo) {
    if (value?.isEmpty ?? true) return null;
    if (regExpInfo.regexp.hasMatch(value!)) return null;
    return 'Field must match like this ${regExpInfo.pattern}';
  }

  String? _checkIsNumber(String? value) {
    final isEmptyCheck = _checkNoEmpty(value);
    if (isEmptyCheck != null) return isEmptyCheck;
    if (int.tryParse(value ?? '') == null) return 'Field must be a number';
    return null;
  }

  String? _checkInRange(String? value, int from, [int to = 1000000]) {
    final isNumberCheck = _checkIsNumber(value);
    if (isNumberCheck != null) return isNumberCheck;
    if (int.parse(value!) < from || int.parse(value) > to) {
      return 'Field must be between $from and $to';
    }
    return null;
  }

  Future<String?> showAddImageDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('Enter image URL'),
          actions: [
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ADD'),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ],
          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(hintText: 'Image url, like https://...'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add car'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!(_formKey.currentState?.validate() ?? false)) {
            return;
          }
          car['id'] = widget.controller.carsSaved.isNotEmpty
              ? widget.controller.carsSaved.last.id
              : 1;
          final newCar = Car.fromJSON(car);
          await widget.controller.addCar(newCar);
          Navigator.of(context).pop();
        },
        label: const Text('Ajouter'),
        icon: const Icon(Icons.add),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: () {
          Form.of(primaryFocus!.context!)!.save();
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18.0, 32.0, 18.0, 124.0),
          children: [
            const Text('Title'),
            TextFormField(
              onChanged: (value) => setState(() => car['title'] = value),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Field required';
                }
                return null;
              },
            ),
            const SizedBox(height: 24.0),
            const Text('Description'),
            TextFormField(
              minLines: 5,
              maxLines: 15,
              onChanged: (value) => setState(() => car['description'] = value),
              validator: _checkNoEmpty,
            ),
            const SizedBox(height: 24.0),
            const Text('Lien Images'),
            const SizedBox(height: 12.0),
            Wrap(
              spacing: 12.0,
              runSpacing: 8.0,
              children: List.generate(car['imagesUrl'].length + 1, (index) {
                final isLast = index == car['imagesUrl'].length;

                return SizedBox.square(
                  dimension: 105,
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.0),
                      onTap: isLast
                          ? () async {
                              final imageUrl = await showAddImageDialog();
                              if (imageUrl?.trim().isEmpty ?? true) return;
                              if (!(Uri.tryParse(imageUrl!)?.hasAbsolutePath ??
                                  false)) return;

                              setState(() => car['imagesUrl'].add(imageUrl));
                            }
                          : null,
                      onLongPress: !isLast
                          ? () =>
                              setState(() => car['imagesUrl'].removeAt(index))
                          : null,
                      child: isLast
                          ? const Center(
                              child: Icon(Icons.add_a_photo, size: 105 / 2.7),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: ImageNetworkLoader(
                                car['imagesUrl'][index],
                                height: 105,
                              ),
                            ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24.0),
            const Text('KM'),
            TextFormField(
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: false,
              ),
              onChanged: (value) => setState(() => car['kms'] = int.tryParse(value)),
              validator: (value) => _checkInRange(value, 1),
            ),
            const SizedBox(height: 24.0),
            const Text('Année'),
            TextFormField(
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: false,
              ),
              onChanged: (value) => setState(() => car['year'] = int.tryParse(value)),
              validator: (value) =>
                  _checkInRange(value, 1950, DateTime.now().year + 1),
            ),
            const SizedBox(height: 24.0),
            const Text('Mois'),
            TextFormField(
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: false,
              ),
              onChanged: (value) => setState(() => car['month'] = int.tryParse(value)),
              validator: (value) => _checkInRange(value, 1, 12),
            ),
            const SizedBox(height: 24.0),
            const Text('HP'),
            TextFormField(
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: false,
              ),
              onChanged: (value) => setState(() => car['hp'] = int.tryParse(value)),
              validator: (value) => _checkInRange(value, 1, 1000),
            ),
            const SizedBox(height: 24.0),
            const Text('Prix'),
            TextFormField(
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: false,
              ),
              decoration: const InputDecoration(suffixIcon: Icon(Icons.euro)),
              onChanged: (value) => setState(() => car['price'] = int.tryParse(value)),
              validator: (value) => _checkInRange(value, 1),
            ),
            const SizedBox(height: 24.0),
            const Text('Conduite'),
            Wrap(
              spacing: 16.0,
              children: HandDrive.values.map((handDrive) {
                return ChoiceChip(
                  label: Text(handDrive.name.capitalize()),
                  elevation: 4,
                  selected: handDrive.name == car['handDrive'],
                  onSelected: (bool selected) {
                    setState(() {
                      car['handDrive'] = selected ? handDrive.name : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                const Text('Vendu ?'),
                Checkbox(
                  value: car['isSold'] ?? false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  onChanged: (isSold) => setState(() => car['isSold'] = isSold),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            const Text('Lien de l\'annonce'),
            TextFormField(
              keyboardType: TextInputType.url,
              onChanged: (value) => setState(() => car['adUrl'] = value),
              validator: _checkNoEmpty,
            ),
            const SizedBox(height: 24.0),
            const Text('Date ajout de l\'annonce'),
            TextFormField(
              controller: TextEditingController(
                text: car['adDate'] != null
                    ? DateFormat.yMMMEd(
                            Localizations.localeOf(context).languageCode)
                        .format(DateTime.parse(car['adDate']))
                        .capitalize()
                    : null,
              ),
              keyboardType: TextInputType.url,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 100)),
                  lastDate: DateTime.now(),
                );
                if (date == null) return;
                setState(() => car['adDate'] = date.toIso8601String());
              },
              onChanged: (value) => setState(() => car['adUrl'] = value),
              validator: _checkNoEmpty,
            ),
            const SizedBox(height: 24.0),
            const Text('Plaque immatriculation'),
            TextFormField(
              keyboardType: TextInputType.text,
              onChanged: (value) => setState(() => car['plate'] = value),
              validator: (value) => _checkEmptyOrRegex(value, carPlateRegExp),
            ),
            const SizedBox(height: 24.0),
            const Text('VIN'),
            TextFormField(
              keyboardType: TextInputType.text,
              onChanged: (value) => setState(() => car['vin'] = value),
              validator: (value) => _checkEmptyOrRegex(value, carVINRegExp),
            ),
          ],
        ),
      ),
    );
  }
}
