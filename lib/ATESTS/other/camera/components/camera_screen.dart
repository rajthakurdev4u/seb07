import 'dart:async';
import 'dart:io';
import 'package:aft/ATESTS/other/AUtils.dart';
import 'package:aft/ATESTS/other/camera/components/preview.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'camera_loader.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    Key? key,
    required this.camera,
    required this.secondaryCamera,
  }) : super(key: key);

  final CameraDescription camera;
  final CameraDescription? secondaryCamera;

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  // Controllers
  late CameraDescription selectedCamera;
  final StreamController<bool> _isCapturingStreamController =
      StreamController<bool>.broadcast();
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    selectedCamera = widget.camera;
    _setDefaults();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a picture',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  color: Colors.black,
                  width: getScreenSize(context: context).width,
                  height: getScreenSize(context: context).height,
                ),
                CameraPreview(
                  _controller,
                  child: Positioned(
                    bottom: 20,
                    left: -1,
                    right: -1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Container()),
                        Align(
                          alignment: Alignment.center,
                          child: StreamBuilder<bool>(
                            initialData: false,
                            stream: _isCapturingStreamController.stream,
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshot) {
                              bool _isCapturing = snapshot.data ?? false;

                              return CircularOutlinedIconButton(
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 36,
                                ),
                                onTap: _isCapturing
                                    ? () {}
                                    : () async {
                                        _onCapture(context: context);
                                      },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Visibility(
                                visible: widget.secondaryCamera != null,
                                child: CircularOutlinedIconButton(
                                  icon: const Icon(
                                    Icons.cameraswitch_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  onTap: () {
                                    selectedCamera =
                                        selectedCamera == widget.camera
                                            ? widget.secondaryCamera!
                                            : widget.camera;
                                    _setDefaults();
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const CameraLoader();
          }
        },
      ),
    );
  }

  // Methods

  // Set defaults
  void _setDefaults() {
    _controller = CameraController(
      selectedCamera,
      ResolutionPreset.max,
    );

    _initializeControllerFuture = _controller.initialize();
    _isCapturingStreamController.sink.add(false);
  }

  // Disposes controllers
  void _dispose() {
    _controller.dispose();
    _isCapturingStreamController.close();
  }

  // On capture
  void _onCapture({required BuildContext context}) async {
    _isCapturingStreamController.sink.add(true);
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await _controller.takePicture();

      _isCapturingStreamController.sink.add(false);

      // If the picture was taken, display it on a new screen.
      bool? selected = await Navigator.of(
        context,
      ).push<bool>(CupertinoPageRoute(builder: (BuildContext context) {
        return PreviewPictureScreen(
          imagePath: image.path,
        );
      }));

      // If photo is  selected return it
      if (selected ?? false) {
        Navigator.pop(context, [File(image.path)]);
      }
    } catch (e) {
      // If an error occurs, log the error to the console.
      // showAlert(
      //   context: context,
      //   titleText: Localization.of(context).trans(LocalizationValues.error),
      //   message: '$e',
      //   actionCallbacks: {
      //     Localization.of(context).trans(LocalizationValues.ok): () {}
      //   },
      // );
      _isCapturingStreamController.sink.add(false);
    }
  }
}

class CircularOutlinedIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;
  final String? label;
  final Color? borderColor;

  const CircularOutlinedIconButton({
    Key? key,
    required this.onTap,
    required this.icon,
    this.label,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          shape: CircleBorder(
            side: BorderSide(
              color: borderColor ?? Colors.white,
              width: 2.0,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: icon,
            ),
          ),
        ),
        Visibility(
          visible: label != null,
          child: Text(label ?? ''),
        ),
      ],
    );
  }
}

