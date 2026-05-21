import 'package:flutter_test/flutter_test.dart';

class StaticWeatherManager {
  final double defaultTemperature = 22.0; 
  final String defaultActivity = 'Campus';

  String getStaticRecommendation() {
    return 'Medium (Hoodie/Long Sleeve)';
  }
}

void main() {
  group('Wear2Weather - Static Weather Logic Unit Tests', () {
    
    test('Should verify the static default temperature of the application', () {
      final weatherManager = StaticWeatherManager();
      

      expect(weatherManager.defaultTemperature, equals(22.0));
    });

    test('Should return Medium outfit for the static 22 degrees baseline', () {
      final weatherManager = StaticWeatherManager();
      final recommendation = weatherManager.getStaticRecommendation();

      expect(recommendation, equals('Medium (Hoodie/Long Sleeve)'));
    });

  });
}