import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../widgets/image_network_loader.widget.dart';
import '../car_details.view.dart';
import '../model/car.model.dart';

class CarCard extends StatelessWidget {
  final Car car;

  const CarCard({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final borderRadius = BorderRadius.circular(12);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {
          Navigator.pushNamed(
            context,
            CarDetailsView.routeName,
            arguments: CarDetailsViewArguments(carUUID: car.uuid),
          );
        },
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: car.imagesUrl.first,
                child: ImageNetworkLoader(
                  car.imagesUrl.first,
                  height: 175,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(car.title, style: textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Text(
                      '${car.displayDate} - ${car.displayKMs} - ${car.handDrive.name}',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(car.displayPrice, style: textTheme.titleMedium),
                        if (car.isSold)
                          Text(
                            AppLocalizations.of(context)!.sold.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
