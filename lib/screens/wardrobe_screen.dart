import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../utils/app_styles.dart';

class ClothingItem {
  final String id;
  final String name;
  final String iconPlaceholder;
  final String category;

  ClothingItem({
    required this.id,
    required this.name,
    required this.iconPlaceholder,
    required this.category,
  });
}

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Dresses', 'Coats', 'T-shirts', 'Pants'];
  final String _databaseURL = 'https://weartoweather-default-rtdb.europe-west1.firebasedatabase.app/';

  DatabaseReference _getRef() {
    final user = FirebaseAuth.instance.currentUser;
    return FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: _databaseURL,
    ).ref("users/${user?.uid}/wardrobe");
  }

  Future<void> _addClothing(String category, String name) async {
    final ref = _getRef().push();
    await ref.set({
      'category': category,
      'name': name,
      'addedAt': ServerValue.timestamp,
    });
  }

  Future<void> _removeItem(String id) async {
    await _getRef().child(id).remove();
  }

  void _showAddItemDialog() {
    final TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add to $selectedCategory'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Item Name (e.g. Blue Coat)"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                _addClothing(selectedCategory, nameController.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  String _getIconForCategory(String category) {
    switch (category) {
      case 'Dresses': return '👗';
      case 'Coats': return '🧥';
      case 'T-shirts': return '👕';
      case 'Pants': return '👖';
      default: return '📦';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Wardrobe', style: AppStyles.titleStyle.copyWith(color: theme.colorScheme.onSurface)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                bool isSelected = selectedCategory == categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text(categories[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => selectedCategory = categories[index]);
                    },
                    selectedColor: isDark ? Colors.white : Colors.black,
                    labelStyle: TextStyle(
                      color: isSelected ? (isDark ? Colors.black : Colors.white) : theme.colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _getRef().onValue,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                List<ClothingItem> items = [];
                if (snapshot.data?.snapshot.value != null) {
                  final data = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);
                  data.forEach((key, value) {
                    final itemData = Map<String, dynamic>.from(value);
                    if (selectedCategory == 'All' || itemData['category'] == selectedCategory) {
                      items.add(ClothingItem(
                        id: key,
                        name: itemData['name'],
                        category: itemData['category'],
                        iconPlaceholder: _getIconForCategory(itemData['category']),
                      ));
                    }
                  });
                }

                if (items.isEmpty) return const Center(child: Text('No items in this category.'));

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      color: theme.colorScheme.surface,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item.iconPlaceholder, style: const TextStyle(fontSize: 50)),
                          const SizedBox(height: 10),
                          Text(item.name, style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => _removeItem(item.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: selectedCategory == 'All'
          ? null
          : FloatingActionButton.extended(
              onPressed: _showAddItemDialog,
              backgroundColor: isDark ? Colors.white : Colors.black,
              label: Text('Add to $selectedCategory', style: TextStyle(color: isDark ? Colors.black : Colors.white)),
              icon: Icon(Icons.add, color: isDark ? Colors.black : Colors.white),
            ),
    );
  }
}