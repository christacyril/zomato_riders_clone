import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../assistantMethods/assistant_methods.dart';
import '../global/global.dart';
import '../widgets/order_card.dart';
import '../widgets/progress_bar.dart';
import '../widgets/simple_app_bar.dart';

class ParcelInProgressScreen extends StatefulWidget {
  const ParcelInProgressScreen({super.key});

  @override
  State<ParcelInProgressScreen> createState() => _ParcelInProgressScreenState();
}

class _ParcelInProgressScreenState extends State<ParcelInProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: SimpleAppBar(
        title: "Parcel In Progress",
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("orders")
            .where("riderID", isEqualTo: sharedPreferences!.getString("uid"))
            .where("status", isEqualTo: "picking").snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("items")
                      .where("itemID",
                      whereIn: separateOrderItemsIDs(
                          (snapshot.data!.docs[index].data()!
                          as Map<String, dynamic>)["productIDs"]))
                      .orderBy("publishedDate", descending: true)
                      .get(),
                  builder: (context, snap) {
                    return snap.hasData
                        ? Column(
                      children: [
                        OrderCard(
                          itemCount: snap.data!.docs.length,
                          data: snap.data!.docs,
                          orderID: snapshot.data!.docs[index].id,
                          separateQuantitiesList:
                          separateOrderItemQuantities((snapshot
                              .data!.docs[index]
                              .data()!
                          as Map<String, dynamic>)[
                          "productIDs"]),
                        ),
                        Container(
                          height: 40,
                          margin: EdgeInsets.symmetric(),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(5),
                              color: zomatocolor),
                          child: Center(
                            child: Text(
                              "Click to see details",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    )
                        : Center(
                      child: circularProgress(),
                    );
                  });
            },
          )
              : Center(child: circularProgress());
        },
      ),
    );
  }
}
