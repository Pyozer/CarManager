import 'package:car_manager/src/widgets/image_network_loader.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/car.model.dart';
import '../car_details.view.dart';

class CarCard extends StatelessWidget {
  final Car car;

  const CarCard({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final borderRadius = BorderRadius.circular(12.0);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {
          Navigator.pushNamed(
            context,
            CarDetailsView.routeName,
            arguments: CarDetailsViewArguments(car: car),
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(car.title, style: textTheme.titleSmall),
                    const SizedBox(height: 8.0),
                    Text(
                      '${car.displayDate} - ${car.displayKMs} - ${car.displayHandDrive}',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(car.displayPrice, style: textTheme.titleMedium),
                        if (car.isSold)
                          Text(
                            AppLocalizations.of(context)!.sold,
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
