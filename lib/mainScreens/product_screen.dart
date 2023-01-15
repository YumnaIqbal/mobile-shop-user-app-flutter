import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mobileshp_user_app/assistantMethod/assistant_method.dart';
import 'package:mobileshp_user_app/models/product.dart';
import 'package:mobileshp_user_app/models/sellers.dart';
import 'package:mobileshp_user_app/splashScreen/splash_screen.dart';
import 'package:mobileshp_user_app/widgets/products_design.dart';
import 'package:mobileshp_user_app/widgets/seller_design.dart';
import 'package:mobileshp_user_app/widgets/my_drawer.dart';
import 'package:mobileshp_user_app/widgets/progress_bar.dart';
import 'package:mobileshp_user_app/widgets/text_widget.dart';


import '../authentication/auth_screen.dart';
import '../global/global.dart';

class MenusScreen extends StatefulWidget {
  final Sellers? model;
  MenusScreen({this.model});

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
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
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            clearCartNow(context);
            Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));

          },
        ),
        title: const Text(
          "Mobile Mart",
          style: TextStyle(
            fontFamily: "Signatra",
            fontSize: 45,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,


      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title:widget.model!.sellerName.toString() + "Products") ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("sellers")
                .doc(widget.model!.sellerUID)
                .collection("products").orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ?SliverToBoxAdapter(
                child: Center(
                  child: circularProgress(),
                ),

              )
                  : SliverStaggeredGrid.countBuilder(
                crossAxisCount: 1,
                staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                itemBuilder: (context, index) {
                  Products model = Products.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );
                  return MenusDesignWidget(
                    model: model,
                    context: context,
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );

            },
          )
        ],
      ),
    );
  }
}
