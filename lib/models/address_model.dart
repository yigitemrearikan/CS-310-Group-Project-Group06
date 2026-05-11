import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String id;
  final String label;
  final String addressText;
  final String city;
  final double latitude;
  final double longitude;
  final bool isCurrent;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AddressModel({
    required this.id,
    required this.label,
    required this.addressText,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.isCurrent,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromMap(String id, Map<String, dynamic> map) {
    return AddressModel(
      id: id,
      label: map['label'] ?? '',
      addressText: map['addressText'] ?? '',
      city: map['city'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      isCurrent: map['isCurrent'] ?? false,
      createdBy: map['createdBy'] ?? '',
      createdAt: _toDateTime(map['createdAt']),
      updatedAt: _toDateTime(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'addressText': addressText,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'isCurrent': isCurrent,
      'createdBy': createdBy,
      'createdAt': createdAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(createdAt!),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'label': label,
      'addressText': addressText,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'isCurrent': isCurrent,
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