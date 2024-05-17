import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../assistantMethods/assistant_methods.dart';
import '../global/global.dart';
import '../widgets/order_card.dart';
import '../widgets/progress_bar.dart';
import '../widgets/simple_app_bar.dart';

class NotYetDeliveredScreen extends StatefulWidget {
  const NotYetDeliveredScreen({super.key});

  @override
  State<NotYetDeliveredScreen> createState() => _NotYetDeliveredScreenState();
}

class _NotYetDeliveredScreenState extends State<NotYetDeliveredScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "To be delivered",
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("orders")
            .where("riderUID", isEqualTo: sharedPreferences!.getString("uid"))
            .where("status", isEqualTo: "delivering").snapshots(),
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
