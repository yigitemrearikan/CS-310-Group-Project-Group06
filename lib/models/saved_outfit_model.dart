import 'package:cloud_firestore/cloud_firestore.dart';

class SavedOutfit {
  final String id;
  final String title;
  final String description;
  final List<String> itemIds;
  final String weatherCondition;
  final double temperature;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SavedOutfit({
    required this.id,
    required this.title,
    required this.description,
    required this.itemIds,
    required this.weatherCondition,
    required this.temperature,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory SavedOutfit.fromMap(String id, Map<String, dynamic> map) {
    return SavedOutfit(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      itemIds: List<String>.from(map['itemIds'] ?? []),
      weatherCondition: map['weatherCondition'] ?? '',
      temperature: (map['temperature'] ?? 0).toDouble(),
      createdBy: map['createdBy'] ?? '',
      createdAt: _toDateTime(map['createdAt']),
      updatedAt: _toDateTime(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'itemIds': itemIds,
      'weatherCondition': weatherCondition,
      'temperature': temperature,
      'createdBy': createdBy,
      'createdAt': createdAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(createdAt!),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'title': title,
      'description': description,
      'itemIds': itemIds,
      'weatherCondition': weatherCondition,
      'temperature': temperature,
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