import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_styles.dart';
import '../services/database_service.dart';

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
  final DatabaseService _dbService = DatabaseService();
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Dresses', 'Coats', 'T-shirts', 'Pants'];

  void _showAddItemDialog() {
    final TextEditingController nameController = TextEditingController();
    final user = FirebaseAuth.instance.currentUser;

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
              if (nameController.text.isNotEmpty && user != null) {
                _dbService.addWardrobeItem(user.uid, selectedCategory, nameController.text.trim());
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
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.isAnonymous) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Wardrobe', style: AppStyles.titleStyle.copyWith(color: theme.colorScheme.onSurface)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 64, color: theme.colorScheme.onSurface.withOpacity(0.5)),
              const SizedBox(height: 16),
              const Text(
                "Please sign up to manage your wardrobe!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/sign-up'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                ),
                child: const Text("Sign Up Now"),
              ),
            ],
          ),
        ),
      );
    }

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
              stream: _dbService.getWardrobeStream(user.uid),
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
                            onPressed: () => _dbService.deleteWardrobeItem(user.uid, item.id),
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