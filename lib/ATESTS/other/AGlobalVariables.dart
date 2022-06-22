import 'package:aft/ATESTS/methods/AAuthMethods.dart';
import 'package:flutter/material.dart';
import '../screens/AHome.dart';

const webScreenSize = 600;

var homeScreenItems = [
  const MyHomeScreen(),
  Column(
    children: [
      const Text('profile'),
      Expanded(
          child: Center(
        child: TextButton(
            onPressed: () async {
              await AuthMethods().signOut();
            },
            child: const Text('LOGOUT')),
      ))
    ],
  )
];
