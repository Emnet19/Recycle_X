import 'package:flutter/material.dart';

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

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => selectedTime = picked);
    }
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
      const SnackBar(content: Text('Pickup Scheduled Successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), 
      appBar: AppBar(
        title: const Text('Schedule Pickup'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Schedule Waste Collection',
              style: TextStyle(
                color: Color.fromARGB(255, 14, 14, 14), // Gold
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            /// Waste Type
            DropdownButtonFormField<String>(
              value: selectedWaste,
              dropdownColor: const Color.fromARGB(255, 151, 153, 152),
              decoration: inputStyle('Waste Type'),
              items: ['Plastic', 'Organic', 'Paper', 'Metal']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => setState(() => selectedWaste = value!),
            ),
            const SizedBox(height: 15),

            /// Collector
            DropdownButtonFormField<String>(
              value: selectedCollector,
              dropdownColor: const Color.fromARGB(255, 161, 162, 161),
              decoration: inputStyle('Collector'),
              items: [
                'Nearest Collector',
                'Kebele Collector',
                'Private Recycler'
              ]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) =>
                  setState(() => selectedCollector = value!),
            ),
            const SizedBox(height: 15),

            /// Location
            TextField(
              controller: locationController,
              style: const TextStyle(color: Colors.white),
              decoration: inputStyle('Pickup Location'),
            ),
            const SizedBox(height: 15),

            /// Date
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                selectedDate == null
                    ? 'Select Date'
                    : selectedDate!.toLocal().toString().split(' ')[0],
              ),
              onPressed: pickDate,
              style: buttonStyle(),
            ),
            const SizedBox(height: 10),

            /// Time
            ElevatedButton.icon(
              icon: const Icon(Icons.access_time),
              label: Text(
                selectedTime == null
                    ? 'Select Time'
                    : selectedTime!.format(context),
              ),
              onPressed: pickTime,
              style: buttonStyle(),
            ),
            const SizedBox(height: 25),

            /// Submit
            ElevatedButton(
              onPressed: submitSchedule,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 55, 212, 120),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Schedule Pickup',
                style: TextStyle(
                  color: Colors.black,
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

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF2C3E34),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2C3E34),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
    );
  }
}
