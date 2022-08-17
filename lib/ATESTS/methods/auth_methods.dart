import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as model;
import '../utils/utils.dart';
import 'storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool idk = true;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  getUserProfileDetails(uid) async {
    DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();

    return model.User.fromSnap(snap);
  }

//sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String? bio,
    // required Uint8List file,
    required Uint8List? profilePicFile,
    required String country,
    required String isVerified,
    required String isPending,
  }) async {
    String res = "Some error occured";
    try {
      String trimmedBio = trimText(text: '');
      // if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty
      //     // file != null
      //     ) {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        // String photoUrl = await StorageMethods()
        //     .uploadImageToStorage('profilePics', file, false);
        // If profile pic is selected by user
        String? profilePicUrl;
        if (profilePicFile != null) {
          profilePicUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', profilePicFile, false);
        }

        //add user to our database

        model.User user = model.User(
          username: username,
          usernameLower: username.toLowerCase(),
          uid: cred.user!.uid,
          // photoUrl: photoUrl,
          dateCreated: DateTime.now(),
          photoUrl: profilePicUrl,
          email: email,
          country: country,
          isPending: isPending,
          bio: trimmedBio,
          profileFlag: 'false',
          profileBadge: 'false',
          // followers: [],
          // following: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "success";
      } else if (email.isEmpty || username.isEmpty || password.isEmpty) {
        res = "Input fields cannot be blank.";
      }
    }
    //IF YOU WANT TO PUT MORE DETAILS IN ERRORS
    on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email address is badly formatted.';
      } else if (err.code == 'email-already-in-use') {
        res = 'The email address is already in use by another account.';
      } else if (err.code == 'weak-password') {
        res = 'Password needs to be at least 6 characters long.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Future<void> updateProfPic(String uid, Uint8List? profilePicFile) async {
  //   try {
  //     String? profilePicUrl;
  //     if (profilePicFile != null) {
  //       profilePicUrl = await StorageMethods()
  //           .uploadImageToStorage('profilePics', profilePicFile, false);
  //     }
  //     await _firestore.collection('users').doc(uid).update(
  //       {'photoUrl': profilePicFile},
  //     );
  //   } catch (e) {
  //     print(
  //       e.toString(),
  //     );
  //   }
  // }

  //logging in user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error ocurred";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else if (email.isEmpty && password.isEmpty) {
        res = "Input fields cannot be blank.";
      } else if (email.isEmpty) {
        res = "Username/email input field cannot be blank.";
      } else if (password.isEmpty) {
        res = "Password input field cannot be blank.";
      }
    }

    //OTHER DETAILED ERRORS
    on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        res = "Too many login attempts, please try again later.";
      } else if (e.code == 'user-disabled') {
        res =
            "This account has been disabled. If you believe this was a mistake, please contact us at: email@gmail.com";
      } else if (e.code == 'user-not-found') {
        res = "No registered user found under these credentials";
        // } else if (e.code == 'invalid-email') {
        //   res = "No registered user found under this email address.";

      } else if (e.code == 'invalid-email' && !email.contains('@')) {
        res = "No registered user found under these credentials.";
      } else if (e.code == 'wrong-password') {
        res = "Wrong password!";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> changeUsername({
    required String username,
  }) async {
    try {
      User currentUser = _auth.currentUser!;
      await _firestore.collection('users').doc(currentUser.uid).update(
        {
          'username': username,
          'usernameLower': username.toLowerCase(),
        },
      );
    } catch (err) {}
  }

  Future<void> changeBio({
    required String? bio,
  }) async {
    try {
      User currentUser = _auth.currentUser!;
      await _firestore.collection('users').doc(currentUser.uid).update(
        {'bio': bio},
      );
    } catch (err) {}
  }

  changeProfileFlag({
    required String profileFlag,
  }) async {
    try {
      User currentUser = _auth.currentUser!;
      await _firestore.collection('users').doc(currentUser.uid).update(
        {'profileFlag': profileFlag},
      );
    } catch (err) {}
  }

  changeProfileBadge({
    required String profileBadge,
  }) async {
    try {
      User currentUser = _auth.currentUser!;
      await _firestore.collection('users').doc(currentUser.uid).update(
        {'profileBadge': profileBadge},
      );
    } catch (err) {}
  }

  changeIsPending({
    required String isPending,
  }) async {
    try {
      User currentUser = _auth.currentUser!;
      await _firestore.collection('users').doc(currentUser.uid).update(
        {'isPending': isPending},
      );
    } catch (err) {}
  }

  Future<String> changeProfilePic({
    required String? profilePhotoUrl,
  }) async {
    String res = "Some error ocurred";
    try {
      User currentUser = _auth.currentUser!;
      await _firestore.collection('users').doc(currentUser.uid).update(
        {'photoUrl': profilePhotoUrl},
      );

      res = "success";
    } catch (e) {
      print(
        e.toString(),
      );
    }
    return res;
  }

  Future<String> changeEmail({
    required String email,
  }) async {
    String res = "Some error ocurred";
    try {
      User currentUser = _auth.currentUser!;
      await currentUser.updateEmail(email);
      await _firestore.collection('users').doc(currentUser.uid).update(
        {'email': email},
      );
      res = "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = "Please enter a valid email address.";
      } else if (e.code == 'email-already-in-use') {
        res = "This email is already in use.";
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteUser(String uid) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await _firestore.collection('users').doc(uid).delete();
      if (user != null) {
        await user.delete();
      }
    } catch (err) {
      print(err.toString());
    }
  }
}
