import 'dart:io';

import 'package:aft/ATESTS/other/AUtils.dart';
import 'package:aft/ATESTS/other/camera/components/video_preview.dart';
import 'package:flutter/material.dart';
import 'camera_loader.dart';
import 'camera_screen.dart';

class PreviewPictureScreen extends StatefulWidget {
  final String filePath;
  final bool? previewOnly;
  final CameraFileType cameraFileType;

  const PreviewPictureScreen({
    Key? key,
    required this.filePath,
    this.previewOnly,
    required this.cameraFileType,
  }) : super(key: key);

  @override
  State<PreviewPictureScreen> createState() => _PreviewPictureScreenState();
}

class _PreviewPictureScreenState extends State<PreviewPictureScreen> {
  bool _captureImage = true;

  @override
  void initState() {
    print('filePath: ${widget.filePath}');
    _captureImage = widget.cameraFileType == CameraFileType.image;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview', style: TextStyle(color: Colors.white)),
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
                  child: _captureImage
                      ? Image.file(
                          File(widget.filePath),
                        )
                      : VideoPreview(filePath: widget.filePath),
                ),
                Positioned(
                  bottom: 20,
                  left: -1,
                  right: -1,
                  child: Offstage(
                    offstage: widget.previewOnly ?? false,
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
