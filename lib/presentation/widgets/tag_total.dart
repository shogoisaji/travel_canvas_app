import 'package:flutter/material.dart';
import 'package:travel_canvas/application/feature/database.dart';

Widget tagTotal(String tagColor) {
  return FutureBuilder<String>(
      future: DatabaseHelper.instance.getTagCount(tagColor),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('error');
        }

        final data = snapshot.data;
        if (data!.isEmpty) {
          return const SizedBox(
              // height: 300,
              );
        }

        return Text(data);
      });
}
