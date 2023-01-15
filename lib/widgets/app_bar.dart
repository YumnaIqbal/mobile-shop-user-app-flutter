import 'package:flutter/material.dart';
import 'package:mobileshp_user_app/assistantMethod/cart_item_counter.dart';
import 'package:mobileshp_user_app/mainScreens/cart_screen.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget
{
  final PreferredSizeWidget? bottom;
  final String? sellerID;
  MyAppBar({this.bottom, this.sellerID});


  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override

  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56,80 +AppBar().preferredSize.height );
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return  AppBar(
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
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.pop(context);
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
                //send user to cart screen
                Navigator.push(context, MaterialPageRoute(builder: (c) => CartScreen(sellerID: widget.sellerID)));

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
    );
  }
}
