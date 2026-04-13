import 'package:flutter/material.dart';

import '../utils/app_styles.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();

  final List<String> _nearbyAddresses = [
    'Sabanci University, Tuzla',
    'Pendik Marina, Istanbul',
    'Kadikoy Center, Istanbul',
  ];

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _showInfoDialog(String title, String message) {
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

  void _submitAddress() {
    if (_formKey.currentState!.validate()) {
      _showInfoDialog(
        'Address Added',
        'Selected address: ${_addressController.text.trim()}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isWide = width > 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address', style: AppStyles.titleStyle),
        backgroundColor: AppStyles.backgroundColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: AppStyles.defaultPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Search for new address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Enter address',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Please enter an address';
                  }
                  if (text.length < 3) {
                    return 'Address must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Search'),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Nearby addresses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _nearbyAddresses.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWide ? 2 : 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isWide ? 3.4 : 4.5,
                ),
                itemBuilder: (context, index) {
                  final address = _nearbyAddresses[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.place),
                      title: Text(address),
                      onTap: () {
                        _addressController.text = address;
                        _showInfoDialog('Address Selected', address);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.my_location),
                  title: const Text('Use current location'),
                  onTap: () {
                    _showInfoDialog(
                      'Current Location',
                      'Current location has been selected.',
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.location_searching),
                  title: const Text('Enable location services'),
                  onTap: () {
                    _showInfoDialog(
                      'Location Services',
                      'Location services enabled successfully.',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}