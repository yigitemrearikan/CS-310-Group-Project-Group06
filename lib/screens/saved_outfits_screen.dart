import 'package:flutter/material.dart';

import '../utils/app_styles.dart';

class OutfitItem {
  final String title;
  final String description;
  final String icon;
  bool isSelected;

  OutfitItem({
    required this.title,
    required this.description,
    required this.icon,
    this.isSelected = false,
  });
}

class SavedOutfitsScreen extends StatefulWidget {
  const SavedOutfitsScreen({super.key});

  @override
  State<SavedOutfitsScreen> createState() => _SavedOutfitsScreenState();
}

class _SavedOutfitsScreenState extends State<SavedOutfitsScreen> {
  final List<OutfitItem> _outfits = [
    OutfitItem(title: 'Outfit 1', description: 'Summer Dress', icon: '👗'),
    OutfitItem(title: 'Outfit 2', description: 'Casual Outfit', icon: '👚'),
    OutfitItem(title: 'Outfit 3', description: 'Evening Gown', icon: '👖'),
    OutfitItem(title: 'Outfit 4', description: 'Sporty Look', icon: '👟'),
  ];

  void _toggleSelection(int index) {
    setState(() {
      _outfits[index].isSelected = !_outfits[index].isSelected;
    });
  }

  void _deleteSelected() {
    final selectedCount = _outfits.where((item) => item.isSelected).length;

    if (selectedCount == 0) {
      _showDialog('No Selection', 'Please select at least one outfit.');
      return;
    }

    setState(() {
      _outfits.removeWhere((item) => item.isSelected);
    });

    _showDialog('Deleted', '$selectedCount selected outfit(s) removed successfully.');
  }

  void _reuseOutfits() {
    final selectedCount = _outfits.where((item) => item.isSelected).length;

    if (selectedCount == 0) {
      _showDialog('No Selection', 'Please select at least one outfit.');
      return;
    }

    _showDialog('Reuse Outfits', '$selectedCount selected outfit(s) are ready to reuse.');
  }

  void _showDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final int crossAxisCount = width > 900 ? 4 : width > 650 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Outfits', style: AppStyles.titleStyle),
        backgroundColor: AppStyles.backgroundColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: AppStyles.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saved outfit combinations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: _outfits.isEmpty
                  ? const Center(
                      child: Text(
                        'No saved outfits left.',
                        style: AppStyles.bodyStyle,
                      ),
                    )
                  : GridView.builder(
                      itemCount: _outfits.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.82,
                      ),
                      itemBuilder: (context, index) {
                        final outfit = _outfits[index];
                        return GestureDetector(
                          onTap: () => _toggleSelection(index),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(
                                color: outfit.isSelected ? Colors.red : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      outfit.isSelected
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const Spacer(),
                                  Center(
                                    child: Text(
                                      outfit.icon,
                                      style: const TextStyle(fontSize: 48),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    outfit.description,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    outfit.title,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Saved',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _deleteSelected,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Delete Selected'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _reuseOutfits,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Reuse Outfits'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}