import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseService {
  final String _databaseURL = 'https://weartoweather-default-rtdb.europe-west1.firebasedatabase.app/';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DatabaseReference _dbRef() {
    return FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: _databaseURL,
    ).ref();
  }

  DatabaseReference _userRef(String userId) {
    return _dbRef().child('users').child(userId);
  }

  Future<void> createUserDocumentIfNeeded(String userId, {String? email, String? name}) async {
    final ref = _userRef(userId);
    final snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set({
        'userId': userId,
        'email': email ?? '',
        'name': name ?? '',
        'stylePreference': 'Casual',
        'temperatureSensitivity': 'Moderate',
        'createdAt': ServerValue.timestamp,
      });
    }
  }

  Future<void> addWardrobeItem(String userId, String category, String name) async {
    final ref = _userRef(userId).child('wardrobe').push();
    await ref.set({
      'category': category,
      'name': name,
      'createdAt': ServerValue.timestamp,
    });
  }

  Stream<DatabaseEvent> getWardrobeStream(String userId) {
    return _userRef(userId).child('wardrobe').onValue;
  }

  Future<void> deleteWardrobeItem(String userId, String itemId) async {
    await _userRef(userId).child('wardrobe').child(itemId).remove();
  }

  Future<void> addSavedOutfit(String userId, Map<String, dynamic> outfitData) async {
    final ref = _userRef(userId).child('savedOutfits').push();
    await ref.set({
      ...outfitData,
      'createdAt': ServerValue.timestamp,
    });
  }

  Stream<DatabaseEvent> getSavedOutfitsStream(String userId) {
    return _userRef(userId).child('savedOutfits').onValue;
  }

  Future<void> deleteSavedOutfit(String userId, String outfitId) async {
    await _userRef(userId).child('savedOutfits').child(outfitId).remove();
  }

  Future<void> setUserPreferences(String userId, Map<String, dynamic> preferences) async {
    await _userRef(userId).update(preferences);
  }

  Stream<DatabaseEvent> getUserPreferencesStream(String userId) {
    return _userRef(userId).onValue;
  }

  Future<void> updateProfile(String userId, String name, String style, String temp) async {
    await _userRef(userId).update({
      'name': name,
      'stylePreference': style,
      'temperatureSensitivity': temp,
    });
  }
}