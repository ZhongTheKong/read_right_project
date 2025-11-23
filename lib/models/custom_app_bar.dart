import 'package:flutter/material.dart';


PreferredSizeWidget CustomAppBar(String text, bool isOnline) {
  // final bool isOnline;

  // @override
  // Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text("PRACTICE"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: isOnline ? Colors.green : Colors.red,
                  shape: BoxShape.circle, // Makes the container circular
                ),
              ),
              SizedBox(width: 10,),
              Text(
                isOnline ? "ONLINE" : "OFFLINE",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          )
        ],
      )
    );
  // }
}