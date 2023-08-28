import 'package:flutter/material.dart';
import 'package:travel_canvas/domain/types/models.dart';

Widget modelToWidget(GalleryPicture model) {
  return Stack(
    children: [
      Align(
        alignment: const Alignment(0.0, 0.9),
        child: Container(
          height: 35,
          width: 300,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 15,
              ),
            ],
            borderRadius: const BorderRadius.all(
              Radius.elliptical(200, 35),
            ),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(right: 10, left: 10, bottom: 30),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: (AssetImage('images/${model.pictureUri}')),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ],
  );
}
