import 'dart:io';
import 'package:aft/ATESTS/other/AUtils.dart';
import 'package:flutter/material.dart';
import 'camera_loader.dart';
import 'camera_screen.dart';

class PreviewPictureScreen extends StatelessWidget {
  final String imagePath;
  final bool? previewOnly;

  const PreviewPictureScreen({
    Key? key,
    required this.imagePath,
    this.previewOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          const CameraLoader(),
          Align(
            alignment: Alignment.topCenter,
            child: Stack(
              children: [
                Center(
                  child: Image.file(
                    File(imagePath),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: -1,
                  right: -1,
                  child: Offstage(
                    offstage: previewOnly ?? false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularOutlinedIconButton(
                            borderColor: Colors.red,
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.red,
                              size: 36,
                            ),
                            onTap: () {
                              Navigator.pop(context, false);
                            },
                          ),
                          SizedBox(
                              width:
                                  getScreenSize(context: context).width * 0.15),
                          CircularOutlinedIconButton(
                            borderColor: Colors.green,
                            icon: const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 36,
                            ),
                            onTap: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
