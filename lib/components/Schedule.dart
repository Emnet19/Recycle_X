import 'package:flutter/material.dart';
import 'package:recycle_x/components/EarnCoin.dart';
import 'package:recycle_x/main.dart';


void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Schedule(),
    );
  }
}
class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
         child: Stack(
               children: [
                 Center(
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                        Text("Schedule Your Pickup",style:TextStyle(fontSize:45,fontWeight:FontWeight.bold,color:Colors.green),
                         textAlign: TextAlign.center,
                        ),
                        Image.asset('assets/Image/Phone.png',width:200,height:400),
                        Text("set your preferred date and time for \n  collection in just a few taps.",
                        style:TextStyle(fontSize:15,color:Colors.green[400]),textAlign:TextAlign.center,
                        
                        ),
                              const SizedBox(height: 15),

                        ElevatedButton(onPressed: (){}, child: Text("Get Started"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[400],
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 50,vertical: 5),
                          shape:RoundedRectangleBorder(
                            
                            borderRadius: BorderRadiusGeometry.circular(50),
                          )
                        ),
                        )
                    ],
                  ),
                 ),
                  Positioned(
                  top: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                       Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EarnCoin()));
                    },
                    child:Text("Skip",
                    style: TextStyle(fontSize: 15,color: Colors.grey),)
                  ),

                 )
               ],


         ))

      );
     
  }
}