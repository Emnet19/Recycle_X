
import 'package:flutter/material.dart';
import 'package:recycle_x/components/login.dart';
import 'package:recycle_x/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Cleaner.dart';
import 'dart:async';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
    debugShowCheckedModeBanner:false,
    home: Splashscreen(),
    );
  }
}

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds:3),(){
      //  User? user =FirebaseAuth.instance.currentUser;

      //  if(user!=null){
         Navigator.pushReplacement(context,
       MaterialPageRoute(builder: (context)=>const LoginPage()));
      //  }else{
        // not logged in
        // Navigator.push(context, 
        //   MaterialPageRoute(builder: (_)=>Cleaner())
        // );
      //  }
     


    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/Image/leaf.png',width:200,height: 400,),
               Text('RecycleX',style:TextStyle(fontSize:30,fontWeight:FontWeight.bold,color:Colors.green)),
               Text('Turning Waste In To Value',style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color: Colors.green[400]),)
            ],
          ),
        ),


    );
  }
}


