import 'package:flutter/material.dart';
import 'package:travel_canvas/application/feature/database.dart';
import 'package:travel_canvas/presentation/theme/theme.dart';
import 'package:travel_canvas/presentation/widgets/list_card.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HistoryPage extends HookConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myTheme = MyTheme();
    final dataFuture =
        useMemoized(() => DatabaseHelper.instance.queryLatestRows());

    return Column(
      children: [
        const SizedBox(
          height: 60,
        ),
        Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            Text('History', style: myTheme.subTitle),
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
        Expanded(
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

              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 1),
                decoration: BoxDecoration(
                  border: Border.all(color: myTheme.darkNavy, width: 3),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black.withOpacity(0.2),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 15),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return listCard(context, item, ref);
                  },
                ),
              );
            },
          ),
        ),
        Container(
          height: 80,
        ),
      ],
    );
  }
}
