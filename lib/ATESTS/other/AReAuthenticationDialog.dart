import 'package:aft/ATESTS/methods/AAuthMethods.dart';
import 'package:aft/ATESTS/models/AUser.dart';
import 'package:aft/ATESTS/provider/AUserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ATextField.dart';

class ReAuthenticationDialog extends StatefulWidget {
  const ReAuthenticationDialog({Key? key}) : super(key: key);

  @override
  State<ReAuthenticationDialog> createState() => _ReAuthenticationDialogState();
}

class _ReAuthenticationDialogState extends State<ReAuthenticationDialog> {
  bool _isLoading = false;
  bool _authenticationFailed = false;
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: double.infinity,
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.44,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            padding: const EdgeInsets.fromLTRB(10, 45, 10, 0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 14.0,
                  ),
                  child: Text('Authentication Required',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 0.0),
                  child: Text('Please re-authenticate yourself first.',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 36.0,
                      bottom: 10,
                      left: 10,
                      right: 10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: _authenticationFailed,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error,
                                    size: 16,
                                    color: Color.fromARGB(255, 220, 105, 96)),
                                Container(width: 4),
                                Text('Authentication failed.',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 220, 105, 96))),
                              ],
                            ),
                          ),
                        ),
                        TextFieldInputDone(
                          hintText: 'Enter your password',
                          textInputType: TextInputType.text,
                          textEditingController: passwordController,
                          isPass: true,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: InkWell(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        _isLoading = true;
                      });

                      final User? user =
                          Provider.of<UserProvider>(context, listen: false)
                              .getUser;
                      print('user?.email: ${user?.email}');
                      print(
                          'passwordController.text: ${passwordController.text}');
                      String res = await AuthMethods().loginUser(
                        email: user?.email ?? '',
                        password: passwordController.text,
                      );

                      if (res == "success") {
                        setState(() {
                          _authenticationFailed = false;
                          _isLoading = false;
                        });
                        Navigator.pop(context, true);
                      } else {
                        setState(() {
                          _authenticationFailed = true;
                          _isLoading = false;
                        });
                      }
                    },
                    child: Card(
                      elevation: 3,
                      child: Container(
                        width: MediaQuery.of(context).size.height * 0.250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blueGrey,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('AUTHENTICATE',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Container(width: 10),
                                  Icon(Icons.login,
                                      size: 22, color: Colors.white)
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -50,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: FittedBox(
                child: RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    Icons.info,
                    size: 200,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
