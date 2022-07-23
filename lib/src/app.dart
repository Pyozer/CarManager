import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'modules/car/car_add.view.dart';
import 'modules/car/car_details.view.dart';
import 'modules/car/car_gallery.view.dart';
import 'modules/car/car_list.view.dart';
import 'modules/car/car_location.view.dart';
import 'modules/car/car_location_picker.view.dart';
import 'modules/car/model/car_location.model.dart';
import 'modules/filters/filters.view.dart';
import 'modules/filters/models/filters.model.dart';
import 'modules/settings/settings.view.dart';
import 'modules/settings/settings_theme.controller.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  MaterialPageRoute<T> _buildRoute<T>(RouteSettings settings, Widget child) {
    return MaterialPageRoute<T>(
      settings: settings,
      builder: (_) => child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsThemeController = context.watch<SettingsThemeController>();

    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        accentColor: Colors.blueAccent,
      ),
      toggleableActiveColor: Colors.blueAccent,
    );

    final darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        primarySwatch: Colors.yellow,
        accentColor: Colors.yellow,
      ),
      toggleableActiveColor: Colors.blueAccent,
    );

    return AnimatedBuilder(
      animation: settingsThemeController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('fr'),
            Locale('en'),
          ],
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: settingsThemeController.themeMode,
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case SettingsView.routeName:
                return _buildRoute<void>(
                  settings,
                  const SettingsView(),
                );

              case FiltersView.routeName:
                final args = settings.arguments as FiltersViewArguments?;
                return _buildRoute<Filters>(
                  settings,
                  FiltersView(baseFilters: args?.baseFilters),
                );

              case CarAddView.routeName:
                final args = settings.arguments as CarAddViewArguments?;
                return _buildRoute<void>(
                  settings,
                  CarAddView(baseCar: args?.baseCar),
                );

              case CarLocationPickerView.routeName:
                final args =
                    settings.arguments as CarLocationPickerViewArguments?;
                return _buildRoute<CarLocation>(
                  settings,
                  CarLocationPickerView(
                    initialCarLocation: args?.initialCarLocation,
                  ),
                );

              case CarDetailsView.routeName:
                final args = settings.arguments as CarDetailsViewArguments;
                return _buildRoute<void>(
                  settings,
                  CarDetailsView(carUUID: args.carUUID),
                );

              case CarLocationView.routeName:
                final args = settings.arguments as CarLocationViewArguments;
                return _buildRoute<void>(
                  settings,
                  CarLocationView(location: args.location),
                );

              case CarGalleryView.routeName:
                final args = settings.arguments as CarGalleryViewArguments;
                return _buildRoute<void>(
                  settings,
                  CarGalleryView(
                    imagesUrl: args.imagesUrl,
                    defaultIndex: args.defaultIndex,
                  ),
                );

              case CarListView.routeName:
              default:
                final args = settings.arguments as CarListViewArguments?;
                return _buildRoute<void>(
                  settings,
                  CarListView(isSold: args?.isSold ?? false),
                );
            }
          },
        );
      },
    );
  }
}
