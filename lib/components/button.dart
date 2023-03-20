import 'package:flutter/material.dart';

Widget customButton(
    {VoidCallback? tap,
    bool? status = false,
    String? text = 'Save',
    BuildContext? context}) {
  return GestureDetector(
    onTap: status == true ? null : tap,
    child: Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 25.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: status == false ? Colors.green[700] : Colors.grey[500],
          borderRadius: BorderRadius.circular(8)),
      width: MediaQuery.of(context!).size.width,
      child: Text(
        status == false ? text! : 'Please wait...',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
  );
}
