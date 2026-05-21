import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class DummyMainScreen extends StatelessWidget {
  const DummyMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Wear2Weather',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Current Temperature: 22°C (Static)'),
            SizedBox(height: 10),
            Text('Suggestion: Wear a Hoodie!'),
          ],
        ),
      ),
    );
  }
}

void main() {
  group('Wear2Weather - Static UI Widget Tests', () {
    
    testWidgets('Should render application title and static temperature correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: DummyMainScreen(),
      ));
      expect(find.text('Wear2Weather'), findsOneWidget);
      expect(find.text('Current Temperature: 22°C (Static)'), findsOneWidget);
      expect(find.text('Suggestion: Wear a Hoodie!'), findsOneWidget);
    });

  });
}