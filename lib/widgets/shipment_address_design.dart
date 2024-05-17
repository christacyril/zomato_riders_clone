import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zomato_riders/assistantMethods/get_current_location.dart';
import 'package:zomato_riders/global/global.dart';
import 'package:zomato_riders/mainScreen/parcel_picking_screen.dart';
import 'package:zomato_riders/splashScreen/splash_screen.dart';

import '../models/address.dart';

class ShipmentAddressDesign extends StatelessWidget {
  Address? model;
  String? orderStatus;
  String? orderID;
  String? sellerID;
  String? orderByUser;

  ShipmentAddressDesign({
    this.model,
    this.orderStatus,
    this.orderID,
    this.sellerID,
    this.orderByUser,
  });

  confirmedParcelShipment(BuildContext context, String getOrderID,
      String sellerID, String purchaserID) {
    FirebaseFirestore.instance.collection("orders").doc(getOrderID).update({
      "riderUID": sharedPreferences!.get("uid"),
      "riderName": sharedPreferences!.get("name"),
      "status" : "picking",
      "lat" : position?.latitude,
      "lng": position?.longitude,
      "address" :completeAddress,
    });
    //Send rider to parcel picking screen
    Navigator.push(context, MaterialPageRoute(builder: (c)=> ParcelPickingScreen(
      purchaserID: purchaserID,
      purchaserAddress: model!.completeAddress,
      purchaserLat: model!.lat,
      purchaserLng: model!.lng,
      sellerID: sellerID,
      getOrderID: getOrderID,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Shipping Details:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(children: [
                Text("Name: "),
                Text(model!.name!),
              ]),
              TableRow(children: [
                Text("Phone: "),
                Text(model!.phoneNumber!),
              ])
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text("Address: " + model!.completeAddress!),
              SizedBox(
                height: 10,
              ),
              orderStatus == "ended"
                  ? Container()
                  : ElevatedButton(
                      onPressed: () {
                        UserLocation userLocation = UserLocation();
                        userLocation.getCurrentLocation();

                        confirmedParcelShipment(context, orderID!, sellerID!, orderByUser!);
                      },
                      child: Text(
                        "Confirm to deliver this parcel",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: zomatocolor),
                    ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => SplashScreen()));
                  },
                  child: Text(
                    "Go Back",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: zomatocolor),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
