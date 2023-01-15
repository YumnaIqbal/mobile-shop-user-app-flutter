import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileshp_user_app/mainScreens/home_screen.dart';
import 'package:mobileshp_user_app/models/address.dart';
import 'package:mobileshp_user_app/splashScreen/splash_screen.dart';

class ShipmentAddressDesign extends StatelessWidget {
 final Address? model;
 ShipmentAddressDesign({this.model});

 void textMe(){

 }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: const Text("Shipment Details:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),),
        ),
       const SizedBox(height: 6,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children:[
                  Text("Name",
                  style: TextStyle(color: Colors.black),),
                  Text(model!.name!),
                ]
              ),
              TableRow(
                  children:[
                    Text("Phone Number",
                      style: TextStyle(color: Colors.black),),
                    Text(model!.phoneNumber!),
                  ]
              )
            ],
          ),
        ),
        const SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text( model!.fullAddress!,
          textAlign: TextAlign.justify,),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (c) => MySplashScreen()));

            },
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
              width: MediaQuery.of(context).size.width -40.0,
              height: 50.0,
              child: Center(
                child: Text(
                  "Go Back",
                  style: TextStyle(
                    color: Colors.cyan, fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),),
        ),
        CupertinoButton(child: Text('chat with rider'),
            onPressed: (){

            })

      ],
    );
  }
}
