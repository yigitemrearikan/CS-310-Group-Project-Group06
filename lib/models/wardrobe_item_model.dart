import 'package:cloud_firestore/cloud_firestore.dart';

class WardrobeItem {
  final String id;
  final String name;
  final String category;
  final String color;
  final String season;
  final String imageUrl;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WardrobeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    required this.season,
    required this.imageUrl,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory WardrobeItem.fromMap(String id, Map<String, dynamic> map) {
    return WardrobeItem(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      color: map['color'] ?? '',
      season: map['season'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdBy: map['createdBy'] ?? '',
      createdAt: _toDateTime(map['createdAt']),
      updatedAt: _toDateTime(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'color': color,
      'season': season,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'createdAt': createdAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(createdAt!),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'name': name,
      'category': category,
      'color': color,
      'season': season,
      'imageUrl': imageUrl,
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