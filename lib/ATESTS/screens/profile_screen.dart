import 'package:aft/ATESTS/models/AUser.dart';
import 'package:aft/ATESTS/other/AUtils.dart';
import 'package:aft/ATESTS/provider/AUserProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../authentication/ALogin.dart';
import '../methods/AAuthMethods.dart';

class ProfileScreen extends StatefulWidget {
// final String uid;
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    bool isUserLoggedIn = user != null;

    return Scaffold(
      body: InkWell(
        onTap: () async {
          if (isUserLoggedIn) {
            var val = await AuthMethods().signOut();
            Provider.of<UserProvider>(context, listen: false).logoutUser();
          }
          goToLogin(context);
        },
        child: Center(
          child: Text(
            isUserLoggedIn ? 'LOGOUT' : 'LOGIN',
            style: const TextStyle(color: Colors.blueAccent),
          ),
        ),
      ),
    );
  }
}
