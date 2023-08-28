import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_canvas/application/feature/database.dart';
import 'package:travel_canvas/application/state/state.dart';

Widget detailDataComment(
    BuildContext context,
    String title,
    Map<String, dynamic> item,
    Icon? icon,
    TextEditingController? commentController,
    WidgetRef ref) {
  final _screenSize = MediaQuery.of(context).size;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Color(0xFF1B263B)),
          ),
          if (icon != null)
            GestureDetector(
              onTap: () {
                //dialog edit
                if (title == 'Comment:') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: const Color(0xFFD9D9D9),
                        icon: const Icon(Icons.edit_document,
                            size: 52, color: Color(0xFF1B263B)),
                        content: SizedBox(
                          height: 220,
                          width: _screenSize.width - 100,
                          child: Column(
                            children: [
                              const Text("Edit Comment",
                                  style: TextStyle(
                                      color: Color(0xFF1B263B),
                                      fontSize: 32,
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(
                                height: 20,
                              ),
                              TextField(
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                                controller: commentController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.blue))),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(10),
                              backgroundColor: Colors.white,
                            ),
                            child: const Text("Cancel",
                                style: TextStyle(
                                    color: Color(0xFF415A78),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400)),
                            onPressed: () => Navigator.pop(context),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(10),
                              backgroundColor: const Color(0xFF415A78),
                            ),
                            child: const Text("Save",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400)),
                            onPressed: () async {
                              if (commentController!.text != "") {
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                                await DatabaseHelper.instance.updateComment(
                                    item[DatabaseHelper.columnId],
                                    commentController.text);
                                ref
                                    .read(
                                        bottomNavigationStateProvider.notifier)
                                    .changeIndex(2);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                // }
              },
              child: icon,
            ),
        ],
      ),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(item[DatabaseHelper.columnComment]),
      ),
    ],
  );
}

Widget detailDataDate(BuildContext context, String title, String text) {
  final _screenSize = MediaQuery.of(context).size;
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(
      title,
      style: const TextStyle(color: Color(0xFF1B263B)),
    ),
    Row(
      children: [
        Container(
          width: _screenSize.width - 180,
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(text),
        ),
        const SizedBox(
          width: 80,
        )
      ],
    ),
  ]);
}

Widget detailData(String title, String text) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(
      title,
      style: const TextStyle(color: Color(0xFF1B263B)),
    ),
    Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(text),
    ),
  ]);
}
