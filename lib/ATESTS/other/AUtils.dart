import 'package:aft/ATESTS/authentication/ALogin.dart';
import 'package:aft/ATESTS/models/AUser.dart';
import 'package:aft/ATESTS/provider/AUserProvider.dart';
import 'package:aft/ATESTS/responsive/AMobileScreenLayout.dart';
import 'package:aft/ATESTS/responsive/AResponsiveScreenLayout.dart';
import 'package:aft/ATESTS/responsive/AWebScreenLayout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  print("No image selected");
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

void goToLogin(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ),
    (route) => false,
  );
}


void goToHome(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        )),
        (route) => false,
  );
}

// Checks whether user is logged in
performLoggedUserAction({
  required BuildContext context,
  required Function action,
}) {
  final User? user = Provider.of<UserProvider>(context, listen: false).getUser;
  if (user != null) {
    action();
  } else {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('ALERT'),
            content: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('You need to login first!!'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  goToLogin(context);
                },
                child: const Text("LOGIN"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("CANCEL"),
              ),
            ],
          );
        });
  }
}
