import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  void _showConfirmationDialog() {
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

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.schedule, color: Color(0xFF2C3E34), size: 28),
            SizedBox(width: 10),
            Text(
              'Confirm Schedule',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E34),
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
                'Please review your pickup details:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),
              
              // Details Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF2C3E34).withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      icon: Icons.recycling,
                      label: 'Waste Type',
                      value: selectedWaste,
                      iconColor: Colors.blue,
                    ),
                    SizedBox(height: 12),
                    _buildDetailRow(
                      icon: Icons.people,
                      label: 'Collector',
                      value: selectedCollector,
                      iconColor: Colors.green,
                    ),
                    SizedBox(height: 12),
                    _buildDetailRow(
                      icon: Icons.location_on,
                      label: 'Location',
                      value: locationController.text,
                      iconColor: Colors.red,
                    ),
                    SizedBox(height: 12),
                    _buildDetailRow(
                      icon: Icons.calendar_today,
                      label: 'Date',
                      value: _formatDate(selectedDate!),
                      iconColor: Colors.purple,
                    ),
                    SizedBox(height: 12),
                    _buildDetailRow(
                      icon: Icons.access_time,
                      label: 'Time',
                      value: selectedTime!.format(context),
                      iconColor: Colors.orange,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              // Note
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange, size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'You can cancel or reschedule up to 2 hours before pickup',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _submitSchedule(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2C3E34),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Confirm & Schedule',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E34),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submitSchedule(BuildContext context) async {
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

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Schedule Confirmed!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Your pickup is scheduled for ${_formatDate(selectedDate!)} at ${selectedTime!.format(context)}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 4),
        ),
      );

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
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text('Error: ${e.toString()}'),
              ),
            ],
          ),
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
            SizedBox(height: 10),

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
                        onPressed: _isSubmitting ? null : _showConfirmationDialog,
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
                     

                    )// SizedBox(height: 40),
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










