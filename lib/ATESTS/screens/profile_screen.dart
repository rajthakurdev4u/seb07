import 'package:aft/ATESTS/models/AUser.dart';
import 'package:aft/ATESTS/other/ATextField.dart';
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
  // Data
  User? user;

  // UI
  bool isLoading = false;
  bool isEditingUsername = false;
  bool isEditingEmail = false;

  // Controllers
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    bool isSignedIn = user != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () async {
              await AuthMethods().signOut();
              Provider.of<UserProvider>(context, listen: false).logoutUser();
              goToLogin(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Text(
                isSignedIn ? 'LOGOUT' : 'LOGIN',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: isSignedIn
                    ? Column(
                        children: [
                          UserFieldListTile(
                            label: "Username",
                            value: user?.username,
                            textController: _userNameController,
                            isEditing: isEditingUsername,
                            onEdit: () {
                              _userNameController.text = user?.username ?? '';
                              isEditingUsername = true;
                              setState(() {});
                            },
                            onCancelEdit: () {
                              isEditingUsername = false;
                              setState(() {});
                            },
                            onSave: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              // Validates username
                              String? userNameValid = await usernameValidator(
                                  username: _userNameController.text);
                              if (userNameValid != null) {
                                showSnackBar(userNameValid, context);
                              } else {
                                bool authenticated =
                                    await performReAuthenticationAction(
                                        context: context);
                                if (authenticated) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await AuthMethods().changeUsername(
                                      username: _userNameController.text);
                                  UserProvider userProvider =
                                      Provider.of(context, listen: false);
                                  await userProvider.refreshUser();
                                  isEditingUsername = false;
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                          ),
                          UserFieldListTile(
                            label: "Email",
                            value: user?.email,
                            isEditing: isEditingEmail,
                            textController: _emailController,
                            onEdit: () {
                              _emailController.text = user?.email ?? '';
                              isEditingEmail = true;
                              setState(() {});
                            },
                            onCancelEdit: () {
                              isEditingEmail = false;
                              setState(() {});
                            },
                            onSave: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              bool authenticated =
                                  await performReAuthenticationAction(
                                      context: context);
                              if (authenticated) {
                                setState(() {
                                  isLoading = true;
                                });
                                var res = await AuthMethods()
                                    .changeEmail(email: _emailController.text);

                                if (res == 'success') {
                                  UserProvider userProvider =
                                      Provider.of(context, listen: false);
                                  await userProvider.refreshUser();
                                } else {
                                  showSnackBar(res, context);
                                }
                                isEditingEmail = false;
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                          ),
                        ],
                      )
                    : const Center(
                        child: Text(
                          'Please login first',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ),
            ),
          ),
          Positioned.fill(
              child: Visibility(
                  visible: isLoading,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    )),
                  ))),
        ],
      ),
    );
  }
}

class UserFieldListTile extends StatelessWidget {
  final String label;
  final String? value;
  final TextEditingController textController;
  final VoidCallback onEdit;
  final VoidCallback onCancelEdit;
  final VoidCallback onSave;
  final bool isEditing;

  const UserFieldListTile({
    super.key,
    required this.label,
    required this.value,
    required this.onEdit,
    required this.textController,
    required this.onCancelEdit,
    required this.onSave,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        bottom: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          isEditing
              ? Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFieldInputDone(
                          hintText: 'Enter new username',
                          textInputType: TextInputType.text,
                          textEditingController: textController,
                        ),
                      ),
                      IconButton(
                        onPressed: onSave,
                        icon: const Icon(
                          Icons.check_circle_outlined,
                          color: Colors.green,
                          size: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: onCancelEdit,
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                        child: Text(
                      value ?? '-',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                    InkWell(
                      onTap: onEdit,
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ),
                    )
                  ],
                ),
        ],
      ),
    );
  }
}
