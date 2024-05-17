import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zomato_riders/maps/map_utils.dart';
import 'package:zomato_riders/splashScreen/splash_screen.dart';

import '../assistantMethods/get_current_location.dart';
import '../global/global.dart';

class ParcelDeliveringScreen extends StatefulWidget {
  String? purchaserID;
  String? sellerID;
  String? getOrderID;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;

  ParcelDeliveringScreen({
    this.purchaserID,
    this.sellerID,
    this.getOrderID,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
  });

  @override
  State<ParcelDeliveringScreen> createState() => _ParcelDeliveringScreenState();
}

class _ParcelDeliveringScreenState extends State<ParcelDeliveringScreen> {
  String orderTotalAmount = "";

  confirmParcelHasBeenDelivered(getOrderID, sellerID, purchaserID,
      purchaserAddress, purchaserLat, purchaserLng) {

    print("previousRiderEarnings: "+previousRiderEarnings);

    print("perParcelDeliveryAmount: "+perParcelDeliverChargeAmount);

    String riderNewTotalEarningAmount = ((double.parse(previousRiderEarnings)) +
            (double.parse(perParcelDeliverChargeAmount)))
        .toString();

    print("riderNewTotalEarningAmount: "+riderNewTotalEarningAmount);

    FirebaseFirestore.instance.collection("orders").doc(getOrderID).update({
      "status": "ended",
      "address": completeAddress,
      "lat": position?.latitude,
      "lng": position?.longitude,
      "earnings": perParcelDeliverChargeAmount
    }).then((value) {
      FirebaseFirestore.instance
          .collection("riders")
          .doc(sharedPreferences!.getString("uid"))
          .update({
        "earnings": riderNewTotalEarningAmount,
      });
    }).then((value) {
      FirebaseFirestore.instance
          .collection("sellers")
          .doc(widget.sellerID)
          .update({
        "earnings": (double.parse(orderTotalAmount) +
                (double.parse(previousSellerEarnings)))
            .toString(),
      });
    }).then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(purchaserID)
          .collection("orders")
          .doc(getOrderID)
          .update({
        "status": "ended",
        "riderID": sharedPreferences!.getString("uid"),
      });
    });
    Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));
  }

  getOrderTotalAmount() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.getOrderID)
        .get()
        .then((snap) {
      orderTotalAmount = snap.data()!["totalAmount"].toString();
      widget.sellerID = snap.data()!["sellerID"].toString();
    }).then((value) {
      getSellerData();
    });
  }

  getSellerData() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerID)
        .get()
        .then((snap) {
      previousSellerEarnings = snap.data()!["earnings"].toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserLocation userLocation = UserLocation();
    userLocation.getCurrentLocation();

    getOrderTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/map.jpg",
            width: 350,
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              MapUtils.launchMapFromSourceToDestination(
                  position!.latitude,
                  position!.longitude,
                  widget.purchaserLat,
                  widget.purchaserLng);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: zomatocolor,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(
                      "Show delivery drop-off location",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              UserLocation userLocation = UserLocation();
              userLocation.getCurrentLocation();

              confirmParcelHasBeenDelivered(
                  widget.getOrderID,
                  widget.sellerID,
                  widget.purchaserID,
                  widget.purchaserAddress,
                  widget.purchaserLat,
                  widget.purchaserLng);
            },
            child: Text(
              "Order has been delivered!",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: zomatocolor),
          )
        ],
      ),
    );
  }
}
