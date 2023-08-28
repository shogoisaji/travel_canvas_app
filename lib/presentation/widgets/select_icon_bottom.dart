import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_canvas/application/state/state.dart';
import 'package:travel_canvas/presentation/theme/theme.dart';

Widget selectIconBottom(Icon icon, int index, WidgetRef ref) {
  MyTheme myTheme = MyTheme();
  return Container(
    alignment: Alignment.center,
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(40),
      color: ref.watch(bottomNavigationStateProvider) == index
          ? myTheme.lightBrown
          : const Color.fromARGB(0, 0, 0, 0),
    ),
    child: IconButton(
      onPressed: () {
        ref.read(bottomNavigationStateProvider.notifier).changeIndex(index);
      },
      icon: icon,
      color: ref.watch(bottomNavigationStateProvider) == index
          ? myTheme.darkNavy
          : Colors.white,
      iconSize: 32,
    ),
  );
}
