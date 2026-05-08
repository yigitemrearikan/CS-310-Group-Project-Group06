import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear2weather/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: settings.isDarkMode,
            onChanged: (value) {
              context.read<SettingsProvider>().toggleTheme(value);
            },
          ),
          SwitchListTile(
            title: const Text('Temperature Unit (Celsius)'),
            subtitle: Text(settings.isCelsius ? 'Current: °C' : 'Current: °F'),
            value: settings.isCelsius,
            onChanged: (value) {
              context.read<SettingsProvider>().toggleUnit(value);
            },
          ),
        ],
      ),
    );
  }
}