// import 'package:flutter/material.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {

//   bool isAmharic = false;

//   // Text helper
//   String t(String en, String am) {
//     return isAmharic ? am : en;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [

//               // Language Switch
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     isAmharic ? "አማ" : "EN",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Switch(
//                     activeColor: const Color(0xFF3A4A41),
//                     value: isAmharic,
//                     onChanged: (value) {
//                       setState(() {
//                         isAmharic = value;
//                       });
//                     },
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 20),

//               // Logo
//               Center(
//                 child: Column(
//                   children: [
//                     const Icon(
//                       Icons.eco,
//                       size: 70,
//                       color: Color(0xFF3A4A41),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       "RecycleX",
//                       style: const TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF3A4A41),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       t(
//                         "Turning Waste into Value",
//                         "ቆሻሻን ወደ ዋጋ መቀየር",
//                       ),
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Color(0xFF6B7B6F),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 40),

//               // Phone
//               TextField(
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   labelText: t("Phone Number", "ስልክ ቁጥር"),
//                   prefixIcon: const Icon(Icons.phone),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // Password
//               TextField(
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: t("Password", "የይለፍ ቃል"),
//                   prefixIcon: const Icon(Icons.lock),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // Login Button
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF3A4A41),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 child: Text(
//                   t("Login", "ግባ"),
//                   style: const TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // Guest
//               TextButton(
//                 onPressed: () {},
//                 child: Text(
//                   t("Continue without login", "ያለ መግባት ቀጥል"),
//                   style: const TextStyle(
//                     color: Color(0xFF3A4A41),
//                     fontSize: 16,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Register
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(t("Don’t have an account? ", "መለያ የለዎትም? ")),
//                   GestureDetector(
//                     onTap: () {},
//                     child: Text(
//                       t("Register", "ይመዝገቡ"),
//                       style: const TextStyle(
//                         color: Color(0xFF3A4A41),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'HomePage.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   bool isLogin = true;
//   bool isAmharic = false;

//   String t(String en, String am) => isAmharic ? am : en;

//   Future<void> authenticate() async {
//     try {
//       if (isLogin) {
//         await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: emailController.text,
//           password: passwordController.text,
//         );
//       } else {
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: emailController.text,
//           password: passwordController.text,
//         );
//       }

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomePage()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor:  Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 24),

//             // Language Switch
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text(isAmharic ? "አማ" : "EN"),
//                 Switch(
//                   value: isAmharic,
//                   onChanged: (v) => setState(() => isAmharic = v),
//                 )
//               ],
//             ),
//             const SizedBox(height: 94),

//             const Icon(Icons.eco, size: 80, color: Color(0xFF3A4A41)),
//             const SizedBox(height: 20),

//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 labelText: t("Email", "ኢሜይል"),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: t("Password", "የይለፍ ቃል"),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             ElevatedButton(
//               onPressed: authenticate,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 146, 228, 182),
//                 padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 80),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               child: Text(
//                 isLogin
//                     ? t("Login", "ግባ")
//                     : t("Register", "ተመዝገብ"),
//               ),
//             ),

//             TextButton(
//               onPressed: () => setState(() => isLogin = !isLogin),
//               child: Text(
//                 isLogin
//                     ? t("Create account", "አዲስ መለያ ፍጠር")
//                     : t("Already have account?", "መለያ አለዎት?"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4ED),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(Icons.recycling,
                  size: 80, color: Colors.green),

              const SizedBox(height: 20),

              const Text(
                "RecycleX",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: Image.asset(
                  "assets/google.png",
                  height: 24,
                ),
                label: const Text("Continue with Google"),
                onPressed: () async {
                  await AuthService.signInWithGoogle();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
