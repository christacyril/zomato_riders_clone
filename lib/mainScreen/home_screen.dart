import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zomato_riders/assistantMethods/get_current_location.dart';
import 'package:zomato_riders/global/global.dart';
import 'package:zomato_riders/mainScreen/earnings_screen.dart';
import 'package:zomato_riders/mainScreen/history_screen.dart';
import 'package:zomato_riders/mainScreen/new_orders_screen.dart';
import 'package:zomato_riders/mainScreen/not_yet_delivered_screen.dart';
import 'package:zomato_riders/mainScreen/parcel_in_progress_screen.dart';
import 'package:zomato_riders/widgets/my_drawer.dart';

import '../splashScreen/splash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  getRiderPreviousEarnings(){
    FirebaseFirestore.instance.collection("riders").doc(sharedPreferences!.getString("uid")).get().then((snap){
      previousRiderEarnings = snap.data()!["earnings"].toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserLocation userLocation = UserLocation();
    userLocation.getCurrentLocation();
    getRiderPreviousEarnings();
  }

  Card makeDashboardItem(String title, IconData iconData, int index) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(10),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? BoxDecoration(
                color: Color(0xffeffe0e7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2, color: zomatocolor!))
            : BoxDecoration(
                color: Color(0xffeffe0e7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2, color: zomatocolor!)),
        child: GestureDetector(
          onTap: () {
            if (index == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => NewOrdersScreen()));
            }
            if (index == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (c)=> ParcelInProgressScreen()));
            }
            if (index == 2) {
              //Notyeldelivered
              Navigator.push(context, MaterialPageRoute(builder: (c)=> NotYetDeliveredScreen()));

            }
            if (index == 3) {
              //TotalEarnings
              Navigator.push(context, MaterialPageRoute(builder: (c)=> EarningsScreen()));
            }
            if (index == 4) {
              //History
              Navigator.push(context, MaterialPageRoute(builder: (c)=> HistoryScreen()));
            }
            if (index == 5) {
              //logout
              firebaseAuth.signOut().then((value) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => SplashScreen()));
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 40,
                color: zomatocolor,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: zomatocolor),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: zomatocolor,
        title: Text(
          "Zomato Riders",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: MyDrawer(),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 1),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(2),
          children: [
            makeDashboardItem("New Available Orders", Icons.assignment, 0),
            makeDashboardItem("Parcels in progress", Icons.airport_shuttle, 1),
            makeDashboardItem("Not yet delivered", Icons.location_history, 2),
            makeDashboardItem("Earnings", Icons.money, 3),
            makeDashboardItem("History", Icons.done_all, 4),
            makeDashboardItem("Log Out", Icons.logout, 5),
          ],
        ),
      ),
      // body: Center(child: ElevatedButton(
      //   onPressed: (){
      //     firebaseAuth.signOut().then((value){
      //       Navigator.push(context, MaterialPageRoute(builder: (c)=> SplashScreen()));
      //     });
      //   }, child: Text("Sign Out"),
      // )),
    );
  }
}
