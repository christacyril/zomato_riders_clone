import 'package:flutter/material.dart';
import 'package:zomato_riders/global/global.dart';
import 'package:zomato_riders/splashScreen/splash_screen.dart';
import 'package:zomato_riders/widgets/simple_app_bar.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Earnings Screen",
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Rs " + previousRiderEarnings,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: zomatocolor),
            ),
            Text(
              "Total Earnings ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: zomatocolor),
            ),

            SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (c)=> SplashScreen()));
            },
                child: Text(
                  "Back",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
            style: ElevatedButton.styleFrom(
              backgroundColor: zomatocolor
            ),)
          ],
        ),
      ),
    );
  }
}
