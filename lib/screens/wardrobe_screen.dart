import 'package:flutter/material.dart';
import '../utils/app_styles.dart';

class ClothingItem {
  final String name;
  final String iconPlaceholder;
  final String category; 

  ClothingItem({
    required this.name, 
    required this.iconPlaceholder, 
    required this.category
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

  List<ClothingItem> allItems = [
    ClothingItem(name: 'Coat 1', iconPlaceholder: '🧥', category: 'Coats'),
    ClothingItem(name: 'T-shirt 1', iconPlaceholder: '👕', category: 'T-shirts'),
    ClothingItem(name: 'Shoes 1', iconPlaceholder: '👟', category: 'Pants'),
    ClothingItem(name: 'Coat 2', iconPlaceholder: '🧥', category: 'Coats'),
    ClothingItem(name: 'Summer Dress', iconPlaceholder: '👗', category: 'Dresses'),
  ];

  List<ClothingItem> get filteredItems {
    if (selectedCategory == 'All') {
      return allItems;
    }
    return allItems.where((item) => item.category == selectedCategory).toList();
  }

  void _removeItem(ClothingItem item) {
    setState(() {
      allItems.remove(item);
    });
  }

  void _addItem() {
    String categoryToAdd = selectedCategory == 'All' ? 'Coats' : selectedCategory;
    setState(() {
      allItems.add(ClothingItem(
        name: '$categoryToAdd ${allItems.length + 1}',
        iconPlaceholder: _getIconForCategory(categoryToAdd),
        category: categoryToAdd,
      ));
    });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wardrobe', style: AppStyles.titleStyle),
        backgroundColor: AppStyles.backgroundColor,
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
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                    selectedColor: Colors.black,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: filteredItems.isEmpty 
              ? const Center(child: Text('No items to show.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item.iconPlaceholder, style: const TextStyle(fontSize: 50)),
                          const SizedBox(height: 10),
                          Text(item.name, style: AppStyles.bodyStyle),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _removeItem(item),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
      floatingActionButton: selectedCategory == 'All' 
        ? null 
        : FloatingActionButton.extended(
            onPressed: _addItem, 
            backgroundColor: Colors.black,
            label: const Text('Add Item', style: TextStyle(color: Colors.white)),
            icon: const Icon(Icons.add, color: Colors.white),
          ),
    );
  }
}