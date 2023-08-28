import 'dart:io';

import 'package:flutter/material.dart';

Widget galleryImage(String filePath) {
  return Stack(
    children: [
      // shadow
      Column(
        children: [
          const SizedBox(
            height: 300,
          ),
          Container(
            height: 35,
            width: 400,
            // padding: const EdgeInsets.o
            //nly(right: 50, left: 50),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 15,
                ),
              ],
              borderRadius: const BorderRadius.all(
                Radius.elliptical(200, 35),
              ),
            ),
          ),
        ],
      ),
      // image
      Container(
        height: 310,
        width: 400,
        margin: const EdgeInsets.only(right: 10, left: 10, bottom: 30),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(filePath),
              fit: BoxFit.cover,
            )),
      ),
    ],
  );
}
