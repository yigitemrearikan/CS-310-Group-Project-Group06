import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear2weather/providers/settings_provider.dart'; 

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _emailController =
      TextEditingController(text: 'you@example.com');
  final TextEditingController _nameController =
      TextEditingController(text: 'Emre Arikan');

  String selectedStyle = 'Casual';
  String selectedTemp = 'Moderate';
  int _currentIndex = 4; 

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Widget buildChoiceChip(
    String label,
    String groupValue,
    Function(String) onTap,
  ) {
    final bool isSelected = label == groupValue;

    return GestureDetector(
      onTap: () => onTap(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildDescription(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    );
  }

  void _handleBottomNav(int index) {
    if (_currentIndex == index) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/weather');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/wardrobe');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/saved-outfits');
        break;
      case 4:
        break;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/', 
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showSaveMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes saved successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFEAEAEA)),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                             Navigator.pop(context);
                          } else {
                             Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                        child:
                            const Icon(Icons.arrow_back_ios_new, size: 20),
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsPage()), 
                          );
                        }, // BURADAKİ EKSİK PARANTEZ VE VİRGÜLÜ DÜZELTTİM
                        child: Icon(
                          Icons.settings,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NotificationsPage()),
                          );
                        },
                        child: const Icon(
                          Icons.notifications,
                          color: Color(0xFFC6A400),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Emre Arikan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                buildSectionTitle('Email'),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'you@example.com',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          const BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          const BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                  ),
                ),
                buildDescription('Your primary email for notifications'),
                const SizedBox(height: 24),
                buildSectionTitle('Name'),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Emre Arikan',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          const BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          const BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                  ),
                ),
                buildDescription('Your full name'),
                const SizedBox(height: 24),
                buildSectionTitle('Style Preference'),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    buildChoiceChip('Casual', selectedStyle, (value) {
                      setState(() {
                        selectedStyle = value;
                      });
                    }),
                    buildChoiceChip('Sporty', selectedStyle, (value) {
                      setState(() {
                        selectedStyle = value;
                      });
                    }),
                    buildChoiceChip('Formal', selectedStyle, (value) {
                      setState(() {
                        selectedStyle = value;
                      });
                    }),
                  ],
                ),
                buildDescription(
                  'Choose your preferred style for recommendations',
                ),
                const SizedBox(height: 24),
                buildSectionTitle('Temperature Sensitivity'),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    buildChoiceChip('Hot', selectedTemp, (value) {
                      setState(() {
                        selectedTemp = value;
                      });
                    }),
                    buildChoiceChip('Cold', selectedTemp, (value) {
                      setState(() {
                        selectedTemp = value;
                      });
                    }),
                    buildChoiceChip('Moderate', selectedTemp, (value) {
                      setState(() {
                        selectedTemp = value;
                      });
                    }),
                  ],
                ),
                buildDescription('Select your temperature preferences'),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _showLogoutDialog,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _showSaveMessage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: settings.isDarkMode,
            onChanged: (value) {
              context.read<SettingsProvider>().toggleTheme(value);
            },
          ),
          SwitchListTile(
            title: const Text('Temperature Unit (Celsius)'),
            subtitle: Text(settings.isCelsius ? 'Current: °C' : 'Current: °F'),
            value: settings.isCelsius,
            onChanged: (value) {
              context.read<SettingsProvider>().toggleUnit(value);
            },
          ),
        ],
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(
        child: Text('Notifications Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}