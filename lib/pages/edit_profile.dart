// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'dart:io';

// // class EditProfilePage extends StatefulWidget {
// //   const EditProfilePage({super.key});

// //   @override
// //   State<EditProfilePage> createState() => _EditProfilePageState();
// // }

// // class _EditProfilePageState extends State<EditProfilePage> {
// //   final TextEditingController _nameController = TextEditingController();
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _phoneController = TextEditingController();
// //   final TextEditingController _addressController = TextEditingController();
  
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final ImagePicker _picker = ImagePicker();
  
// //   File? _profileImage;
// //   bool _isLoading = false;
// //   bool _isSaving = false;
// //   String? _selectedCity = 'Addis Ababa';
  
// //   final List<String> _cities = [
// //     'Addis Ababa',
// //     'Adama',
// //     'Bahir Dar',
// //     'Mekelle',
// //     'Dire Dawa',
// //     'Hawassa',
// //     'Jimma',
// //     'Gondar',
// //     'Debre Markos',
// //     'Other'
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadUserData();
// //   }

// //   Future<void> _loadUserData() async {
// //     setState(() => _isLoading = true);
// //     final user = _auth.currentUser;
// //     if (user != null) {
// //       final doc = await _firestore.collection('users').doc(user.uid).get();
// //       if (doc.exists) {
// //         setState(() {
// //           _nameController.text = doc.data()?['name'] ?? user.displayName ?? '';
// //           _emailController.text = user.email ?? '';
// //           _phoneController.text = doc.data()?['phone'] ?? '';
// //           _addressController.text = doc.data()?['address'] ?? '';
// //           _selectedCity = doc.data()?['city'] ?? 'Addis Ababa';
// //         });
// //       }
// //     }
// //     setState(() => _isLoading = false);
// //   }

// //   Future<void> _pickImage() async {
// //     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
// //     if (pickedFile != null) {
// //       setState(() => _profileImage = File(pickedFile.path));
// //     }
// //   }

// //   Future<void> _saveProfile() async {
// //     if (_nameController.text.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Please enter your name')),
// //       );
// //       return;
// //     }

// //     setState(() => _isSaving = true);
    
// //     try {
// //       final user = _auth.currentUser!;
      
// //       // Update display name in Firebase Auth
// //       await user.updateDisplayName(_nameController.text.trim());
      
// //       // Update user data in Firestore
// //       await _firestore.collection('users').doc(user.uid).update({
// //         'name': _nameController.text.trim(),
// //         'phone': _phoneController.text.trim(),
// //         'address': _addressController.text.trim(),
// //         'city': _selectedCity,
// //         'updatedAt': FieldValue.serverTimestamp(),
// //       });

// //       // Handle profile image upload (simplified for now)
// //       if (_profileImage != null) {
// //         // In a real app, you would upload to Firebase Storage here
// //         await _firestore.collection('users').doc(user.uid).update({
// //           'profileImageUrl': 'https://example.com/profile.jpg', // Placeholder
// //         });
// //       }

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Row(
// //             children: [
// //               Icon(Icons.check_circle, color: Colors.white, size: 20),
// //               SizedBox(width: 10),
// //               Text('Profile updated successfully!'),
// //             ],
// //           ),
// //           backgroundColor: Colors.green,
// //         ),
// //       );

// //       // Wait a bit then go back
// //       await Future.delayed(Duration(seconds: 1));
// //       Navigator.pop(context, true); // Return true to indicate update

// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Error updating profile: $e'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     } finally {
// //       setState(() => _isSaving = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         title: Text('Edit Profile'),
// //         backgroundColor: Colors.green[700],
// //         foregroundColor: Colors.white,
// //         actions: [
// //           _isSaving
// //               ? Padding(
// //                   padding: EdgeInsets.only(right: 16),
// //                   child: CircularProgressIndicator(color: Colors.white),
// //                 )
// //               : IconButton(
// //                   icon: Icon(Icons.check),
// //                   onPressed: _saveProfile,
// //                 ),
// //         ],
// //       ),
// //       body: _isLoading
// //           ? Center(child: CircularProgressIndicator())
// //           : SingleChildScrollView(
// //               padding: EdgeInsets.all(20),
// //               child: Column(
// //                 children: [
// //                   // Profile Image
// //                   GestureDetector(
// //                     onTap: _pickImage,
// //                     child: Stack(
// //                       children: [
// //                         CircleAvatar(
// //                           radius: 60,
// //                           backgroundColor: Colors.green[100],
// //                           backgroundImage: _profileImage != null
// //                               ? FileImage(_profileImage!)
// //                               : AssetImage("assets/profile.jpg") as ImageProvider,
// //                           child: _profileImage == null
// //                               ? Icon(Icons.person, size: 50, color: Colors.green[700])
// //                               : null,
// //                         ),
// //                         Positioned(
// //                           bottom: 0,
// //                           right: 0,
// //                           child: Container(
// //                             padding: EdgeInsets.all(8),
// //                             decoration: BoxDecoration(
// //                               color: Colors.green[700],
// //                               shape: BoxShape.circle,
// //                               boxShadow: [
// //                                 BoxShadow(
// //                                   color: Colors.black26,
// //                                   blurRadius: 4,
// //                                 ),
// //                               ],
// //                             ),
// //                             child: Icon(Icons.camera_alt, size: 20, color: Colors.white),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
                  
// //                   SizedBox(height: 30),
                  
// //                   // Name Field
// //                   _buildTextField(
// //                     label: 'Full Name',
// //                     hint: 'Enter your full name',
// //                     icon: Icons.person_outline,
// //                     controller: _nameController,
// //                   ),
                  
// //                   SizedBox(height: 16),
                  
// //                   // Email Field (read-only)
// //                   TextField(
// //                     controller: _emailController,
// //                     readOnly: true,
// //                     decoration: InputDecoration(
// //                       labelText: 'Email',
// //                       prefixIcon: Icon(Icons.email_outlined),
// //                       filled: true,
// //                       fillColor: Colors.grey[100],
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                   ),
                  
// //                   SizedBox(height: 16),
                  
// //                   // Phone Field
// //                   _buildTextField(
// //                     label: 'Phone Number',
// //                     hint: 'Enter phone number',
// //                     icon: Icons.phone_outlined,
// //                     controller: _phoneController,
// //                     keyboardType: TextInputType.phone,
// //                   ),
                  
// //                   SizedBox(height: 16),
                  
// //                   // Address Field
// //                   _buildTextField(
// //                     label: 'Address',
// //                     hint: 'Enter your address',
// //                     icon: Icons.location_on_outlined,
// //                     controller: _addressController,
// //                     maxLines: 2,
// //                   ),
                  
// //                   SizedBox(height: 16),
                  
// //                   // City Dropdown
// //                   Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         'City',
// //                         style: TextStyle(
// //                           fontSize: 14,
// //                           fontWeight: FontWeight.w500,
// //                           color: Colors.grey[700],
// //                         ),
// //                       ),
// //                       SizedBox(height: 8),
// //                       Container(
// //                         padding: EdgeInsets.symmetric(horizontal: 16),
// //                         decoration: BoxDecoration(
// //                           color: Colors.grey[50],
// //                           borderRadius: BorderRadius.circular(12),
// //                           border: Border.all(color: Colors.grey[300]!),
// //                         ),
// //                         child: DropdownButtonHideUnderline(
// //                           child: DropdownButton<String>(
// //                             value: _selectedCity,
// //                             isExpanded: true,
// //                             items: _cities.map((city) {
// //                               return DropdownMenuItem(
// //                                 value: city,
// //                                 child: Text(city),
// //                               );
// //                             }).toList(),
// //                             onChanged: (value) {
// //                               setState(() => _selectedCity = value);
// //                             },
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
                  
// //                   SizedBox(height: 30),
                  
// //                   // Save Button
// //                   SizedBox(
// //                     width: double.infinity,
// //                     height: 56,
// //                     child: ElevatedButton(
// //                       onPressed: _isSaving ? null : _saveProfile,
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.green[700],
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(15),
// //                         ),
// //                       ),
// //                       child: _isSaving
// //                           ? CircularProgressIndicator(color: Colors.white)
// //                           : Text(
// //                               'Save Changes',
// //                               style: TextStyle(
// //                                 fontSize: 16,
// //                                 fontWeight: FontWeight.w600,
// //                               ),
// //                             ),
// //                     ),
// //                   ),
                  
// //                   SizedBox(height: 20),
                  
// //                   // Cancel Button
// //                   TextButton(
// //                     onPressed: () => Navigator.pop(context),
// //                     child: Text('Cancel', style: TextStyle(fontSize: 16)),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //     );
// //   }

// //   Widget _buildTextField({
// //     required String label,
// //     required String hint,
// //     required IconData icon,
// //     required TextEditingController controller,
// //     TextInputType keyboardType = TextInputType.text,
// //     int maxLines = 1,
// //   }) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           label,
// //           style: TextStyle(
// //             fontSize: 14,
// //             fontWeight: FontWeight.w500,
// //             color: Colors.grey[700],
// //           ),
// //         ),
// //         SizedBox(height: 8),
// //         TextField(
// //           controller: controller,
// //           keyboardType: keyboardType,
// //           maxLines: maxLines,
// //           decoration: InputDecoration(
// //             hintText: hint,
// //             prefixIcon: Icon(icon),
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             enabledBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(12),
// //               borderSide: BorderSide(color: Colors.grey[300]!),
// //             ),
// //             focusedBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(12),
// //               borderSide: BorderSide(color: Colors.green[700]!, width: 2),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     _emailController.dispose();
// //     _phoneController.dispose();
// //     _addressController.dispose();
// //     super.dispose();
// //   }
// // }



// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key});

//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
  
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final ImagePicker _picker = ImagePicker();
  
//   File? _profileImage;
//   bool _isLoading = false;
//   bool _isSaving = false;
//   String? _selectedCity = 'Addis Ababa';
  
//   final List<String> _cities = [
//     'Addis Ababa',
//     'Adama',
//     'Bahir Dar',
//     'Mekelle',
//     'Dire Dawa',
//     'Hawassa',
//     'Jimma',
//     'Gondar',
//     'Debre Markos',
//     'Other'
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     setState(() => _isLoading = true);
//     final user = _auth.currentUser;
//     if (user != null) {
//       final doc = await _firestore.collection('users').doc(user.uid).get();
//       if (doc.exists) {
//         setState(() {
//           _nameController.text = doc.data()?['name'] ?? user.displayName ?? '';
//           _emailController.text = user.email ?? '';
//           _phoneController.text = doc.data()?['phone'] ?? '';
//           _addressController.text = doc.data()?['address'] ?? '';
//           _selectedCity = doc.data()?['city'] ?? 'Addis Ababa';
//         });
//       }
//     }
//     setState(() => _isLoading = false);
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() => _profileImage = File(pickedFile.path));
//     }
//   }

//   Future<void> _saveProfile() async {
//     if (_nameController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter your name')),
//       );
//       return;
//     }

//     setState(() => _isSaving = true);
    
//     try {
//       final user = _auth.currentUser!;
      
//       // Update display name in Firebase Auth
//       await user.updateDisplayName(_nameController.text.trim());
      
//       // Update user data in Firestore
//       Map<String, dynamic> updateData = {
//         'name': _nameController.text.trim(),
//         'phone': _phoneController.text.trim(),
//         'address': _addressController.text.trim(),
//         'city': _selectedCity,
//         'updatedAt': FieldValue.serverTimestamp(),
//       };

//       // Only add phone if it's not empty
//       if (_phoneController.text.trim().isNotEmpty) {
//         updateData['phone'] = _phoneController.text.trim();
//       }

//       // Only add address if it's not empty
//       if (_addressController.text.trim().isNotEmpty) {
//         updateData['address'] = _addressController.text.trim();
//       }

//       await _firestore.collection('users').doc(user.uid).update(updateData);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               Icon(Icons.check_circle, color: Colors.white, size: 20),
//               SizedBox(width: 10),
//               Text('Profile updated successfully!'),
//             ],
//           ),
//           backgroundColor: Colors.green,
//           duration: Duration(seconds: 2),
//         ),
//       );

//       // Wait a bit then go back
//       await Future.delayed(Duration(milliseconds: 500));
//       Navigator.pop(context, true);

//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error updating profile: ${e.toString()}'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     } finally {
//       setState(() => _isSaving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text('Edit Profile'),
//         backgroundColor: Colors.green[700],
//         foregroundColor: Colors.white,
//         actions: [
//           _isSaving
//               ? Padding(
//                   padding: EdgeInsets.only(right: 16),
//                   child: CircularProgressIndicator(color: Colors.white),
//                 )
//               : IconButton(
//                   icon: Icon(Icons.check),
//                   onPressed: _saveProfile,
//                 ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   // Profile Image
//                   GestureDetector(
//                     onTap: _pickImage,
//                     child: Stack(
//                       children: [
//                         CircleAvatar(
//                           radius: 60,
//                           backgroundColor: Colors.green[100],
//                           backgroundImage: _profileImage != null
//                               ? FileImage(_profileImage!)
//                               : null,
//                           child: _profileImage == null
//                               ? Icon(
//                                   Icons.person, 
//                                   size: 50, 
//                                   color: Colors.green[700]
//                                 )
//                               : null,
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           right: 0,
//                           child: Container(
//                             padding: EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.green[700],
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black26,
//                                   blurRadius: 4,
//                                 ),
//                               ],
//                             ),
//                             child: Icon(Icons.camera_alt, size: 20, color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
                  
//                   SizedBox(height: 30),
                  
//                   // Name Field
//                   _buildTextField(
//                     label: 'Full Name',
//                     hint: 'Enter your full name',
//                     icon: Icons.person_outline,
//                     controller: _nameController,
//                   ),
                  
//                   SizedBox(height: 16),
                  
//                   // Email Field (read-only)
//                   TextField(
//                     controller: _emailController,
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       prefixIcon: Icon(Icons.email_outlined),
//                       filled: true,
//                       fillColor: Colors.grey[100],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.grey[300]!),
//                       ),
//                     ),
//                   ),
                  
//                   SizedBox(height: 16),
                  
//                   // Phone Field
//                   _buildTextField(
//                     label: 'Phone Number',
//                     hint: 'Enter phone number',
//                     icon: Icons.phone_outlined,
//                     controller: _phoneController,
//                     keyboardType: TextInputType.phone,
//                     isOptional: true,
//                   ),
                  
//                   SizedBox(height: 16),
                  
//                   // Address Field
//                   _buildTextField(
//                     label: 'Address',
//                     hint: 'Enter your address',
//                     icon: Icons.location_on_outlined,
//                     controller: _addressController,
//                     maxLines: 2,
//                     isOptional: true,
//                   ),
                  
//                   SizedBox(height: 16),
                  
//                   // City Dropdown
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'City',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[50],
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey[300]!),
//                         ),
//                         child: DropdownButtonHideUnderline(
//                           child: DropdownButton<String>(
//                             value: _selectedCity,
//                             isExpanded: true,
//                             items: _cities.map((city) {
//                               return DropdownMenuItem(
//                                 value: city,
//                                 child: Text(city),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               setState(() => _selectedCity = value);
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
                  
//                   SizedBox(height: 30),
                  
//                   // Save Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton(
//                       onPressed: _isSaving ? null : _saveProfile,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green[700],
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                       child: _isSaving
//                           ? CircularProgressIndicator(color: Colors.white)
//                           : Text(
//                               'Save Changes',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                     ),
//                   ),
                  
//                   SizedBox(height: 20),
                  
//                   // Cancel Button
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text(
//                       'Cancel', 
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildTextField({
//     required String label,
//     required String hint,
//     required IconData icon,
//     required TextEditingController controller,
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//     bool isOptional = false,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey[700],
//               ),
//             ),
//             if (isOptional)
//               Text(
//                 ' (Optional)',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[500],
//                 ),
//               ),
//           ],
//         ),
//         SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           keyboardType: keyboardType,
//           maxLines: maxLines,
//           decoration: InputDecoration(
//             hintText: hint,
//             prefixIcon: Icon(icon),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.green[700]!, width: 2),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }
// }



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/language_service.dart';

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
  bool _isLoading = false;
  bool _isSaving = false;
  String? _selectedCity = 'Addis Ababa';
  
  List<String> _cities = [
    'Addis Ababa',
    'Adama',
    'Bahir Dar',
    'Mekelle',
    'Dire Dawa',
    'Hawassa',
    'Jimma',
    'Gondar',
    'Debre Markos',
    'Other' // Default, will be updated based on language
  ];

  @override
  void initState() {
    super.initState();
    _updateCitiesList(); // Initialize cities list with current language
    _loadUserData();
    LanguageService.languageNotifier.addListener(_onLanguageChanged);
  }

  void _onLanguageChanged() {
    setState(() {
      _updateCitiesList();
    });
  }

  void _updateCitiesList() {
    // Update the "Other" option based on current language
    _cities = [
      'Addis Ababa',
      'Adama',
      'Bahir Dar',
      'Mekelle',
      'Dire Dawa',
      'Hawassa',
      'Jimma',
      'Gondar',
      'Debre Markos',
      LanguageService.t('other')
    ];
    
    // If the currently selected city is "Other" in any language,
    // update it to the new language version
    if (_selectedCity == 'Other' || _selectedCity == 'ሌላ') {
      _selectedCity = LanguageService.t('other');
    }
  }

  @override
  void dispose() {
    LanguageService.languageNotifier.removeListener(_onLanguageChanged);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          _nameController.text = doc.data()?['name'] ?? user.displayName ?? '';
          _emailController.text = user.email ?? '';
          _phoneController.text = doc.data()?['phone'] ?? '';
          _addressController.text = doc.data()?['address'] ?? '';
          _selectedCity = doc.data()?['city'] ?? 'Addis Ababa';
        });
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LanguageService.t('enterName'))),
      );
      return;
    }

    setState(() => _isSaving = true);
    
    try {
      final user = _auth.currentUser!;
      
      // Update display name in Firebase Auth
      await user.updateDisplayName(_nameController.text.trim());
      
      // Update user data in Firestore
      Map<String, dynamic> updateData = {
        'name': _nameController.text.trim(),
        'city': _selectedCity,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Only add phone if it's not empty
      if (_phoneController.text.trim().isNotEmpty) {
        updateData['phone'] = _phoneController.text.trim();
      }

      // Only add address if it's not empty
      if (_addressController.text.trim().isNotEmpty) {
        updateData['address'] = _addressController.text.trim();
      }

      await _firestore.collection('users').doc(user.uid).update(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text(LanguageService.t('profileUpdated')),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Wait a bit then go back
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.pop(context, true);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${LanguageService.t('errorUpdating')}: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(LanguageService.t('editProfile')),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          _isSaving
              ? Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : IconButton(
                  icon: Icon(Icons.check),
                  onPressed: _saveProfile,
                ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Image
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.green[100],
                          child: _profileImage != null
                              ? ClipOval(
                                  child: Image.file(
                                    _profileImage!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.person, 
                                  size: 50, 
                                  color: Colors.green[700]
                                ),
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
                  
                  SizedBox(height: 30),
                  
                  // Name Field
                  _buildTextField(
                    label: LanguageService.t('fullName'),
                    hint: 'Enter your full name',
                    icon: Icons.person_outline,
                    controller: _nameController,
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Email Field (read-only)
                  TextField(
                    controller: _emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Phone Field
                  _buildTextField(
                    label: LanguageService.t('phoneNumber'),
                    hint: 'Enter phone number',
                    icon: Icons.phone_outlined,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    isOptional: true,
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Address Field
                  _buildTextField(
                    label: LanguageService.t('address'),
                    hint: 'Enter your address',
                    icon: Icons.location_on_outlined,
                    controller: _addressController,
                    maxLines: 2,
                    isOptional: true,
                  ),
                  
                  SizedBox(height: 16),
                  
                  // City Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LanguageService.t('city'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCity,
                            isExpanded: true,
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
                      onPressed: _isSaving ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: _isSaving
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              LanguageService.t('saveChanges'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Cancel Button
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      LanguageService.t('cancel'), 
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isOptional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            if (isOptional)
              Text(
                ' (${LanguageService.t('optional')})',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green[700]!, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}