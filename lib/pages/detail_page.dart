import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:travel_canvas/application/config/date_format.dart';
import 'package:travel_canvas/application/feature/database.dart';
import 'package:travel_canvas/application/state/state.dart';
import 'package:travel_canvas/presentation/theme/tag.dart';
import 'package:travel_canvas/presentation/theme/theme.dart';
import 'package:travel_canvas/presentation/widgets/detail_data.dart';
import 'package:travel_canvas/presentation/widgets/google_map.dart';
import 'package:travel_canvas/presentation/widgets/tag_select.dart';
import 'package:travel_canvas/presentation/widgets/text_custom.dart';

class DetailPage extends HookConsumerWidget {
  const DetailPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MyTheme myTheme = MyTheme();
    Map<String, Color> myTagColor = MyTag().tagColor;
    final Map<String, dynamic>? item = ref.watch(detailPageStateProvider);
    final commentController = useTextEditingController();
    final formatDate =
        item != null ? formatForDisplay(item[DatabaseHelper.columnDate]) : '';

    Position? position;
    if (item != null) {
      if (item[DatabaseHelper.columnPosition] != '') {
        final positionMap = jsonDecode(item[DatabaseHelper.columnPosition]);
        position = Position.fromMap(positionMap);
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              titleText('detail'),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
          if (item != null) ...{
// data
            Stack(children: [
              Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: myTheme.lightGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      detailDataDate(context, 'Date:', formatDate),
                      const SizedBox(
                        height: 10,
                      ),
                      detailData(
                          'Address:', item[DatabaseHelper.columnAddress]),
                      const SizedBox(
                        height: 10,
                      ),
                      detailDataComment(
                          context,
                          'Comment:',
                          item,
                          const Icon(Icons.mode_edit_rounded),
                          commentController,
                          ref),
                    ],
                  )),
              Positioned(
                top: 40,
                right: 40,
                child: GestureDetector(
                  onTap: () {
                    ref.read(detailTagSelectShowProvider.notifier).show();
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 5),
                      color: myTagColor[item[DatabaseHelper.columnTag]],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.flag_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                ),
              ),
// tag select show
              if (ref.watch(detailTagSelectShowProvider))
                Positioned(
                    top: 100,
                    right: 0,
                    left: 0,
                    child: tagSelect(context, item, ref))
            ]),
// image
            Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: myTheme.lightGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(item[DatabaseHelper.columnImage]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                )),
// map
            if (item[DatabaseHelper.columnPosition] != '') ...{
              Container(
                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 30),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: myTheme.lightGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                    height: 400,
                    child: GoogleMapWidget(position: position),
                  ))
            },
// button
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  //delete row
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: myTheme.lightGrey,
                        icon: Icon(Icons.error_outline_rounded,
                            size: 56, color: myTheme.darkNavy),
                        content: Text("このデータを削除します\nよろしいですか？",
                            style: TextStyle(
                                color: myTheme.darkNavy,
                                fontSize: 24,
                                fontWeight: FontWeight.w400)),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(10),
                              backgroundColor: myTheme.blueGrey,
                            ),
                            child: const Text("キャンセル",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w400)),
                            onPressed: () => Navigator.pop(context),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(10),
                                backgroundColor: myTheme.darkRed,
                              ),
                              child: const Text("削除",
                                  style: TextStyle(
                                      // color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400)),
                              onPressed: () async {
                                await DatabaseHelper.instance
                                    .deleteRow(item[DatabaseHelper.columnId]);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                                ref
                                    .read(
                                        bottomNavigationStateProvider.notifier)
                                    .changeIndex(2);
                              }),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: myTheme.darkRed,
                ),
                child: SizedBox(
                  width: 110,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_rounded, color: myTheme.darkNavy),
                      Text('Delete',
                          style: TextStyle(
                            fontSize: 24,
                            color: myTheme.darkNavy,
                          )),
                    ],
                  ),
                )),
          } else ...{
            const Text('No Data')
          },
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
