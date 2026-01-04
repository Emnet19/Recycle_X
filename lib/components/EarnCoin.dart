import 'package:flutter/material.dart';
import 'package:recycle_x/main.dart';
import 'login.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EarnCoin(),
    );
  }
}
class EarnCoin extends StatefulWidget {
  const EarnCoin({super.key});

  @override
  State<EarnCoin> createState() => _EarnCoinState();
}

class _EarnCoinState extends State<EarnCoin> {
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
                        Text("Earn EcoCoins & Save Money",style:TextStyle(fontSize:45,fontWeight:FontWeight.bold,color:Colors.green),
                         textAlign: TextAlign.center,
                        ),
                        Image.asset('assets/Image/coinPro.png',width:200,height:300),
                        Text("Recycle your waste with us and get rewarded. Collect EcoCoins and redeem  them for exclusive discounts and offers from our eco-friendly  partners. ",
                        style:TextStyle(fontSize:15,color:Color.fromARGB(255, 4, 140, 11)),textAlign:TextAlign.center,
                        
                        ),
                              const SizedBox(height: 35),

                        ElevatedButton(onPressed: (){
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>const LoginPage()));
                        },
                         child: Text("Get Started"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 140, 226, 145),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 90,vertical: 10),
                          shape:RoundedRectangleBorder(
                            
                            borderRadius: BorderRadiusGeometry.circular(30),
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
                      MaterialPageRoute(builder: (context) => MyApp()));
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