// import 'package:flutter/material.dart';

// class EmergencyPickupPage extends StatelessWidget {
//   const EmergencyPickupPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.red[50],
//       appBar: AppBar(
//         title: Text('Emergency Pickup'),
//         backgroundColor: Colors.red,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.emergency,
//               size: 80,
//               color: Colors.red,
//             ),
//             SizedBox(height: 24),
//             Text(
//               'URGENT PICKUP REQUEST',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red,
//               ),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Use this feature only for emergency waste situations. '
//               'A collector will be dispatched immediately with priority service.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 32),
            
//             // Emergency Details
//             Card(
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     ListTile(
//                       leading: Icon(Icons.warning, color: Colors.orange),
//                       title: Text('Priority Service'),
//                       subtitle: Text('Collector within 30 minutes'),
//                     ),
//                     ListTile(
//                       leading: Icon(Icons.attach_money, color: Colors.orange),
//                       title: Text('Double EcoCoins'),
//                       subtitle: Text('250 EcoCoins will be charged'),
//                     ),
//                     ListTile(
//                       leading: Icon(Icons.support_agent, color: Colors.orange),
//                       title: Text('24/7 Support'),
//                       subtitle: Text('Immediate customer support'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 32),
            
//             // Emergency Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   _showConfirmationDialog(context);
//                 },
//                 icon: Icon(Icons.emergency),
//                 label: Text('REQUEST EMERGENCY PICKUP'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   padding: EdgeInsets.symmetric(vertical: 18),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Confirm Emergency Request'),
//         content: Text(
//           'Are you sure you want to request an emergency pickup? '
//           'This will cost 250 EcoCoins and a collector will be dispatched immediately.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context); // Close dialog
//               Navigator.pop(context); // Go back to home
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Emergency pickup requested!'),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: Text('Confirm'),
//           ),
//         ],
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';

class EmergencyPickupPage extends StatefulWidget {
  const EmergencyPickupPage({Key? key}) : super(key: key);

  @override
  State<EmergencyPickupPage> createState() => _EmergencyPickupPageState();
}

class _EmergencyPickupPageState extends State<EmergencyPickupPage> {
  final TextEditingController _reasonController = TextEditingController();
  String? _selectedWasteType;
  bool _isConfirming = false;

  final List<String> _wasteTypes = [
    'Medical Waste',
    'Chemical Spill',
    'Animal Waste',
    'Food Spoilage',
    'Construction Debris',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: Text('Emergency Pickup'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emergency,
                size: 80,
                color: Colors.red,
              ),
              SizedBox(height: 16),
              Text(
                'URGENT PICKUP REQUEST',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Use this feature only for emergency waste situations. '
                'A collector will be dispatched within 30 minutes.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 24),

              // Emergency Form
              Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Waste Type Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedWasteType,
                        decoration: InputDecoration(
                          labelText: 'Type of Emergency Waste',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.warning),
                        ),
                        items: _wasteTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedWasteType = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select waste type';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Reason Text Field
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Emergency Reason (Required)',
                          hintText: 'Explain why this is an emergency...',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide a reason';
                          }
                          if (value.length < 10) {
                            return 'Please provide more details (min 10 chars)';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Note: Emergency pickup costs 50 EcoCoins',
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Emergency Details
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.access_time, color: Colors.red),
                        title: Text('30-Minute Response'),
                        subtitle: Text('Collector will arrive within 30 mins'),
                      ),
                      ListTile(
                        leading: Icon(Icons.attach_money, color: Colors.green),
                        title: Text('Cost: 50 EcoCoins'),
                        subtitle: Text('Will be deducted from your wallet'),
                      ),
                      ListTile(
                        leading: Icon(Icons.support_agent, color: Colors.blue),
                        title: Text('Priority Support'),
                        subtitle: Text('Dedicated customer service'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Emergency Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isFormValid() ? () {
                    _showConfirmationDialog(context);
                  } : null,
                  icon: Icon(Icons.emergency),
                  label: Text(
                    _isConfirming ? 'PROCESSING...' : 'REQUEST EMERGENCY PICKUP',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    disabledBackgroundColor: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    return _selectedWasteType != null && 
           _selectedWasteType!.isNotEmpty && 
           _reasonController.text.isNotEmpty &&
           _reasonController.text.length >= 10 &&
           !_isConfirming;
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 10),
            Text('Confirm Emergency Request'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please confirm your emergency pickup details:'),
              SizedBox(height: 16),
              Text('• Waste Type: $_selectedWasteType'),
              SizedBox(height: 8),
              Text('• Reason: ${_reasonController.text}'),
              SizedBox(height: 8),
              Text('• Cost: 50 EcoCoins'),
              SizedBox(height: 16),
              Text(
                'A collector will be dispatched within 30 minutes. '
                '50 EcoCoins will be deducted from your wallet.',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await _processEmergencyRequest(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Confirm & Pay 50 Coins'),
          ),
        ],
      ),
    );
  }

  Future<void> _processEmergencyRequest(BuildContext context) async {
    setState(() {
      _isConfirming = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Emergency Pickup Confirmed!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '50 EcoCoins deducted. Collector arriving soon.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate back to home after success
    await Future.delayed(Duration(seconds: 2));
    
    if (mounted) {
      Navigator.pop(context); // Go back to home
      setState(() {
        _isConfirming = false;
      });
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}