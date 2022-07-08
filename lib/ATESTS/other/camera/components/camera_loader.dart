import 'package:flutter/material.dart';

class CameraLoader extends StatelessWidget {
  const CameraLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Colors.white,
      child: Center(
        child: Icon(
          Icons.camera_alt_outlined,
          size: 42,
          color: Colors.grey.shade200,
        ),
      ),
    );
  }
}
