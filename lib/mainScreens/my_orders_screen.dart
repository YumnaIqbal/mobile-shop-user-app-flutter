import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobileshp_user_app/assistantMethod/assistant_method.dart';
import 'package:mobileshp_user_app/global/global.dart';
import 'package:mobileshp_user_app/widgets/order_card.dart';
import 'package:mobileshp_user_app/widgets/progress_bar.dart';
import 'package:mobileshp_user_app/widgets/simple_app_bar.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(title: "My Orders",),
        body: StreamBuilder<QuerySnapshot?>(
          stream: FirebaseFirestore
              .instance.collection("users").doc(sharedPreferences!
              .getString("uid")).collection("orders")
              .where("status", isEqualTo: "normal")
              .orderBy("orderTime", descending: true).snapshots(),
          builder: (c, AsyncSnapshot<QuerySnapshot?> snapshot){
            return snapshot.hasData ? ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (c, index){
                  return FutureBuilder<QuerySnapshot?>(
                    future: FirebaseFirestore.instance.collection("models")
                        .where("modelID", whereIn:
                    separateOrdersItemIDs((snapshot.data!.docs[index].data() as Map<String, dynamic>)["productIDs"]))
                        .where("orderBy", whereIn: (snapshot.data?.docs[index].data() as Map<String, dynamic>)["uid"])
                        .orderBy("publishedDate", descending: false).get(),
                    builder: (c, AsyncSnapshot<QuerySnapshot?> snap) {
                      return snap.hasData
                          ? OrderCard(
                        itemCount: snap.data?.docs.length,
                        data: snap.data?.docs,
                        orderID: snapshot.data?.docs[index].id,
                        seperateQuantitiesList: separateOrderItemQuantities(
                            (snapshot.data?.docs[index].data() as Map<
                                String,
                                dynamic>)["productIDs"]),

                      )
                          : Center(child: circularProgress(),);
                    },
                  );
                }
            )
                : Center(child: circularProgress(),);
          },
        )
      ),

    );
  }
}
