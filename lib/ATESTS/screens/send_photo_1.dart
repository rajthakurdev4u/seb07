import 'dart:typed_data';

import 'package:aft/ATESTS/screens/send_photo_2.dart';
import 'package:aft/ATESTS/screens/send_photo_3.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../camera/camera_screen.dart';
import '../utils/utils.dart';

class SendPhoto extends StatefulWidget {
  const SendPhoto({Key? key}) : super(key: key);

  @override
  State<SendPhoto> createState() => _SendPhotoState();
}

class _SendPhotoState extends State<SendPhoto> {
  var cameraTitle = "1";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () async {
            Uint8List? file = await openCamera(
              context: context,
              cameraFileType: CameraFileType.image,
              add: "true",
            );

            print('SendPhoto file: ${file}');
            if(file != null) {
              emailAttachmentPhotos.clear();
              emailAttachmentPhotos.add(file);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                         SendPhotoTwo()
                        ),
              );
            }
          },
          child: Container(
            width: 200,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Open camera',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5)),
                Container(width: 6),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white,
                ),
              ],
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),

                // color: Color.fromARGB(255, 0, 144, 158),
                color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
