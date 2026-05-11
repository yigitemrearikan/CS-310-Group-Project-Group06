import 'package:flutter/foundation.dart';
import '../services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseService _dbService;

  DatabaseProvider({DatabaseService? dbService})
      : _dbService = dbService ?? DatabaseService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _setError(null);
  }

  Stream<DatabaseEvent> getWardrobeItems(String userId) {
    return _dbService.getWardrobeStream(userId);
  }

  Future<void> addWardrobeItem(String userId, String category, String name) async {
    await _run(() => _dbService.addWardrobeItem(userId, category, name));
  }

  Future<void> deleteWardrobeItem(String userId, String itemId) async {
    await _run(() => _dbService.deleteWardrobeItem(userId, itemId));
  }

  Stream<DatabaseEvent> getSavedOutfits(String userId) {
    return _dbService.getSavedOutfitsStream(userId);
  }

  Future<void> addSavedOutfit(String userId, Map<String, dynamic> outfitData) async {
    await _run(() => _dbService.addSavedOutfit(userId, outfitData));
  }

  Future<void> deleteSavedOutfit(String userId, String outfitId) async {
    await _run(() => _dbService.deleteSavedOutfit(userId, outfitId));
  }

  Stream<DatabaseEvent> getUserPreferences(String userId) {
    return _dbService.getUserPreferencesStream(userId);
  }

  Future<void> setUserPreferences(String userId, Map<String, dynamic> preferences) async {
    await _run(() => _dbService.setUserPreferences(userId, preferences));
  }

  Future<void> updateProfile(String userId, String name, String style, String temp) async {
    await _run(() => _dbService.updateProfile(userId, name, style, temp));
  }

  Future<void> _run(Future<void> Function() operation) async {
    try {
      _setLoading(true);
      _setError(null);
      await operation();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}