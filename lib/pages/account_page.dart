import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_canvas/application/feature/database.dart';
import 'package:travel_canvas/presentation/theme/tag.dart';
import 'package:travel_canvas/presentation/theme/theme.dart';
import 'package:travel_canvas/presentation/widgets/detail_data.dart';
import 'package:travel_canvas/presentation/widgets/tag_total.dart';
import 'package:travel_canvas/presentation/widgets/text_custom.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MyTheme myTheme = MyTheme();
    Map<String, Color> myTagColor = MyTag().tagColor;

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
              titleText('Account'),
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
                width: 15,
              ),
            ],
          ),
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
                  detailData('Name:', '名前'),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Total records:',
                    style: TextStyle(color: Color(0xFF1B263B)),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: FutureBuilder<String>(
                        future: DatabaseHelper.instance.getTotal(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.hasError) {
                            return const Text('error');
                          }

                          final data = snapshot.data;
                          if (data!.isEmpty) {
                            return const SizedBox();
                          }

                          return Text(data);
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Total by Tag:',
                    style: TextStyle(color: Color(0xFF1B263B)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: myTagColor['tagRed'],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: tagTotal('tagRed'),
                            )),
                        Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: myTagColor['tagPink'],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: tagTotal('tagPink'),
                            )),
                        Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: myTagColor['tagBlue'],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: tagTotal('tagBlue'),
                            )),
                        Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: myTagColor['tagGreen'],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: tagTotal('tagGreen'),
                            )),
                        Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: myTagColor['tagYellow'],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: tagTotal('tagYellow'),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )),
          const SizedBox(
            height: 50,
          ),
          Image.asset(
            'assets/images/bird_normal.png',
            width: 250,
            height: 250,
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
