import 'dart:convert';

import 'package:aft/ATESTS/models/AUser.dart';
import 'package:aft/ATESTS/other/AUtils.dart';
import 'package:aft/ATESTS/provider/AUserProvider.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
                  // sendEmail(
                  //   name: user?.username ?? '',
                  //   email: user?.email ?? '',
                  //   subject: 'From Admin',
                  //   message: 'one',
                  // );
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
                    receiverName: user?.username ?? '',
                    // receiverEmail: user?.email ?? '',
                    receiverEmail: 'rjjin.19@gmail.com',
                    senderEmail: 'rajthakur.dev4u@gmail.com',
                    senderName: 'Raj Thakur',
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

  Future sendEmail({
    // Sender
    required String senderName,
    required String senderEmail,

    // Receiver
    required String receiverName,
    required String receiverEmail,

    // Email
    required String subject,
    required String message,
  }) async {
    var url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    var response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-type': 'application/json',
      },
      body: jsonEncode({
        'service_id': 'service_61dg2wq',
        'template_id': 'template_qsler7e',
        'user_id': 'mNBhdn2YkFbAHdmzY',
        'template_params': {
          'sender_name': senderName,
          'sender_email': senderEmail,
          'receiver_name': receiverName,
          'receiver_email': receiverEmail,
          'subject': subject,
          'message': message,
        }
      }),
    );

    print('response: ${response.body}');
    showSnackBar('Email sent successfully to $receiverEmail.', context);
  }
}
