

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/user_service.dart';
import '../components/editProfile.dart';
import 'HomePage.dart';
import 'signup.dart'; 

class RecycleLoginPage extends StatefulWidget {
  const RecycleLoginPage({super.key});

  @override
  State<RecycleLoginPage> createState() => _RecycleLoginPageState();
}

class _RecycleLoginPageState extends State<RecycleLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: "1050799114152-lhjk3rv77sjppuc4nhrqe0pahqhknira.apps.googleusercontent.com",
    scopes: ['email'],
  );

  @override
  void initState() {
    super.initState();
    // Check if user is already logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCurrentUser();
    });
  }

  void _checkCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      // User is already logged in, navigate to home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RecycleXHome()),
      );
    }
  }


  void _login() async {
  if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
    setState(() => _isLoading = true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      if (!mounted) return;
      
      // Check if user needs to complete profile
      final user = _auth.currentUser;
      if (user != null) {
        final needsProfile = await UserService.needsProfileCompletion(user.uid);
        
        if (needsProfile) {
          // Navigate to profile completion
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfilePage(
                isFirstTime: false,
                userEmail: user.email ?? '',
              ),
            ),
          );
        } else {
          // Go directly to home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RecycleXHome()),
          );
        }
      }
      
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = e.message ?? 'Login failed';
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter email and password')),
    );
  }
}

// Also update Google Sign-In:
Future<void> _signInWithGoogle() async {
  setState(() => _isLoading = true);
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    
    if (!mounted) return;
    
    // Initialize Google user in Firestore
    if (userCredential.user != null) {
      await UserService.initializeNewUser(userCredential.user!);
      
      // Check if needs profile completion
      final needsProfile = await UserService.needsProfileCompletion(userCredential.user!.uid);
      
      if (needsProfile) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfilePage(
              isFirstTime: true,
              userEmail: userCredential.user!.email ?? '',
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RecycleXHome()),
        );
      }
    }
    
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In failed: ${e.toString()}")),
      );
      setState(() => _isLoading = false);
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // APP TITLE
                Text(
                  "RecycleX",
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Recycle for a better planet ",
                  style: TextStyle(
                    color: Colors.green[400],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),

                // LOGIN FORM
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Email address",
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          hintText: "Password",
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey[600],
                            ),
                            onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Log In", style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      TextButton(
                        onPressed: _isLoading ? null : () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.green[700]),
                        ),
                      ),
                      const Divider(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _signInWithGoogle,
                          icon: Image.network(
                            'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
                            height: 24,
                          ),
                          label: const Text("Continue with Google"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () {
                            // Navigate to signup page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Create New Account", style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}










