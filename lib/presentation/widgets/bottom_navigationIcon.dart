import 'package:flutter/material.dart';

Widget selectedIcon(IconData icon) {
  return Container(
    width: 35,
    height: 35,
    decoration: BoxDecoration(
        color: const Color(0xFFCB997E),
        borderRadius: BorderRadius.circular(35 / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ]),
    child: Icon(icon),
  );
}
