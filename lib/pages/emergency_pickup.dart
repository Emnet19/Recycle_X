import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

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
  bool _isGettingLocation = false;
  final int _emergencyCost = 10;
  double? _latitude;
  double? _longitude;

  final List<String> _wasteTypes = [
    'Medical Waste',
    'Chemical Spill',
    'Animal Waste',
    'Food Spoilage',
    'Construction Debris',
    'Industrial Waste',
    'Electronic Waste',
    'Other Hazardous Material'
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _getCurrentLocation();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      if (doc.exists) {
        setState(() {
          _nameController.text = doc.data()?['name'] ?? '';
          _phoneController.text = doc.data()?['phone'] ?? '';
        });
      }
    }
  }



Future<void> _getCurrentLocation() async {
  setState(() => _isGettingLocation = true);
  
  try {
    Position position = await LocationService.getCurrentLocation();
    
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
    
    // Just show coordinates
    _addressController.text = 'Location: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
    
  } catch (e) {
    print('Location error: $e');
    _addressController.text = 'Addis Ababa, Ethiopia (default)';
  } finally {
    setState(() => _isGettingLocation = false);
  }
}

  Future<void> _submitEmergencyRequest() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      // Check if user has enough EcoCoins
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      final userEcoCoins = userDoc.data()?['ecoCoins'] ?? 0;
      if (userEcoCoins < _emergencyCost) {
        throw Exception('Insufficient EcoCoins. You need $_emergencyCost but have $userEcoCoins');
      }

      // Save emergency pickup
      await FirebaseFirestore.instance.collection('emergency_pickups').add({
        'userId': user.uid,
        'userName': _nameController.text.trim(),
        'userEmail': user.email,
        'userPhone': _phoneController.text.trim(),
        'wasteType': _selectedWasteType!,
        'reason': _reasonController.text.trim(),
        'address': _addressController.text.trim(),
        'latitude': _latitude ?? 9.0320,
        'longitude': _longitude ?? 38.7469,
        'ecoCoins': _emergencyCost,
        'status': 'pending',
        'priority': 'high',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'isEmergency': true,
      });

      // Deduct EcoCoins
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'ecoCoins': FieldValue.increment(-_emergencyCost),
        'totalEmergencyPickups': FieldValue.increment(1),
      });

      // Show success
      await _showSuccessDialog();

    } catch (e) {
      await _showErrorDialog(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 10),
            Text(
              'Request Submitted!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your emergency pickup request has been submitted successfully.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 15),
              
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.emoji_events, color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Emergency Cost',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      '$_emergencyCost EcoCoins have been deducted from your account.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 15),
              
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Response Time',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Our team will contact you within 30 minutes for pickup arrangements.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to previous screen
            },
            child: Text(
              'RETURN HOME',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showErrorDialog(String error) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 30),
            SizedBox(width: 10),
            Text('Submission Failed', style: TextStyle(color: Colors.red)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Failed to submit emergency request.'),
            SizedBox(height: 10),
            Text(
              error.contains('Insufficient') 
                ? error 
                : 'Please check your internet connection and try again.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildWasteTypeIcon(String type) {
    switch (type) {
      case 'Medical Waste':
        return Icon(Icons.medical_services, color: Colors.red);
      case 'Chemical Spill':
        return Icon(Icons.science, color: Colors.orange);
      case 'Animal Waste':
        return Icon(Icons.pets, color: Colors.brown);
      case 'Food Spoilage':
        return Icon(Icons.food_bank, color: Colors.green);
      case 'Construction Debris':
        return Icon(Icons.construction, color: Colors.grey);
      case 'Industrial Waste':
        return Icon(Icons.factory, color: Colors.purple);
      case 'Electronic Waste':
        return Icon(Icons.devices, color: Colors.blue);
      default:
        return Icon(Icons.warning, color: Colors.amber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar with Gradient
          SliverAppBar(
            expandedHeight: 150,
            floating: false,
            pinned: true,
            backgroundColor: Colors.red,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Emergency Pickup',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.red[700]!, Colors.red[500]!, Colors.orange[700]!],
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emergency,
                          size: 40,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '24/7 Emergency Service',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Emergency Alert Card
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.red[50]!, Colors.orange[50]!],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.red.shade200, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red,
                            size: 40,
                          ),
                          SizedBox(width: 15),
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
                                SizedBox(height: 5),
                                Text(
                                  'Immediate response within 30 minutes',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.emoji_events, size: 18, color: Colors.amber),
                                    SizedBox(width: 5),
                                    Text(
                                      'Cost: $_emergencyCost EcoCoins',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.amber[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 25),

                    // User Information Section
                    Text(
                      'Your Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 10),

                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person, color: Colors.blue),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                prefixIcon: Icon(Icons.phone, color: Colors.green),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter phone number';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 25),

                    // Emergency Details Section
                    Text(
                      'Emergency Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 10),

                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Waste Type
                            DropdownButtonFormField<String>(
                              value: _selectedWasteType,
                              decoration: InputDecoration(
                                labelText: 'Type of Emergency Waste *',
                                prefixIcon: Icon(Icons.delete_outline, color: Colors.red),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              items: _wasteTypes.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Row(
                                    children: [
                                      _buildWasteTypeIcon(type),
                                      SizedBox(width: 10),
                                      Text(type),
                                    ],
                                  ),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select waste type';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() => _selectedWasteType = value);
                              },
                            ),

                            SizedBox(height: 15),

                            // Location with Auto-detect
                            TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                labelText: 'Pickup Location *',
                                prefixIcon: Icon(Icons.location_on, color: Colors.purple),
                                suffixIcon: _isGettingLocation
                                    ? CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                                      )
                                    : IconButton(
                                        icon: Icon(Icons.my_location, color: Colors.blue),
                                        onPressed: _getCurrentLocation,
                                      ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              maxLines: 2,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter pickup location';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 15),

                            // Emergency Reason
                            TextFormField(
                              controller: _reasonController,
                              decoration: InputDecoration(
                                labelText: 'Emergency Description *',
                                prefixIcon: Icon(Icons.description, color: Colors.orange),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                hintText: 'Describe the emergency situation...',
                              ),
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please describe the emergency';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Important Notes
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: Colors.amber[800]),
                              SizedBox(width: 10),
                              Text(
                                'Important Information',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[900],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            '• Emergency pickups have higher priority and cost extra EcoCoins\n'
                            '• Our team will contact you within 30 minutes\n'
                            '• Please ensure hazardous materials are properly contained\n',
                            // '• You will receive SMS and app notifications',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 25),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () {
                          if (_formKey.currentState!.validate()) {
                            _submitEmergencyRequest();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: Colors.red.withOpacity(0.3),
                        ),
                        child: _isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Processing Emergency...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.emergency, size: 24),
                                  SizedBox(width: 12),
                                  Text(
                                    'SUBMIT EMERGENCY REQUEST',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    SizedBox(height: 15),

                    // Cost Info
                    Center(
                      child: Text(
                        '$_emergencyCost EcoCoins will be deducted from your account',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
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




