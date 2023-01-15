import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobileshp_user_app/assistantMethod/assistant_method.dart';
import 'package:mobileshp_user_app/assistantMethod/cart_item_counter.dart';
import 'package:mobileshp_user_app/assistantMethod/total_amount.dart';
import 'package:mobileshp_user_app/mainScreens/address_screen.dart';
import 'package:mobileshp_user_app/models/models.dart';
import 'package:mobileshp_user_app/splashScreen/splash_screen.dart';
import 'package:mobileshp_user_app/widgets/app_bar.dart';
import 'package:mobileshp_user_app/widgets/cart_item_design.dart';
import 'package:mobileshp_user_app/widgets/progress_bar.dart';
import 'package:mobileshp_user_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final String? sellerID;
  CartScreen({this.sellerID});


  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? separateItemQuantityList;
  num totalAmount = 0;


  @override
  void initState() {

    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);

    separateItemQuantityList= separateItemQuantities();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
        ),
        leading: IconButton(
          icon: Icon(Icons.clear_all),
          onPressed: (){
            clearCartNow(context);
          },
        ),
        title: const Text(
          "Mobile Mart",
          style: TextStyle(
            fontFamily: "Signatra",
            fontSize: 40,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,

        actions:  //used to display button icon on right side
        [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart,
                  color: Colors.teal,),
                onPressed: () {
                  print("clicked");

                },
              ),
              Positioned(
                child: Stack(
                  children:[
                    const Icon(
                      Icons.brightness_1,
                      size: 20.0,
                      color: Colors.green,
                    ),
                    Positioned(
                      top: 3,
                      right: 4,
                      child: Center(
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, c){
                            return Text(
                              counter.count.toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width: 10,),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              label: Text(
                "Clear Cart",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.cyan,
              icon: Icon(Icons.clear_all),
              onPressed: (){
                clearCartNow(context);
                Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));

                Fluttertoast.showToast(msg: "Cart has been cleared");

              },

            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn2",
              label: Text(
                "Check out",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.cyan,
              icon: Icon(Icons.navigate_next),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (c) =>
                AddressScreen(
                  totalAmount: totalAmount.toDouble(),
                  sellerUID: widget.sellerID,

                )
                ),);

              },

            ),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          //overall amount
          SliverPersistentHeader(pinned: true,
              delegate: TextWidgetHeader(title: "My Cart List" )),
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c)
            {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: cartProvider.count == 0
                      ? Container()
                      : Text(
                    "Total Price: " + amountProvider.tAmount.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight:  FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),
          //display cart item with quantity numbers
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.
            collection("models").where("modelID", whereIn: separateItemIDs())
                .orderBy("publishedDate", descending: true).snapshots(),
            builder: (context, snapshot){
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  :snapshot.data!.docs.isEmpty
                  ? //startBuildingCart()
                   Container()
                  : SliverList(
                delegate: SliverChildBuilderDelegate((context,index)
                {
                  Models model= Models.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );
                  if(index == 0)  //when index is zero we display first item
                  {
                    totalAmount = 0;
                    totalAmount = totalAmount + (model.price! * separateItemQuantityList![index]);
                  }
                  else
                  {
                    totalAmount = totalAmount + (model.price! * separateItemQuantityList![index]);
                  }

                  if(snapshot.data!.docs.length - 1 == index) //at the 0 index we have the garbage value so we used -1
                  {
                    WidgetsBinding.instance!.addPostFrameCallback((timeStamp)
                    {
                      Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(totalAmount.toDouble());
                    });
                  }
                  return CartItemDesign(
                    model: model,
                    context: context,
                    quanNumber:separateItemQuantityList![index] ,
                  );
                },
                  childCount: snapshot.hasData ? snapshot.data!.docs.length
                      :0,
                ),
              );
            },
          )
        ],

      ),
    );
  }
}
