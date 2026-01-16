
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class EmergencyPickupPage extends StatefulWidget {
  const EmergencyPickupPage({Key? key}) : super(key: key);

  @override
  State<EmergencyPickupPage> createState() => _EmergencyPickupPageState();
}

class _EmergencyPickupPageState extends State<EmergencyPickupPage> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
  String? _selectedWasteType;
  bool _isLoading = false;
  final int _emergencyCost = 50;

  final List<String> _wasteTypes = [
    'Medical Waste',
    'Chemical Spill',
    'Animal Waste',
    'Food Spoilage',
    'Construction Debris',
    'Other'
  ];

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Fill with sample data
    _nameController.text = 'John Doe';
    _phoneController.text = '+251911234567';
    _addressController.text = 'Addis Ababa, Ethiopia';
  }

  bool _isFormValid() {
    return _selectedWasteType != null &&
        _reasonController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _nameController.text.isNotEmpty;
  }

  Future<void> _submitEmergencyRequest() async {
    print('_submitEmergencyRequest called');
    if (!_isFormValid() || _isLoading) {
      print('Form not valid or loading');
      return;
    }

    // Validate form
    if (_formKey.currentState?.validate() ?? false) {
      print('Form validated, setting loading to true');
      setState(() => _isLoading = true);

      try {
        print('Saving to Firebase...');
        // Save to Firebase
        await FirebaseService.saveEmergencyPickup(
          wasteType: _selectedWasteType!,
          reason: _reasonController.text,
          address: _addressController.text,
          latitude: 9.0054,
          longitude: 38.7636,
          ecoCoins: _emergencyCost,
          phone: _phoneController.text,
          userName: _nameController.text,
          userEmail: 'user@example.com',
        );

        print('Firebase save successful, showing success dialog');
        // Show success dialog
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success!', style: TextStyle(color: Colors.green)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Emergency pickup request submitted successfully.'),
                const SizedBox(height: 10),
                Text('Cost: $_emergencyCost EcoCoins', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text('Your data has been stored securely in Firebase Database.'),
                const SizedBox(height: 10),
                const Text('Our team will contact you shortly for pickup arrangements.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  print('OK button pressed');
                  Navigator.pop(context);
                },
                child: const Text('OK', style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
        );
        
        print('Clearing form');
        // Clear form
        _reasonController.clear();
        setState(() {
          _selectedWasteType = null;
        });
        
      } catch (e) {
        print('Error occurred: $e');
        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error', style: TextStyle(color: Colors.red)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Failed to submit request.'),
                const SizedBox(height: 10),
                Text('Error: ${e.toString()}', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  print('Error OK button pressed');
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        print('Setting loading to false');
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showConfirmationDialog() async {
    print('_showConfirmationDialog called');
    
    if (!_isFormValid() || _isLoading) {
      print('Form not valid or loading in confirmation dialog');
      return;
    }

    // Validate form first
    if (!(_formKey.currentState?.validate() ?? false)) {
      print('Form validation failed in confirmation dialog');
      return;
    }

    print('Showing confirmation dialog');
    await showDialog(
      context: context,
      builder: (context) {
        print('Building confirmation dialog');
        return AlertDialog(
          title: const Text('Confirm Emergency Pickup'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Please confirm your emergency pickup request:'),
                const SizedBox(height: 15),
                
                // User info summary
                const Text('User Information:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Name: ${_nameController.text}'),
                Text('Phone: ${_phoneController.text}'),
                
                const SizedBox(height: 10),
                
                // Emergency details summary
                const Text('Emergency Details:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Waste Type: $_selectedWasteType'),
                Text('Address: ${_addressController.text}'),
                Text('Reason: ${_reasonController.text}'),
                
                const SizedBox(height: 15),
                
                // Cost information
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.yellow),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber, color: Colors.orange),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This will deduct $_emergencyCost EcoCoins from your account',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 10),
                
                const Text(
                  'Your data will be stored securely in our Firebase Database.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            // Cancel button
            TextButton(
              onPressed: () {
                print('Cancel button pressed');
                Navigator.pop(context);
              },
              child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
            ),
            
            // Confirm button
            ElevatedButton(
              onPressed: () {
                print('Confirm button pressed');
                Navigator.pop(context); // Close confirmation dialog
                _submitEmergencyRequest(); // Submit the request
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('CONFIRM & SUBMIT'),
            ),
          ],
        );
      },
    );
    print('Confirmation dialog closed');
  }

  @override
  Widget build(BuildContext context) {
    print('Building widget, isLoading: $_isLoading, formValid: ${_isFormValid()}');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Pickup'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade100),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emergency_outlined, color: Colors.red, size: 40),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Emergency Pickup',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[800],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Cost: $_emergencyCost EcoCoins',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // User Information Section
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'User Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Emergency Details Section
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Emergency Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        
                        // Waste Type Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedWasteType,
                          decoration: const InputDecoration(
                            labelText: 'Waste Type *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.delete_outline),
                          ),
                          items: _wasteTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a waste type';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            print('Waste type changed to: $value');
                            setState(() => _selectedWasteType = value);
                          },
                        ),
                        const SizedBox(height: 15),

                        // Pickup Address
                        TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: 'Pickup Address *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter pickup address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        // Emergency Reason
                        TextFormField(
                          controller: _reasonController,
                          decoration: const InputDecoration(
                            labelText: 'Emergency Reason *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.info_outline),
                            hintText: 'Why is this an emergency?',
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter emergency reason';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Submit Button - Simplified for debugging
                Container(
                  width: double.infinity,
                  height: 50,
                  child: _isLoading 
                      ? ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: const CircularProgressIndicator(color: Colors.white),
                        )
                      : ElevatedButton.icon(
                          onPressed: () {
                            print('REQUEST EMERGENCY PICKUP button pressed');
                            print('Selected waste type: $_selectedWasteType');
                            print('Name: ${_nameController.text}');
                            print('Phone: ${_phoneController.text}');
                            print('Address: ${_addressController.text}');
                            print('Reason: ${_reasonController.text}');
                            _showConfirmationDialog();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.emergency, color: Colors.white),
                          label: const Text(
                            'REQUEST EMERGENCY PICKUP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                
                // Info Text
                Center(
                  child: Text(
                    'Data will be stored securely in Firebase Database',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
