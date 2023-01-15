import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mobileshp_user_app/models/models.dart';
import 'package:mobileshp_user_app/models/product.dart';
import 'package:mobileshp_user_app/widgets/app_bar.dart';
import 'package:mobileshp_user_app/widgets/models_design.dart';
import 'package:mobileshp_user_app/widgets/seller_design.dart';
import 'package:mobileshp_user_app/widgets/my_drawer.dart';
import 'package:mobileshp_user_app/widgets/progress_bar.dart';
import 'package:mobileshp_user_app/widgets/text_widget.dart';


import '../authentication/auth_screen.dart';
import '../global/global.dart';

class ItemsScreen extends StatefulWidget {
  final Products? model;
  ItemsScreen({this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(sellerID: widget.model!.sellerID),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: "Models of"+ widget.model!.productTitle.toString()) ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("sellers")
                .doc(widget.model!.sellerID)
                .collection("products").doc(widget.model!.productID).collection("models").orderBy("publishedDate", descending: true)
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
                  Models model = Models.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );
                  return ItemsDesignWidget(
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
