import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  

  const CustomTextButton({super.key, });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      child: Container(
        padding:  EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: Colors.green[800]),
        child: Center(
          child: Text(
            "Login",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }
}




//  const IconData globe = IconData(0xf68d, fontFamily: iconFont, fontPackage: iconFontPackage);