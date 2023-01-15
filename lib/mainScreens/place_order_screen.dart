import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobileshp_user_app/assistantMethod/assistant_method.dart';
import 'package:mobileshp_user_app/global/global.dart';
import 'package:mobileshp_user_app/mainScreens/home_screen.dart';

class PlaceOrderScreen extends StatefulWidget {
 String? addressID;
 double? totalAmount;
 String ? sellerUID;
 PlaceOrderScreen({
   this.sellerUID,
   this.totalAmount,
   this.addressID,
});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen>
{
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();

  addOrderDetails(){
    writeOrderDetailsForUser({
      "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    });
    writeOrderDetailsForSeller({
      "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,

    }).whenComplete(() {
      clearCartNow(context);
      setState(() {
        orderId ="";
        Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
        Fluttertoast.showToast(msg: "Congratulations, Order has been placed Successfully");
      });
    });

  }
  Future writeOrderDetailsForUser(Map<String, dynamic> data, ) async{
    await FirebaseFirestore.instance.collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders").doc(orderId).set(data);
  }
  Future writeOrderDetailsForSeller(Map<String, dynamic> data, ) async{
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId).set(data);
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration:const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.teal,
                Colors.white,

              ],
              begin:  FractionalOffset(0.0, 0.0),
              end:  FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/delivery.jpg"),
        SizedBox(height: 12,),
        ElevatedButton(
          child: const Text("Place Order"),
          style: ElevatedButton.styleFrom(
            primary: Colors.cyan,
          ),
          onPressed: () {

            addOrderDetails();
          }

        ),
          ],
        ),
      ),
    );
  }
}

