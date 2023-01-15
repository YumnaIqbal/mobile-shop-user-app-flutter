import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobileshp_user_app/assistantMethod/assistant_method.dart';
import 'package:mobileshp_user_app/global/global.dart';
import 'package:mobileshp_user_app/models/models.dart';
import 'package:mobileshp_user_app/models/sellers.dart';
import 'package:mobileshp_user_app/widgets/app_bar.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:url_launcher/url_launcher.dart';

class ModelDetailScreen extends StatefulWidget {
  final Models? model;
  final Sellers? seller;
  ModelDetailScreen({this.model, this.seller});

  @override
  State<ModelDetailScreen> createState() => _ModelDetailScreenState();
}

class _ModelDetailScreenState extends State<ModelDetailScreen> {
  TextEditingController counterTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: MyAppBar(sellerID: widget.model!.sellerID),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.model!.thumbnailUrl.toString()),


            Padding(
              padding: const EdgeInsets.all(18.0),
              child: NumberInputPrefabbed.roundedButtons(
                controller: counterTextEditingController,
                incDecBgColor: Colors.teal,
                min: 1,
                max: 9,
                initialValue: 1,
                buttonArrangement: ButtonArrangement.incRightDecLeft,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.title.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 10),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.price.toString() + " Rs",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),

            const SizedBox(height: 10,),


            SizedBox(height: 20,),
            Center(
              child: InkWell(
                onTap: ()
                {
                  int itemCounter = int.parse(counterTextEditingController.text);

                  List<String> separateItemIDsList = separateItemIDs();

                  //1.check if item exist already in cart
                  separateItemIDsList.contains(widget.model!.modelID)
                      ? Fluttertoast.showToast(msg: "Item is already in Cart.")
                      :

                  //add to cart
                  addItemToCart(widget.model!.modelID, context, itemCounter);
                },
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyan,
                          Colors.teal,
                        ],
                        begin:  FractionalOffset(0.0, 0.0),
                        end:  FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      )
                  ),
                  width: MediaQuery.of(context).size.width - 13,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: ()
              {
              _textMe() async {
                // Android
                 var uri = 'sms:${widget.seller!.sellerPhone}';
                if (await launch(uri)) {
                  await launch(uri);
                } else {
                  // iOS
                  uri = 'sms:${widget.seller!.sellerPhone}';
                  if (await launch(uri)) {
                    await launch(uri);
                  } else {
                    throw 'Could not launch $uri';
                  }
                }
              }
              },
                  child: Text("Contact to the Seller",
                    style: TextStyle(color: Colors.white, fontSize: 15),),
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyan,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
