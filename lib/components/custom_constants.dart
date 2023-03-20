import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

Text customText(String st) {
  return Text(
    st,
    style: TextStyle(color: Colors.white),
  );
}

Text customTextBlack(String st) {
  return Text(
    st,
    style: TextStyle(
      fontSize: 16,
    ),
  );
}

class CustomRow extends StatelessWidget {
  IconData ic;
  String data;

  CustomRow({
    required this.ic,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6)),
                Icon(
                  ic,
                  color: Colors.green[600],
                ),
                const SizedBox(
                  width: 12,
                ),
                customTextBlack(data)
              ],
            ),
            const Align(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_right,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        // const Divider(
        //   thickness: 2,
        // ),
        // SizedBox(
        //   height: 5,
        // )
      ],
    );
  }
}

AppBar CustomAppBar(String stringTitle) {
  return AppBar(
    backgroundColor: Colors.green[800],
    title: Text(stringTitle),
    centerTitle: true,
  );
}
