import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_canvas/application/config/date_format.dart';
import 'package:travel_canvas/application/feature/database.dart';
import 'package:travel_canvas/application/state/state.dart';
import 'package:travel_canvas/presentation/theme/theme.dart';

Widget listCard(
    BuildContext context, Map<String, dynamic> item, WidgetRef ref) {
  final _screenSize = MediaQuery.of(context).size;
  final tagColor = item[DatabaseHelper.columnTag];
  final formatDate = formatForDisplay(item[DatabaseHelper.columnDate]);
  MyTheme myTheme = MyTheme();
  return InkWell(
    onTap: () {
      ref.watch(detailPageStateProvider.notifier).setState(item);
      ref.read(bottomNavigationStateProvider.notifier).changeIndex(5);
    },
    child: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.fromLTRB(15, 7, 7, 7),
        decoration: BoxDecoration(
          color: myTheme.grey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDate.split(' ')[0],
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      margin: const EdgeInsets.only(left: 10),
                      child: Image.asset('assets/images/bird_$tagColor.png'),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: _screenSize.width - 160,
                  child: Text(
                    item[DatabaseHelper.columnAddress] ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(item[DatabaseHelper.columnImage]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        )),
  );
}
