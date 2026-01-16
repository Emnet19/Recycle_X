
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/profile.dart';
import '../components/splashScreen.dart';
import 'pages/schedule_page.dart';
import 'components/HomePage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RecycleX',
      theme: ThemeData(
        primaryColor: Color(0xFF2C3E34),
      ),
      home: ErrorBoundary(
        child: RecycleX(),
      ),
    );
  }
}

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  
  const ErrorBoundary({Key? key, required this.child}) : super(key: key);
  
  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool hasError = false;
  String errorMessage = '';
  
  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 50, color: Colors.red),
              SizedBox(height: 20),
              Text('Error: $errorMessage'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    hasError = false;
                    errorMessage = '';
                  });
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    
    return widget.child;
  }
}


class RecycleX extends StatelessWidget {
  const RecycleX({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
    
     Splashscreen(),
      
    );
  }
}
