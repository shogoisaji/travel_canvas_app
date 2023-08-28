import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_canvas/application/state/state.dart';
import 'package:travel_canvas/pages/account_page.dart';
import 'package:travel_canvas/pages/detail_page.dart';
import 'package:travel_canvas/pages/history_page.dart';
import 'package:travel_canvas/pages/home_page.dart';
import 'package:travel_canvas/pages/record_page.dart';
import 'package:travel_canvas/pages/your_map_page.dart';
import 'package:travel_canvas/presentation/theme/theme.dart';
import 'package:travel_canvas/presentation/widgets/custom_bottom_navigation%20.dart';

void main() {
  const app = MyApp();
  const scope = ProviderScope(child: app);
  runApp(scope);
}

const screens = [
  HomePage(),
  RecordPage(),
  HistoryPage(),
  YourMapPage(),
  AccountPage(),
  DetailPage(),
];

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MyTheme myTheme = MyTheme();
    final int selectedIndex = ref.watch(bottomNavigationStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel Canvas',
      theme: ThemeData(
          scaffoldBackgroundColor: myTheme.blueGrey,
          textTheme: TextTheme(
            bodyMedium: myTheme.bodyText,
          )),
      home: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            extendBody: true,
            body: screens[selectedIndex],
            bottomNavigationBar: customBottomNavigation(context, ref)),
      ),
    );
  }
}
