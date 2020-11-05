import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prapare/_internal/utils/theme_mode_util.dart';
import 'package:prapare/localization.dart';
import 'package:prapare/models/data/menu_option.dart';
import 'package:prapare/ui/views/settings/settings_controller.dart';

Future<void> settingsDialog() async =>
    await Get.dialog(_SettingsDialogContent());

class _SettingsDialogContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);

    //todo: extract into controller
    final List<MenuOption> themeOptions = [
      MenuOption(
          key: "system",
          value: labels.settings.system,
          icon: Icons.brightness_4),
      MenuOption(
          key: "light",
          value: labels.settings.light,
          icon: Icons.brightness_low),
      MenuOption(
          key: "dark", value: labels.settings.dark, icon: Icons.brightness_3)
    ];

    TextTheme textTheme = context.textTheme;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
        child: Column(
          children: [
            Center(
                child: Text(labels.app.settings, style: textTheme.headline5)),
            Expanded(
              child: GetX<SettingsController>(
                init: SettingsController(),
                builder: (controller) => ListView(
                  children: <Widget>[
                    SizedBox(height: 24),

                    // *** CHOOSE THEME ***
                    Center(
                        child: Text(labels.app.chooseTheme,
                            style: textTheme.bodyText1)),
                    ...themeOptions.map(
                      (e) => RadioListTile(
                        title: Text(e.value, style: textTheme.bodyText1),
                        value: ThemeModeUtil().convertStringToThemeMode(e.key),
                        groupValue: controller.rxThemeMode,
                        onChanged: (newValue) =>
                            controller.setThemeMode(newValue),
                      ),
                    ),
                    SizedBox(height: 24),

                    // *** CHOOSE LANGUAGE ***
                    Center(
                        child: Text(labels.app.chooseLanguage,
                            style: textTheme.bodyText1)),
                    ...controller.getlanguageOptions().map(
                          (e) => RadioListTile(
                            title: Text(e.value, style: textTheme.bodyText1),
                            value: e.key,
                            groupValue: controller.rxLanguage,
                            onChanged: (value) async =>
                                await controller.setLocale(value),
                          ),
                        ),
                  ],
                ),
              ),
            ),
            TextButton(
                onPressed: () => Get.back(),
                child: Text(labels.settings.ok, style: textTheme.headline6))
          ],
        ),
      ),
    );
  }
}
