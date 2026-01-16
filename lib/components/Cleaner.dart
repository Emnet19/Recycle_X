import 'package:flutter/material.dart';
import 'package:recycle_x/components/Schedule.dart';
import 'package:recycle_x/main.dart';
import 'package:recycle_x/components/login.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Cleaner(),
    );
  }
}
class Cleaner extends StatefulWidget {
  const Cleaner({super.key});

  @override
  State<Cleaner> createState() => _CleanerState();
}

class _CleanerState extends State<Cleaner> {
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
                        Text("Make Your Home Cleaner",style:TextStyle(fontSize:45,fontWeight:FontWeight.bold,color:Colors.green),
                         textAlign: TextAlign.center,
                        ),
                        Image.asset('assets/Image/girl.png',width:300,height:450),
                        Text("Learn how to sort waste effectively and \ncontribute to a healthier planet, starting from your own space",
                        style:TextStyle(fontSize:15,color:Colors.green[400]),textAlign:TextAlign.center,
                        
                        ),
                              const SizedBox(height: 10),

                        ElevatedButton(onPressed: (){
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>RecycleLoginPage()));
                        }, 
                        child: Text("Get Started"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[400],
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
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
                      MaterialPageRoute(builder: (context) => Schedule()));
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
