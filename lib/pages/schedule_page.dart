// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../services/notification_service.dart';
// import 'schedule_confirmation.dart';
// import '../services/location_service.dart';
// import 'map.dart';

// class SchedulePickupPage extends StatefulWidget {
//   const SchedulePickupPage({super.key});

//   @override
//   State<SchedulePickupPage> createState() => _SchedulePickupPageState();
// }

// class _SchedulePickupPageState extends State<SchedulePickupPage> {
//   String selectedWaste = 'Plastic';
//   String selectedCollector = 'Nearest Collector';
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;

//   final TextEditingController locationController = TextEditingController();

//   Future<void> pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now().add(const Duration(days: 1)),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 30)),
//     );

//     if (picked != null) {
//       setState(() => selectedDate = picked);
//     }
//   }

//   Future<void> pickTime() async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (picked != null) {
//       setState(() => selectedTime = picked);
//     }
//   }
// Future<void> submitSchedule(BuildContext context) async {
//   try {
//     final position = await LocationService.getCurrentLocation();

//     await FirebaseFirestore.instance
//         .collection('pickup_requests')
//         .add({
//       'wasteType': selectedWaste,
//       'collectorType': selectedCollector,
//       'locationText': locationController.text,
//       'latitude': position.latitude,
//       'longitude': position.longitude,
//       'pickupDate': selectedDate!.toIso8601String(),
//       'pickupTime': selectedTime!.format(context),
//       'createdAt': Timestamp.now(),
//     });

//       await NotificationService.showNotification(
//   title: 'Pickup Scheduled',
//   body: 'Your waste pickup has been scheduled successfully.',
// );

//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //     builder: (_) => MapPage(
//     //       userLocation: LatLng(
//     //         position.latitude,
//     //         position.longitude,
//     //       ),
//     //     ),
//     //   ),
//     // );
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ScheduleConfirmationPage(
//           wasteType: selectedWaste,
//           pickupDate:
//               selectedDate!.toLocal().toString().split(' ')[0],
//           pickupTime: selectedTime!.format(context),
//           location: locationController.text,
//         ),
//       ),
//     );

//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(e.toString())),
//     );
//   }
// }

//   // void submitSchedule() {
//   //   if (selectedDate == null ||
//   //       selectedTime == null ||
//   //       locationController.text.isEmpty) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text('Please complete all fields')),
//   //     );
//   //     return;
//   //   }

//   //   ScaffoldMessenger.of(context).showSnackBar(
//   //     const SnackBar(content: Text('Pickup Scheduled Successfully')),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 255, 255, 255), 
//       appBar: AppBar(
//         title: const Text('Schedule Pickup'),
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         foregroundColor: const Color.fromARGB(255, 0, 0, 0),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             const Text(
//               'Schedule Waste Collection',
//               style: TextStyle(
//                 color: Color.fromARGB(255, 14, 14, 14), // Gold
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),

//             /// Waste Type
//             DropdownButtonFormField<String>(
//               value: selectedWaste,
//               dropdownColor: const Color.fromARGB(255, 151, 153, 152),
//               decoration: inputStyle('Waste Type'),
//               items: ['Plastic', 'Organic', 'Paper', 'Metal']
//                   .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                   .toList(),
//               onChanged: (value) => setState(() => selectedWaste = value!),
//             ),
//             const SizedBox(height: 15),

//             /// Collector
//             DropdownButtonFormField<String>(
//               value: selectedCollector,
//               dropdownColor: const Color.fromARGB(255, 161, 162, 161),
//               decoration: inputStyle('Collector'),
//               items: [
//                 'Nearest Collector',
//                 'Kebele Collector',
//                 'Private Recycler'
//               ]
//                   .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                   .toList(),
//               onChanged: (value) =>
//                   setState(() => selectedCollector = value!),
//             ),
//             const SizedBox(height: 15),

//             /// Location
//             TextField(
//               controller: locationController,
//               style: const TextStyle(color: Colors.white),
//               decoration: inputStyle('Pickup Location'),
//             ),
//             const SizedBox(height: 15),

//             /// Date
//             ElevatedButton.icon(
//               icon: const Icon(Icons.calendar_today),
//               label: Text(
//                 selectedDate == null
//                     ? 'Select Date'
//                     : selectedDate!.toLocal().toString().split(' ')[0],
//               ),
//               onPressed: pickDate,
//               style: buttonStyle(),
//             ),
//             const SizedBox(height: 10),

//             /// Time
//             ElevatedButton.icon(
//               icon: const Icon(Icons.access_time),
//               label: Text(
//                 selectedTime == null
//                     ? 'Select Time'
//                     : selectedTime!.format(context),
//               ),
//               onPressed: pickTime,
//               style: buttonStyle(),
//             ),
//             const SizedBox(height: 25),

//             /// Submit
//             ElevatedButton(
//                onPressed: () => submitSchedule(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 55, 212, 120),
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//               ),
//               child: const Text(
//                 'Schedule Pickup',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
            
//           ],
//         ),
//       ),
//     );
//   }

//   InputDecoration inputStyle(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.white70),
//       filled: true,
//       fillColor: const Color(0xFF2C3E34),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//     );
//   }

//   ButtonStyle buttonStyle() {
//     return ElevatedButton.styleFrom(
//       backgroundColor: const Color(0xFF2C3E34),
//       foregroundColor: Colors.white,
//       padding: const EdgeInsets.symmetric(vertical: 12),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/notification_service.dart';
import 'schedule_confirmation.dart';
import '../services/location_service.dart';

class SchedulePickupPage extends StatefulWidget {
  const SchedulePickupPage({super.key});

  @override
  State<SchedulePickupPage> createState() => _SchedulePickupPageState();
}

class _SchedulePickupPageState extends State<SchedulePickupPage> {
  String selectedWaste = 'Plastic';
  String selectedCollector = 'Nearest Collector';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool _isSubmitting = false;

  final TextEditingController locationController = TextEditingController();
  final FocusNode _locationFocusNode = FocusNode();

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF2C3E34),
            colorScheme: ColorScheme.light(primary: Color(0xFF2C3E34)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF2C3E34),
            colorScheme: ColorScheme.light(primary: Color(0xFF2C3E34)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  Future<void> submitSchedule(BuildContext context) async {
    if (selectedDate == null ||
        selectedTime == null ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please complete all fields'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final position = await LocationService.getCurrentLocation();

      await FirebaseFirestore.instance.collection('pickup_requests').add({
        'wasteType': selectedWaste,
        'collectorType': selectedCollector,
        'locationText': locationController.text,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'pickupDate': selectedDate!.toIso8601String(),
        'pickupTime': selectedTime!.format(context),
        'createdAt': Timestamp.now(),
        'status': 'pending',
      });

      await NotificationService.showNotification(
        title: 'Pickup Scheduled',
        body: 'Your waste pickup has been scheduled successfully.',
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ScheduleConfirmationPage(
            wasteType: selectedWaste,
            pickupDate: selectedDate!.toLocal().toString().split(' ')[0],
            pickupTime: selectedTime!.format(context),
            location: locationController.text,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(
          'Schedule Pickup',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E34),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF2C3E34)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header with illustration
             SizedBox(height: 10,),

            Container(
              height: 125,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 73, 71, 71).withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 20,
                    top: 20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color(0xFFE8F5E9).withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      // child: Icon(
                      //   Icons.recycling,
                      //   size: 40,
                      //   color: Color(0xFF4CAF50),
                      // ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Schedule Waste Collection',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Fill in the details below to schedule a pickup',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),

            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    // Waste Type Card
                    _buildFormCard(
                      icon: Icons.recycling,
                      title: 'Waste Type',
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFE0E0E0),
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedWaste,
                            icon: Icon(Icons.arrow_drop_down_rounded,
                                color: Color(0xFF2C3E34)),
                            iconSize: 30,
                            isExpanded: true,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF2C3E34),
                              fontWeight: FontWeight.w500,
                            ),
                            dropdownColor: Colors.white,
                            items: [
                              'Plastic',
                              'Organic',
                              'Paper',
                              'Metal',
                              'Glass',
                              'Electronics',
                              'Mixed'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  children: [
                                    _getWasteIcon(value),
                                    SizedBox(width: 12),
                                    Text(value),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => selectedWaste = value!);
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Collector Type Card
                    _buildFormCard(
                      icon: Icons.people,
                      title: 'Collector Type',
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFE0E0E0),
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedCollector,
                            icon: Icon(Icons.arrow_drop_down_rounded,
                                color: Color(0xFF2C3E34)),
                            iconSize: 30,
                            isExpanded: true,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF2C3E34),
                              fontWeight: FontWeight.w500,
                            ),
                            dropdownColor: Colors.white,
                            items: [
                              'Nearest Collector',
                              'Kebele Collector',
                              'Private Recycler',
                              'Community Center'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  children: [
                                    _getCollectorIcon(value),
                                    SizedBox(width: 12),
                                    Text(value),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => selectedCollector = value!);
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Location Card
                    _buildFormCard(
                      icon: Icons.location_on,
                      title: 'Pickup Location',
                      child: TextField(
                        controller: locationController,
                        focusNode: _locationFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Enter your address or location',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.my_location,
                                color: Color(0xFF2C3E34)),
                            onPressed: () async {
                              try {
                                final position =
                                    await LocationService.getCurrentLocation();
                                locationController.text =
                                    '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Could not get current location'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2C3E34),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Date and Time Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildFormCard(
                            icon: Icons.calendar_today,
                            title: 'Pickup Date',
                            child: GestureDetector(
                              onTap: pickDate,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Color(0xFFE0E0E0),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_today,
                                        color: Color(0xFF2C3E34), size: 20),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        selectedDate == null
                                            ? 'Select Date'
                                            : _formatDate(selectedDate!),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: selectedDate == null
                                              ? Colors.grey
                                              : Color(0xFF2C3E34),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: _buildFormCard(
                            icon: Icons.access_time,
                            title: 'Pickup Time',
                            child: GestureDetector(
                              onTap: pickTime,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Color(0xFFE0E0E0),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.access_time,
                                        color: Color(0xFF2C3E34), size: 20),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        selectedTime == null
                                            ? 'Select Time'
                                            : selectedTime!.format(context),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: selectedTime == null
                                              ? Colors.grey
                                              : Color(0xFF2C3E34),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),

                    // Summary Card
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E34),
                            ),
                          ),
                          SizedBox(height: 15),
                          _buildSummaryRow('Waste Type', selectedWaste),
                          _buildSummaryRow('Collector', selectedCollector),
                          _buildSummaryRow(
                            'Date',
                            selectedDate == null
                                ? 'Not selected'
                                : _formatDate(selectedDate!),
                          ),
                          _buildSummaryRow(
                            'Time',
                            selectedTime == null
                                ? 'Not selected'
                                : selectedTime!.format(context),
                          ),
                          if (locationController.text.isNotEmpty)
                            _buildSummaryRow(
                              'Location',
                              locationController.text,
                              maxLines: 2,
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),

                    // Submit Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => submitSchedule(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2C3E34),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                          shadowColor: Color(0xFF2C3E34).withOpacity(0.3),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isSubmitting
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.schedule, size: 22),
                                  SizedBox(width: 10),
                                  Text(
                                    'Schedule Pickup',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Info Note
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xFFFF9800).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Color(0xFFFF9800), size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Collectors usually arrive within 30 minutes of the scheduled time',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
    );
  }

  Widget _buildFormCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(0xFF2C3E34).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: Color(0xFF2C3E34)),
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E34),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF2C3E34),
                fontWeight: FontWeight.w600,
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _getWasteIcon(String wasteType) {
    switch (wasteType) {
      case 'Plastic':
        return Icon(Icons.local_drink, color: Color(0xFF2196F3));
      case 'Organic':
        return Icon(Icons.eco, color: Color(0xFF4CAF50));
      case 'Paper':
        return Icon(Icons.description, color: Color(0xFFFF9800));
      case 'Metal':
        return Icon(Icons.build, color: Color(0xFF9E9E9E));
      case 'Glass':
        return Icon(Icons.wine_bar, color: Color(0xFF00BCD4));
      case 'Electronics':
        return Icon(Icons.devices, color: Color(0xFF673AB7));
      default:
        return Icon(Icons.recycling, color: Color(0xFF2C3E34));
    }
  }

  Widget _getCollectorIcon(String collectorType) {
    switch (collectorType) {
      case 'Nearest Collector':
        return Icon(Icons.location_on, color: Color(0xFF2196F3));
      case 'Kebele Collector':
        return Icon(Icons.account_balance, color: Color(0xFF4CAF50));
      case 'Private Recycler':
        return Icon(Icons.business, color: Color(0xFFFF9800));
      case 'Community Center':
        return Icon(Icons.people, color: Color(0xFF9C27B0));
      default:
        return Icon(Icons.person, color: Color(0xFF2C3E34));
    }
  }
}