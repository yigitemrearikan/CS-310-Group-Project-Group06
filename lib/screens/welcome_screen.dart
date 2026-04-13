import 'package:flutter/material.dart';
import '../utils/app_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: AppStyles.defaultPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "WearToWeather",
                textAlign: TextAlign.center,
                style: AppStyles.titleStyle,
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/main_screen_logo.png', 
                height: 150,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 10),
              const Text('OR', textAlign: TextAlign.center, style: AppStyles.bodyStyle),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home'); 
                },
                child: const Text('Continue as a guest'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}