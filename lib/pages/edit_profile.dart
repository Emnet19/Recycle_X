
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  
  File? _profileImage;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _selectedCity = 'Addis Ababa';
  
  final List<String> _cities = [
    'Addis Ababa',
    'Adama',
    'Bahir Dar',
    'Mekelle',
    'Dire Dawa',
    'Hawassa',
    'Jimma',
    'Gondar',
    'Debre Markos',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

Future<void> _loadUserData() async {
  print('=== LOADING USER DATA ===');
  setState(() => _isLoading = true);
  
  final user = _auth.currentUser;
  if (user == null) {
    print(' No user logged in');
    setState(() => _isLoading = false);
    return;
  }

  try {
    print(' User UID: ${user.uid}');
    print(' User email: ${user.email}');
    print(' User display name: ${user.displayName}');
    
    // Use default cache behavior
    final doc = await _firestore.collection('users').doc(user.uid).get();
    
    if (doc.exists) {
      print(' User document found');
      print('Document data: ${doc.data()}');
      
      setState(() {
        _nameController.text = doc.data()?['name'] ?? user.displayName ?? '';
        _emailController.text = user.email ?? '';
        _phoneController.text = doc.data()?['phone'] ?? '';
        _addressController.text = doc.data()?['address'] ?? '';
        _selectedCity = doc.data()?['city'] ?? 'Addis Ababa';
      });
    } else {
      print(' User document does not exist, using defaults');
      setState(() {
        _nameController.text = user.displayName ?? 'User';
        _emailController.text = user.email ?? '';
        _phoneController.text = '';
        _addressController.text = '';
        _selectedCity = 'Addis Ababa';
      });
    }
  } catch (e) {
    print(' Error loading user data: $e');
    // Fallback to auth user data
    setState(() {
      _nameController.text = user.displayName ?? 'User';
      _emailController.text = user.email ?? '';
    });
  }
  
  setState(() => _isLoading = false);
  print('=== USER DATA LOADED ===');
}

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _profileImage = File(pickedFile.path));
        print('📸 Image selected: ${pickedFile.path}');
      }
    } catch (e) {
      print(' Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image')),
      );
    }
  }

  Future<void> _saveProfile() async {
    print('=== SAVE PROFILE STARTED ===');
    
    // Validate name
    if (_nameController.text.trim().isEmpty) {
      print(' Name is empty');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    print(' Name: ${_nameController.text}');
    print(' Phone: ${_phoneController.text}');
    print(' Address: ${_addressController.text}');
    print(' City: $_selectedCity');

    setState(() => _isSaving = true);

    try {
      final user = _auth.currentUser;
      
      if (user == null) {
        print(' ERROR: No user is logged in!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No user logged in'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isSaving = false);
        return;
      }

      print(' User UID: ${user.uid}');
      print(' User Email: ${user.email}');

      // 1. Update display name in Firebase Auth
      print(' Attempting to update display name...');
      try {
        await user.updateDisplayName(_nameController.text.trim());
        print(' Display name updated successfully');
      } catch (authError) {
        print(' Could not update display name: $authError');
        // Continue even if this fails
      }

      // 2. Prepare user data for Firestore
      final userData = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _selectedCity,
        'email': user.email,
        'uid': user.uid,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      print(' User data to save: $userData');

      // 3. Save to Firestore
      print(' Attempting to save to Firestore...');
      await _firestore.collection('users').doc(user.uid).set(
        userData,
        SetOptions(merge: true),
      );
      
      print('Firestore save successful');

      // 4. Show success message
      print(' Showing success message...');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Profile Updated!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Your profile has been saved successfully',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      print(' Waiting 1 second before navigating back...');
      await Future.delayed(Duration(seconds: 1));

      print(' Navigating back with success');
      Navigator.pop(context, true);

    } catch (e) {
      print(' ERROR SAVING PROFILE: $e');
      print(' Error type: ${e.runtimeType}');
      
      // Show detailed error
      String errorMessage = 'Failed to save profile';
      if (e is FirebaseException) {
        errorMessage = 'Firebase Error: ${e.code}\n${e.message ?? ''}';
      } else {
        errorMessage = 'Error: ${e.toString()}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Save Failed', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(
                errorMessage.length > 100 
                  ? '${errorMessage.substring(0, 100)}...' 
                  : errorMessage,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      
    } finally {
      print(' Setting _isSaving to false');
      if (mounted) {
        setState(() => _isSaving = false);
      }
      print('=== SAVE PROFILE COMPLETED ===');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isSaving)
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                print(' Save button pressed!');
                _saveProfile();
              },
              tooltip: 'Save Changes',
            ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Loading profile...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Image Section
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.green[100],
                                backgroundImage: _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : null,
                                child: _profileImage == null
                                    ? Icon(
                                        Icons.person, 
                                        size: 50, 
                                        color: Colors.green[700]
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green[700],
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Icon(Icons.camera_alt, size: 20, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Tap to change photo',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name *',
                      prefixIcon: Icon(Icons.person_outline, color: Colors.green[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Email Field (read-only)
                  TextFormField(
                    controller: _emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined, color: Colors.green[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Phone Field
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone_outlined, color: Colors.green[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Address Field
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.location_on_outlined, color: Colors.green[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  
                  SizedBox(height: 16),
                  
                  // City Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'City',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCity,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down, color: Colors.green[700]),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            items: _cities.map((city) {
                              return DropdownMenuItem(
                                value: city,
                                child: Text(city),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => _selectedCity = value);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : () {
                        print(' Save Changes button pressed!');
                        _saveProfile();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        shadowColor: Colors.green[700]!.withOpacity(0.3),
                      ),
                      child: _isSaving
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Saving...',
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
                                Icon(Icons.save, size: 22),
                                SizedBox(width: 12),
                                Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Cancel Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey[400]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Debug Info (optional - remove in production)
                  if (_auth.currentUser != null)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Debug Info:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'User ID: ${_auth.currentUser!.uid.substring(0, 8)}...',
                            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                          ),
                          Text(
                            'Email: ${_auth.currentUser!.email}',
                            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}











