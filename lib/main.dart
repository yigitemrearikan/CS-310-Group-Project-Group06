import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:wear2weather/providers/settings_provider.dart';
import 'package:wear2weather/providers/auth_provider.dart';
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
import 'package:wear2weather/screens/NotificationScreen.dart';
import 'package:wear2weather/screens/screen6.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
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
      theme: settings.isDarkMode 
      ? ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF121212),
          colorScheme: const ColorScheme.dark(
            surface: Color(0xFF1E1E1E),
            onSurface: Colors.white,
          ),
        ) 
      : ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: const ColorScheme.light(
            surface: Colors.white,
            onSurface: Colors.black,
          ),
        ),
      home: StreamBuilder<auth.User?>(
        stream: auth.FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const MainNavigation();
          }
          return const WelcomeScreen();
        },
      ),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/screen2': (context) => Screen2(),
        '/sign-up': (context) => const SignUpScreen(),
        '/main-nav': (context) => const MainNavigation(),
        '/add-address': (context) => const AddAddressScreen(),
        '/home': (context) => HomeScreen(),
        '/weather': (context) => WeatherScreen(),
        '/wardrobe': (context) => const WardrobeScreen(),
        '/saved-outfits': (context) => const SavedOutfitsScreen(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },
    );
  }
}