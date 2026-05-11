import 'package:flutter/foundation.dart';

import '../models/address_model.dart';
import '../models/saved_outfit_model.dart';
import '../models/user_preference_model.dart';
import '../models/wardrobe_item_model.dart';
import '../services/firestore_service.dart';

class DatabaseProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;

  DatabaseProvider({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

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

  // -----------------------------
  // Wardrobe Items
  // -----------------------------

  Stream<List<WardrobeItem>> getWardrobeItems(String userId) {
    return _firestoreService.getWardrobeItems(userId);
  }

  Future<void> addWardrobeItem(
    String userId,
    WardrobeItem item,
  ) async {
    await _run(() => _firestoreService.addWardrobeItem(userId, item));
  }

  Future<void> updateWardrobeItem(
    String userId,
    WardrobeItem item,
  ) async {
    await _run(() => _firestoreService.updateWardrobeItem(userId, item));
  }

  Future<void> deleteWardrobeItem(
    String userId,
    String itemId,
  ) async {
    await _run(() => _firestoreService.deleteWardrobeItem(userId, itemId));
  }

  // -----------------------------
  // Saved Outfits
  // -----------------------------

  Stream<List<SavedOutfit>> getSavedOutfits(String userId) {
    return _firestoreService.getSavedOutfits(userId);
  }

  Future<void> addSavedOutfit(
    String userId,
    SavedOutfit outfit,
  ) async {
    await _run(() => _firestoreService.addSavedOutfit(userId, outfit));
  }

  Future<void> updateSavedOutfit(
    String userId,
    SavedOutfit outfit,
  ) async {
    await _run(() => _firestoreService.updateSavedOutfit(userId, outfit));
  }

  Future<void> deleteSavedOutfit(
    String userId,
    String outfitId,
  ) async {
    await _run(() => _firestoreService.deleteSavedOutfit(userId, outfitId));
  }

  // -----------------------------
  // Addresses
  // -----------------------------

  Stream<List<AddressModel>> getAddresses(String userId) {
    return _firestoreService.getAddresses(userId);
  }

  Future<void> addAddress(
    String userId,
    AddressModel address,
  ) async {
    await _run(() => _firestoreService.addAddress(userId, address));
  }

  Future<void> updateAddress(
    String userId,
    AddressModel address,
  ) async {
    await _run(() => _firestoreService.updateAddress(userId, address));
  }

  Future<void> deleteAddress(
    String userId,
    String addressId,
  ) async {
    await _run(() => _firestoreService.deleteAddress(userId, addressId));
  }

  // -----------------------------
  // User Preferences
  // -----------------------------

  Stream<UserPreference?> getUserPreferences(String userId) {
    return _firestoreService.getUserPreferences(userId);
  }

  Future<void> setUserPreferences(
    String userId,
    UserPreference preferences,
  ) async {
    await _run(() => _firestoreService.setUserPreferences(userId, preferences));
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