import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_canvas/application/feature/custom_marker.dart';
import 'package:travel_canvas/application/feature/database.dart';
import 'package:travel_canvas/application/state/state.dart';
import 'package:travel_canvas/presentation/theme/tag.dart';
import 'package:travel_canvas/presentation/theme/theme.dart';
import 'package:path/path.dart' as p;

Widget tagSelect(
    BuildContext context, Map<String, dynamic> item, WidgetRef ref) {
  MyTheme myTheme = MyTheme();
  final selectedTag = ref.watch(tagSelectedProvider);
  final imagePath = item[DatabaseHelper.columnImage];
  final fileName = p.basename(imagePath).split('.')[0];
  final id = item[DatabaseHelper.columnId];

  return Container(
    color: const Color.fromARGB(0, 255, 255, 255),
    child: Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54, width: 1),
        color: Color.fromARGB(255, 186, 186, 186),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tagIcon(0, selectedTag, ref),
              tagIcon(1, selectedTag, ref),
              tagIcon(2, selectedTag, ref),
              tagIcon(3, selectedTag, ref),
              tagIcon(4, selectedTag, ref),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.read(detailTagSelectShowProvider.notifier).hide();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  backgroundColor: myTheme.blueGrey,
                ),
                child: const Text('Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () async {
// Save
                  await CustomMarker(imagePath, fileName)
                      .customMarker(selectedTag);
                  await DatabaseHelper.instance.updateTag(id, selectedTag);
                  ref.read(detailTagSelectShowProvider.notifier).hide();
                  ref
                      .read(bottomNavigationStateProvider.notifier)
                      .changeIndex(2);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  backgroundColor: myTheme.lightBrown,
                ),
                child: Text('Save',
                    style: TextStyle(
                      color: myTheme.blueGrey,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget tagIcon(int index, String selectedTag, WidgetRef ref) {
  Map<String, Color> myTagColor = MyTag().tagColor;
  MyTheme myTheme = MyTheme();
  List<Color> colors = myTagColor.values.toList();
  List<String> keys = myTagColor.keys.toList();
  return GestureDetector(
    onTap: () {
      ref.read(tagSelectedProvider.notifier).changeTag(keys[index]);
    },
    child: Container(
      height: 60,
      width: 60,
      margin: index != colors.length ? EdgeInsets.all(5) : null,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
          color: colors[index],
          border: selectedTag == keys[index]
              ? Border.all(color: myTheme.darkNavy, width: 4)
              : Border.all(color: Colors.white54, width: 1)),
    ),
  );
}
