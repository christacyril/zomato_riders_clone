import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zomato_riders/assistantMethods/get_current_location.dart';
import 'package:zomato_riders/global/global.dart';
import 'package:zomato_riders/mainScreen/parcel_delivering_screen.dart';
import 'package:zomato_riders/maps/map_utils.dart';

class ParcelPickingScreen extends StatefulWidget {
  String? purchaserID;
  String? sellerID;
  String? getOrderID;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;

  ParcelPickingScreen({
    this.purchaserID,
    this.sellerID,
    this.getOrderID,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
  });

  @override
  State<ParcelPickingScreen> createState() => _ParcelPickingScreenState();
}

class _ParcelPickingScreenState extends State<ParcelPickingScreen> {
  double? sellerLat, sellerLng;
  
  getSellerData() async{
    FirebaseFirestore.instance.collection("sellers").doc(widget.sellerID).get().then((DocumentSnapshot){
      sellerLat = DocumentSnapshot.data()!["lat"];
      sellerLng = DocumentSnapshot.data()!["lng"];
    });
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSellerData();
  }
  
  confirmParcelHasBeenPicked(getOrderID, sellerID, purchaserID, purchaserAddress, purchaserLat, purchaserLng){
    FirebaseFirestore.instance.collection("orders").doc(getOrderID).update(
      {
        "status" : "delivering",
        "address" : completeAddress,
        "lat" : position?.latitude,
        "lng" : position?.longitude,
      }
    );
    Navigator.push(context, MaterialPageRoute(builder: (c)=> ParcelDeliveringScreen(
      purchaserID: purchaserID,
      purchaserAddress: purchaserAddress,
      purchaserLat: purchaserLat,
      purchaserLng: purchaserLng,
      sellerID: sellerID,
      getOrderID: getOrderID,
    )));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/map.jpg",
          width: 350,
          ),
          SizedBox(height: 10,),

          GestureDetector(
            onTap: (){
              MapUtils.launchMapFromSourceToDestination(position!.latitude,
                  position!.longitude,
                  sellerLat,
                  sellerLng);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on,
                color: zomatocolor,),
                SizedBox(width: 10,),

                Column(
                  children: [
                     Text("Show restaurant location on map",style: TextStyle(
                       fontSize: 20
                     ),)
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10,),

          ElevatedButton(onPressed: (){
            UserLocation userLocation = UserLocation();
            userLocation.getCurrentLocation();

            confirmParcelHasBeenPicked(
                widget.getOrderID,
                widget.sellerID,
                widget.purchaserID,
                widget.purchaserAddress,
                widget.purchaserLat,
                widget.purchaserLng);
          },
              child: Text("Order has been picked",
              style: TextStyle(
                color: Colors.white
              ),),
          style: ElevatedButton.styleFrom(
            backgroundColor: zomatocolor
          ),
          )
        ],
      ),
    );
  }
}
