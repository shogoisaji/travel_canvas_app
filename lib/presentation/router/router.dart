import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:travel_canvas/pages/account_page.dart';
import 'package:travel_canvas/pages/detail_page.dart';
import 'package:travel_canvas/pages/home_page.dart';
import 'package:travel_canvas/pages/record_page.dart';
import 'package:travel_canvas/pages/your_map_page.dart';

part 'router.g.dart';

class PagePath {
  static const home = '/home';
  static const record = '/record';
  static const history = '/history';
  static const yourMap = '/yourMap';
  static const account = '/account';
  static const detail = '/detail';
}

@riverpod
GoRouter router(RouterRef ref) {
  final routes = [
    GoRoute(
      path: PagePath.home,
      builder: (_, __) => HomePage(),
    ),
    GoRoute(
      path: PagePath.record,
      builder: (_, __) => RecordPage(),
    ),
    GoRoute(
      path: PagePath.yourMap,
      builder: (_, __) => YourMapPage(),
    ),
    GoRoute(
      path: PagePath.account,
      builder: (_, __) => AccountPage(),
    ),
    GoRoute(
      path: PagePath.detail,
      builder: (_, __) => DetailPage(),
    ),
  ];

  // GoRouterを作成
  return GoRouter(
    initialLocation: PagePath.home,
    routes: routes,
  );
}
