import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_canvas/presentation/theme/theme.dart';
import 'package:travel_canvas/presentation/widgets/select_icon_bottom.dart';

Widget customBottomNavigation(BuildContext context, WidgetRef ref) {
  MyTheme myTheme = MyTheme();
  return Container(
    height: 70,
    padding: const EdgeInsets.only(left: 15, right: 15),
    margin: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(35),
      color: myTheme.darkNavy,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        selectIconBottom(const Icon(Icons.home_rounded), 0, ref),
        selectIconBottom(const Icon(Icons.create_rounded), 1, ref),
        selectIconBottom(const Icon(Icons.article_outlined), 2, ref),
        selectIconBottom(const Icon(Icons.menu_book_rounded), 3, ref),
        selectIconBottom(const Icon(Icons.person_rounded), 4, ref),
      ],
    ),
  );
}
