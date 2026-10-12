import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Schedule pickup page — migrated from lib/pages/schedule_page.dart.
/// No functional changes; only import paths updated.
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

  final TextEditingController locationController = TextEditingController();

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  void submitSchedule() {
    if (selectedDate == null ||
        selectedTime == null ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pickup Scheduled Successfully ✅')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Schedule Pickup'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Schedule Waste Collection',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Waste Type
            DropdownButtonFormField<String>(
              initialValue: selectedWaste,
              dropdownColor: AppColors.surface,
              decoration: _inputStyle('Waste Type'),
              items: ['Plastic', 'Organic', 'Paper', 'Metal']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) =>
                  setState(() => selectedWaste = value!),
            ),
            const SizedBox(height: 15),

            // Collector
            DropdownButtonFormField<String>(
              initialValue: selectedCollector,
              dropdownColor: AppColors.surface,
              decoration: _inputStyle('Collector'),
              items: [
                'Nearest Collector',
                'Kebele Collector',
                'Private Recycler',
              ]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) =>
                  setState(() => selectedCollector = value!),
            ),
            const SizedBox(height: 15),

            // Location
            TextField(
              controller: locationController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: _inputStyle('Pickup Location'),
            ),
            const SizedBox(height: 15),

            // Date
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                selectedDate == null
                    ? 'Select Date'
                    : selectedDate!.toLocal().toString().split(' ')[0],
              ),
              onPressed: pickDate,
              style: _buttonStyle(),
            ),
            const SizedBox(height: 10),

            // Time
            ElevatedButton.icon(
              icon: const Icon(Icons.access_time),
              label: Text(
                selectedTime == null
                    ? 'Select Time'
                    : selectedTime!.format(context),
              ),
              onPressed: pickTime,
              style: _buttonStyle(),
            ),
            const SizedBox(height: 25),

            // Submit
            ElevatedButton(
              onPressed: submitSchedule,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Schedule Pickup',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
    );
  }
}
