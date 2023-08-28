import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:travel_canvas/application/feature/database.dart';
import 'package:travel_canvas/application/feature/get_random_indices.dart';
import 'package:travel_canvas/presentation/theme/theme.dart';
import 'package:travel_canvas/presentation/widgets/gallery_image.dart';
import 'package:travel_canvas/presentation/widgets/list_card.dart';
import 'package:rive/rive.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myTheme = MyTheme();
    final Future<List<Map<String, dynamic>>>? dataFuture =
        useMemoized(() => DatabaseHelper.instance.queryLatestRows());

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: myTheme.grey,
            width: double.infinity,
            height: 160,
            padding: const EdgeInsets.only(bottom: 10),
            alignment: Alignment.bottomCenter,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                width: 50,
              ),
              Text('Travel\nCanvas', style: myTheme.mainTitle),
              SizedBox(
                width: 90,
                height: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const RiveAnimation.asset('assets/rive/fly_bird.riv'),
                ),
              ),
            ]),
          ),

          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Text('Gallery', style: myTheme.subTitle),
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
          const SizedBox(height: 20),
// Gallery
          SizedBox(
            height: 350,
            child: FutureBuilder<List<Map<String, dynamic>>?>(
                future: dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator()));
                  }

                  if (snapshot.hasError) {
                    return const Text('エラーが発生しました');
                  }

                  final data = snapshot.data;
                  if (data!.isEmpty) {
                    return const SizedBox(
                      height: 300,
                    );
                  }
                  final dataLength = data.length > 5 ? 5 : data.length;
                  final randomList = getRandomIndices(dataLength);

                  return SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: PageView.builder(
                      controller: PageController(viewportFraction: 0.9),
                      itemCount: randomList.length,
                      itemBuilder: (c, i) => galleryImage(
                          data[randomList[i]][DatabaseHelper.columnImage]),
                    ),
                  );
                }),
          ),
// Recently
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Text('Recently', style: myTheme.subTitle),
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
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            height: 380,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator()));
                }
                if (snapshot.hasError) {
                  return const Text('エラーが発生しました');
                }
                final data = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length > 3 ? 3 : data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return listCard(context, item, ref);
                  },
                );
              },
            ),
          ),
          Container(
            height: 100,
          ),
        ],
      ),
    );
  }
}
