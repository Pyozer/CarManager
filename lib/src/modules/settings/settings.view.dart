import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'settings_theme.controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final settingsThemeController = context.watch<SettingsThemeController>();
    final translate = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(translate.settingsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButton<ThemeMode>(
          value: settingsThemeController.themeMode,
          onChanged: settingsThemeController.updateThemeMode,
          items: [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text(translate.systemTheme),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text(translate.lightTheme),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text(translate.darkTheme),
            ),
          ],
        ),
      ),
    );
  }
}
