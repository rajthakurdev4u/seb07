import 'dart:convert';

import 'package:aft/ATESTS/models/AUser.dart';
import 'package:aft/ATESTS/other/AUtils.dart';
import 'package:aft/ATESTS/provider/AUserProvider.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportUserScreen extends StatefulWidget {
  const ReportUserScreen({Key? key}) : super(key: key);

  @override
  _ReportUserScreenState createState() => _ReportUserScreenState();
}

class _ReportUserScreenState extends State<ReportUserScreen> {
  User? user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 241, 241, 241),
          body: Column(
            children: [
              InkWell(
                onTap: () {
                  sendEmail(
                    context: context,
                    receiverName: user?.username ?? '',
                    receiverEmail: user?.email ?? '',
                    senderEmail: 'SENDER MAIL HERE',
                    senderName: 'SENDER NAME HERE',
                    subject: 'From Admin',
                    message: 'one',
                  );
                },
                child: Container(
                  color: Colors.blue,
                  width: 150,
                  height: 40,
                  child: Text('one'),
                ),
              ),
              InkWell(
                onTap: () {
                  sendEmail(
                    context: context,
                    receiverName: user?.username ?? '',
                    receiverEmail: user?.email ?? '',
                    senderEmail: 'SENDER MAIL HERE',
                    senderName: 'SENDER NAME HERE',
                    subject: 'From Admin',
                    message: 'two',
                  );
                },
                child: Container(
                  color: Colors.orange,
                  width: 150,
                  height: 40,
                  child: Text('two'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
