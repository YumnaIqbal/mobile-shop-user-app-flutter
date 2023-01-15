import 'package:flutter/material.dart';
import 'package:mobileshp_user_app/models/models.dart';


class CartItemDesign extends StatefulWidget {
 final Models? model;
 BuildContext? context;
 final int? quanNumber;
 CartItemDesign({
   this.model,
   this.context,
   this.quanNumber,
});

  @override
  State<CartItemDesign> createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyan,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          height: 165,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              //image
              Image.network(widget.model!.thumbnailUrl!,
              width: 140,
              height: 120,),
              const SizedBox(width: 6.0,),
              //title
              //quantity
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.model!.title!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily:"Kiwi"
                  ),
                  ),
                  const SizedBox(height: 1,),
                  Row(
                    children: [
                       const Text("x ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily:"kiwi"
                        ),
                      ),
                      Text(widget.quanNumber.toString(),
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily:"Acme"
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children:  [
                     const Text("Price ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.teal,

                        ),),
                      const Text("Rs ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,

                        ),),
                      Text(widget.model!.price.toString(),
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily:"Acme"
                        ),),

                    ],
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
