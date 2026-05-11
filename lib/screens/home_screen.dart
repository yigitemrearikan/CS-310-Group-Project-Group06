import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import '../utils/app_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String getRecommendation(double temp) {
    if (temp < 10) return "It's freezing! Wear a thick Coat and a Scarf. 🧥🧣";
    if (temp < 20) return "A bit chilly. A Sweatshirt or a light Jacket would be perfect. 🧥";
    if (temp < 30) return "Great weather! A T-shirt and comfortable Pants are enough. 👕";
    return "It's hot! Stay cool with a Summer Dress or Shorts. 👗";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppStyles.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: FirebaseDatabase.instanceFor(
                  app: Firebase.app(),
                  databaseURL: 'https://weartoweather-default-rtdb.europe-west1.firebasedatabase.app/'
                ).ref("users/${user?.uid}/name").onValue,
                builder: (context, snapshot) {
                  String displayName = 'Guest';
                  if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                    displayName = snapshot.data!.snapshot.value.toString();
                  }
                  return Text(
                    'Hi, $displayName!',
                    style: AppStyles.titleStyle.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: 28,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                getRecommendation(22),
                style: AppStyles.bodyStyle.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              _buildWeatherCard(theme),
              const SizedBox(height: 30),
              Text(
                'Recommended for you',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildRecommendationGrid(theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Istanbul',
                style: TextStyle(
                  fontSize: 18,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '22°C',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'Partly Cloudy',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const Text('⛅', style: TextStyle(fontSize: 60)),
        ],
      ),
    );
  }

  Widget _buildRecommendationGrid(ThemeData theme) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.8,
      children: [
        _buildItemCard('Casual Style', '👕', theme),
        _buildItemCard('Outdoor Mix', '🧥', theme),
      ],
    );
  }

  Widget _buildItemCard(String title, String icon, ThemeData theme) {
    return Card(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}