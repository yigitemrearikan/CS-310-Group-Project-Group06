import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import '../utils/app_styles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _selectedStyle = 'Casual';
  String _selectedTemp = 'Moderate';

  final List<String> _styles = ['Casual', 'Sporty', 'Formal'];
  final List<String> _temps = ['Hot', 'Cold', 'Moderate'];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? '';
      try {
        final db = FirebaseDatabase.instanceFor(
            app: Firebase.app(), 
            databaseURL: 'https://weartoweather-default-rtdb.europe-west1.firebasedatabase.app/'
        );
        
        final ref = db.ref("users/${user.uid}");
        final snapshot = await ref.get();
        if (snapshot.exists && mounted) {
          final data = Map<String, dynamic>.from(snapshot.value as Map);
          setState(() {
            _nameController.text = data['name'] ?? '';
            _selectedStyle = data['stylePreference'] ?? 'Casual';
            _selectedTemp = data['temperatureSensitivity'] ?? 'Moderate';
          });
        }
      } catch (e) {
        debugPrint("Okuma Hatası: $e");
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        _showMessage(e.toString(), Colors.redAccent);
      }
    }
  }

  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final db = FirebaseDatabase.instanceFor(
          app: Firebase.app(), 
          databaseURL: 'https://weartoweather-default-rtdb.europe-west1.firebasedatabase.app/'
      );
      
      DatabaseReference ref = db.ref("users/${user.uid}");
      
      await ref.update({
        'name': _nameController.text.trim(),
        'stylePreference': _selectedStyle,
        'temperatureSensitivity': _selectedTemp,
        'email': user.email,
      });

      if (mounted) {
        _showMessage('Profile updated successfully!', Colors.green);
      }
    } catch (e) {
      if (mounted) {
        _showMessage('Failed to update: $e', Colors.redAccent);
      }
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppStyles.titleStyle.copyWith(color: theme.colorScheme.onSurface)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), 
            onPressed: () {
              Navigator.pushNamed(context, '/settings'); 
            }
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none), 
            onPressed: () {
              Navigator.pushNamed(context, '/notifications'); 
            }
          ),
        ],
        iconTheme: theme.iconTheme,
      ),
      body: SingleChildScrollView(
        padding: AppStyles.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                  child: Icon(Icons.person, size: 35, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                ),
                const SizedBox(width: 16),
                Text(
                  _nameController.text.isEmpty ? 'User' : _nameController.text,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text('Email', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              readOnly: true,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.onSurface),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Name', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.onSurface),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text('Style Preference', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: _styles.map((style) {
                final isSelected = _selectedStyle == style;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text(style),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedStyle = style);
                    },
                    selectedColor: isDark ? Colors.white : Colors.black,
                    labelStyle: TextStyle(
                      color: isSelected ? (isDark ? Colors.black : Colors.white) : theme.colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            Text('Temperature Sensitivity', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: _temps.map((temp) {
                final isSelected = _selectedTemp == temp;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text(temp),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedTemp = temp);
                    },
                    selectedColor: isDark ? Colors.white : Colors.black,
                    labelStyle: TextStyle(
                      color: isSelected ? (isDark ? Colors.black : Colors.white) : theme.colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _handleLogout,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: theme.colorScheme.onSurface),
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                    child: const Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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