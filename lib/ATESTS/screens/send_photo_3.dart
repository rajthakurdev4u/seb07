import 'package:flutter/material.dart';

class SendPhotoThree extends StatefulWidget {
  const SendPhotoThree({Key? key}) : super(key: key);

  @override
  State<SendPhotoThree> createState() => _SendPhotoThreeState();
}

class _SendPhotoThreeState extends State<SendPhotoThree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {},
          child: Container(
            width: 200,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Send two photos',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5)),
                Container(width: 6),
                Icon(
                  Icons.send,
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
                color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
