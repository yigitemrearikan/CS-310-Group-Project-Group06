import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/wardrobe_item_model.dart';
import '../models/saved_outfit_model.dart';
import '../models/address_model.dart';
import '../models/user_preference_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _wardrobeRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('wardrobeItems');
  }

  CollectionReference<Map<String, dynamic>> _outfitsRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('savedOutfits');
  }

  CollectionReference<Map<String, dynamic>> _addressesRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('addresses');
  }

  DocumentReference<Map<String, dynamic>> _preferencesRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('preferences').doc('settings');
  }

  Future<void> createUserDocumentIfNeeded(String userId, {String? email}) async {
    final userDoc = _firestore.collection('users').doc(userId);

    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      await userDoc.set({
        'userId': userId,
        'email': email ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // =========================
  // Wardrobe CRUD
  // =========================

  Future<String> addWardrobeItem(String userId, WardrobeItem item) async {
    final docRef = await _wardrobeRef(userId).add(item.toMap());
    return docRef.id;
  }

  Stream<List<WardrobeItem>> getWardrobeItems(String userId) {
    return _wardrobeRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return WardrobeItem.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> updateWardrobeItem(String userId, WardrobeItem item) async {
    await _wardrobeRef(userId).doc(item.id).update(item.toUpdateMap());
  }

  Future<void> deleteWardrobeItem(String userId, String itemId) async {
    await _wardrobeRef(userId).doc(itemId).delete();
  }

  // =========================
  // Saved Outfit CRUD
  // =========================

  Future<String> addSavedOutfit(String userId, SavedOutfit outfit) async {
    final docRef = await _outfitsRef(userId).add(outfit.toMap());
    return docRef.id;
  }

  Stream<List<SavedOutfit>> getSavedOutfits(String userId) {
    return _outfitsRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return SavedOutfit.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> updateSavedOutfit(String userId, SavedOutfit outfit) async {
    await _outfitsRef(userId).doc(outfit.id).update(outfit.toUpdateMap());
  }

  Future<void> deleteSavedOutfit(String userId, String outfitId) async {
    await _outfitsRef(userId).doc(outfitId).delete();
  }

  // =========================
  // Address CRUD
  // =========================

  Future<String> addAddress(String userId, AddressModel address) async {
    if (address.isCurrent) {
      await _clearCurrentAddresses(userId);
    }

    final docRef = await _addressesRef(userId).add(address.toMap());
    return docRef.id;
  }

  Stream<List<AddressModel>> getAddresses(String userId) {
    return _addressesRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AddressModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> updateAddress(String userId, AddressModel address) async {
    if (address.isCurrent) {
      await _clearCurrentAddresses(userId);
    }

    await _addressesRef(userId).doc(address.id).update(address.toUpdateMap());
  }

  Future<void> deleteAddress(String userId, String addressId) async {
    await _addressesRef(userId).doc(addressId).delete();
  }

  Future<void> _clearCurrentAddresses(String userId) async {
    final currentAddresses = await _addressesRef(userId)
        .where('isCurrent', isEqualTo: true)
        .get();

    final batch = _firestore.batch();

    for (final doc in currentAddresses.docs) {
      batch.update(doc.reference, {
        'isCurrent': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  // =========================
  // Preferences
  // =========================

  Future<void> setUserPreferences(String userId, UserPreference preference) async {
    await _preferencesRef(userId).set(preference.toMap());
  }

  Stream<UserPreference?> getUserPreferences(String userId) {
    return _preferencesRef(userId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }

      return UserPreference.fromMap(snapshot.data()!);
    });
  }

  Future<void> updateUserPreferences(
    String userId,
    UserPreference preference,
  ) async {
    await _preferencesRef(userId).set(
      preference.toMap(),
      SetOptions(merge: true),
    );
  }
}