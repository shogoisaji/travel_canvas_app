import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:io';

part 'state.g.dart';

// BottomNavigation Page Index
@riverpod
class BottomNavigationState extends _$BottomNavigationState {
  @override
  int build() => 0;

  void changeIndex(int index) => state = index;
}

// location loading state
@riverpod
class LocationLoading extends _$LocationLoading {
  @override
  bool build() => false;

  void startLoading() => state = true;
  void doneLoading() => state = false;
}

//画像保持
@riverpod
class ImageFile extends _$ImageFile {
  @override
  File? build() => null;

  void chageFile(File? file) {
    state = file;
  }
}

// DetailPage データ渡し
@riverpod
class DetailPageState extends _$DetailPageState {
  @override
  Map<String, dynamic>? build() => null;

  void setState(Map<String, dynamic> mapData) => state = mapData;
}

// Loading
@riverpod
class LoadingState extends _$LoadingState {
  @override
  bool build() => false;

  void show() => state = true;

  void hide() => state = false;
}

// tag selected
@riverpod
class TagSelected extends _$TagSelected {
  @override
  String build() => 'tagRed';

  void changeTag(String tag) => state = tag;
}

// DetailPage tag selected
@riverpod
class DetailTagSelectShow extends _$DetailTagSelectShow {
  @override
  bool build() => false;

  void show() => state = true;
  void hide() => state = false;
}

// save location state
@riverpod
class SaveLocation extends _$SaveLocation {
  @override
  bool build() => true;

  void changeState(bool) {
    state = bool;
  }
}

// location tag sort state
@riverpod
class SortTagMarker extends _$SortTagMarker {
  @override
  String build() => 'tagAll';

  void changeTag(String tag) => state = tag;
}
