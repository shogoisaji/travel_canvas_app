import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:travel_canvas/application/config/date_format.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_canvas/application/feature/custom_marker.dart';
import 'package:travel_canvas/application/feature/database.dart';
import 'package:travel_canvas/application/feature/location_service.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:travel_canvas/application/state/state.dart';
import 'package:travel_canvas/presentation/theme/tag.dart';
import 'package:travel_canvas/presentation/theme/theme.dart';

class RecordPage extends HookConsumerWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MyTheme myTheme = MyTheme();
    Map<String, Color> myTagColor = MyTag().tagColor;
    String currentDate = getCurrentDate();
    final commentController = useTextEditingController();
    final imageFile = ref.watch(imageFileProvider);
    final bool isLoading = ref.watch(loadingStateProvider);
    final String tagSelected = ref.watch(tagSelectedProvider);
    final saveLocation = ref.watch(saveLocationProvider);

    final _screenSize = MediaQuery.of(context).size;

// ImagePickerを使って画像選択
    Future<File?> pickImage() async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
        return null;
      }
    }

    return Stack(
      children: [
        SingleChildScrollView(
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
                  Text('Record', style: myTheme.subTitle),
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
// image
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                decoration: BoxDecoration(
                  color: myTheme.grey,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Photo'),
                        IconButton(
                            onPressed: () async {
                              File? file = await pickImage();
                              if (file != null) {
                                ref
                                    .read(imageFileProvider.notifier)
                                    .chageFile(file);
                              }
                            },
                            icon: const Icon(Icons.camera_alt_rounded),
                            padding: const EdgeInsets.all(5),
                            iconSize: 36,
                            color: myTheme.darkNavy),
                      ],
                    ),
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        height:
                            ref.watch(imageFileProvider) != null ? 500 : 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(imageFile,
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.fill))
                            : const Text('No Image',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
// comment
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                decoration: BoxDecoration(
                  color: myTheme.grey,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Comment'),
                    Container(
                      height: 170,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: commentController,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 15,
                        decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.blue))),
                      ),
                    ),
                  ],
                ),
              ),

// tag
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                  color: myTheme.grey,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tag'),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(tagSelectedProvider.notifier)
                                      .changeTag('tagRed');
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: myTagColor['tagRed'],
                                      borderRadius: BorderRadius.circular(8),
                                      border: tagSelected == 'tagRed'
                                          ? Border.all(
                                              color: myTheme.darkNavy, width: 4)
                                          : null),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(tagSelectedProvider.notifier)
                                      .changeTag('tagPink');
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: myTagColor['tagPink'],
                                      borderRadius: BorderRadius.circular(8),
                                      border: tagSelected == 'tagPink'
                                          ? Border.all(
                                              color: myTheme.darkNavy, width: 4)
                                          : null),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(tagSelectedProvider.notifier)
                                      .changeTag('tagBlue');
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: myTagColor['tagBlue'],
                                      borderRadius: BorderRadius.circular(8),
                                      border: tagSelected == 'tagBlue'
                                          ? Border.all(
                                              color: myTheme.darkNavy, width: 4)
                                          : null),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(tagSelectedProvider.notifier)
                                      .changeTag('tagGreen');
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: myTagColor['tagGreen'],
                                      borderRadius: BorderRadius.circular(8),
                                      border: tagSelected == 'tagGreen'
                                          ? Border.all(
                                              color: myTheme.darkNavy, width: 4)
                                          : null),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(tagSelectedProvider.notifier)
                                      .changeTag('tagYellow');
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: myTagColor['tagYellow'],
                                      borderRadius: BorderRadius.circular(8),
                                      border: tagSelected == 'tagYellow'
                                          ? Border.all(
                                              color: myTheme.darkNavy, width: 4)
                                          : null),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
// Tagの小さいbird
                    Positioned(
                      right: 15,
                      child: Image.asset(
                        'assets/images/bird_$tagSelected.png',
                        width: 45,
                        height: 45,
                      ),
                    ),
                  ],
                ),
              ),

// save location
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                  color: myTheme.grey,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Location'),
                        Row(
                          children: [
                            saveLocation
                                ? Text('Save',
                                    style: TextStyle(color: myTheme.darkRed))
                                : Text('NoSave',
                                    style: TextStyle(color: myTheme.blueGrey)),
                            const SizedBox(
                              width: 5,
                            ),
                            Transform.scale(
                              scale: 1.5,
                              child: Switch(
                                value: saveLocation,
                                onChanged: (saveLocation) {
                                  ref
                                      .read(saveLocationProvider.notifier)
                                      .changeState(saveLocation);
                                },
                                activeTrackColor: myTheme.lightBrown,
                                activeColor: myTheme.darkRed,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
// button
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  // Save時のaction
                  onPressed: () async {
                    if (imageFile != null) {
                      ref.read(loadingStateProvider.notifier).show();

                      // bitmapImageの作成、保存
                      final fileName = p.basename(imageFile.path).split('.')[0];
                      CustomMarker marker =
                          CustomMarker(imageFile.path, fileName);
                      final customMakerPath =
                          await marker.customMarker(tagSelected);

                      // map情報の取得
                      LocationService service = LocationService();
                      final currentAddress =
                          saveLocation ? await service.getAddress() : '';
                      final String currentPosition =
                          saveLocation ? await service.jsonPosition() : '';

                      // databaseへ保存
                      final imagePath = imageFile.path;
                      final List<String> addData = [
                        imagePath,
                        customMakerPath,
                        currentDate,
                        currentPosition,
                        currentAddress,
                        commentController.text,
                        tagSelected
                      ];
                      await DatabaseHelper.instance.addData(addData);
                      ref.read(loadingStateProvider.notifier).hide();
                      ref
                          .read(bottomNavigationStateProvider.notifier)
                          .changeIndex(0);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: const Color(0xFFD9D9D9),
                            icon: Icon(Icons.error_outline_rounded,
                                size: 56, color: myTheme.darkNavy),
                            content: Text("写真撮影は\n必須です",
                                style: TextStyle(
                                    color: myTheme.darkNavy,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w400)),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(10),
                                  backgroundColor: myTheme.blueGrey,
                                ),
                                child: const Text("OK",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w400)),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    fixedSize: const Size(150, 50),
                    backgroundColor: myTheme.lightBrown,
                  ),
                  child: Text('Save',
                      style: TextStyle(
                          fontSize: 26,
                          color: myTheme.darkNavy,
                          fontWeight: FontWeight.w600))),
              const SizedBox(
                height: 105,
              )
            ],
          ),
        ),
        if (isLoading)
          Container(
            height: _screenSize.height,
            width: _screenSize.width,
            decoration: const BoxDecoration(color: Colors.black54),
            child: const Center(
              child: SizedBox(
                  width: 50, height: 50, child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
