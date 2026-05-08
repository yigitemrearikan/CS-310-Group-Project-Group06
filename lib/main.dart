import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart'; 
import 'package:provider/provider.dart';

import 'package:wear2weather/providers/settings_provider.dart';
import 'package:wear2weather/screens/settings_screen.dart';
import 'package:wear2weather/screens/welcome_screen.dart';
import 'package:wear2weather/screens/main_navigation.dart';
import 'package:wear2weather/screens/add_address_screen.dart';
import 'package:wear2weather/screens/sign_up_screen.dart';
import 'package:wear2weather/screens/home_screen.dart';
import 'package:wear2weather/screens/weather_screen.dart';
import 'package:wear2weather/screens/wardrobe_screen.dart';
import 'package:wear2weather/screens/saved_outfits_screen.dart';
import 'package:wear2weather/screens/screen2.dart';
import 'package:wear2weather/screens/screen6.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const WearToWeatherApp(), 
      ),
    ),
  );
}

class WearToWeatherApp extends StatelessWidget {  
  const WearToWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'WearToWeather',
      theme: settings.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/screen2': (context) => Screen2(),
        '/sign-up': (context) => SignUpScreen(),
        '/main-nav': (context) => const MainNavigation(),
        '/add-address': (context) => const AddAddressScreen(),
        '/home': (context) => HomeScreen(),
        '/weather': (context) => WeatherScreen(),
        '/wardrobe': (context) => WardrobeScreen(),
        '/saved-outfits': (context) => SavedOutfitsScreen(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}