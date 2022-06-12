import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'modules/car/car_add.view.dart';
import 'modules/car/car_archive_list.view.dart';
import 'modules/car/car_details.view.dart';
import 'modules/car/car_gallery.view.dart';
import 'modules/car/car_list.view.dart';
import 'modules/filters/filters.view.dart';
import 'modules/settings/settings.controller.dart';
import 'modules/settings/settings.view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  final SettingsController settingsController;

  const MyApp({Key? key, required this.settingsController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        accentColor: Colors.blueAccent,
      ),
      toggleableActiveColor: Colors.blueAccent,
    );
    final darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        accentColor: Colors.blueAccent,
      ),
      toggleableActiveColor: Colors.blueAccent,
    );

    return AnimatedBuilder(
      animation: settingsController,
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
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings settings) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (BuildContext context) {
                switch (settings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);

                  case FiltersView.routeName:
                    return const FiltersView();

                  case CarAddView.routeName:
                    final args = settings.arguments as CarAddViewArguments?;
                    return CarAddView(
                      controller: settingsController,
                      baseCar: args?.baseCar,
                    );

                  case CarDetailsView.routeName:
                    final args = settings.arguments as CarDetailsViewArguments;
                    return CarDetailsView(
                      controller: settingsController,
                      carUUID: args.carUUID,
                    );

                  case CarGalleryView.routeName:
                    final args = settings.arguments as CarGalleryViewArguments;
                    return CarGalleryView(
                      imagesUrl: args.imagesUrl,
                      defaultIndex: args.defaultIndex,
                    );

                  case CarArchiveListView.routeName:
                    return CarArchiveListView(controller: settingsController);

                  case CarListView.routeName:
                  default:
                    return CarListView(controller: settingsController);
                }
              },
            );
          },
        );
      },
    );
  }
}
