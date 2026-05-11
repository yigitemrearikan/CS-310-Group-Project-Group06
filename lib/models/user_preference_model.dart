import 'package:cloud_firestore/cloud_firestore.dart';

class UserPreference {
  final String stylePreference;
  final String temperatureSensitivity;
  final String preferredColor;
  final DateTime? updatedAt;

  UserPreference({
    required this.stylePreference,
    required this.temperatureSensitivity,
    required this.preferredColor,
    this.updatedAt,
  });

  factory UserPreference.fromMap(Map<String, dynamic> map) {
    return UserPreference(
      stylePreference: map['stylePreference'] ?? '',
      temperatureSensitivity: map['temperatureSensitivity'] ?? '',
      preferredColor: map['preferredColor'] ?? '',
      updatedAt: _toDateTime(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stylePreference': stylePreference,
      'temperatureSensitivity': temperatureSensitivity,
      'preferredColor': preferredColor,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}