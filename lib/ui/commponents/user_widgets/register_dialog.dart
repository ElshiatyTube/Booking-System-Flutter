import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barberapp/shared/styles/commponents/commponents.dart';
import 'package:flutter_barberapp/shared/styles/icon_broken.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void showRegisterDialog(BuildContext context,CollectionReference userRef,GlobalKey<ScaffoldState> scaffoldKey)
{
  //If user not exist in Firestore
  //Create account
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  Alert(
      context: context,
      title: 'Profile Info',
      content: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              icon: Icon(Iconly_Broken.User),
              labelText: 'Name',
            ),
            controller: nameController,
          ),
          TextField(
            decoration: const InputDecoration(
              icon: Icon(Iconly_Broken.Location),
              labelText: 'Address',
            ),
            controller: addressController,
          ),
        ],
      ),
      buttons: [
        DialogButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context)),
        DialogButton(
            child: const Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              //Update to firestore
              userRef
                  .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
                  .set({
                'name': nameController.text,
                'address': addressController.text
              }).then((value) {
                Navigator.pop(context);
                showSnackBarScaffold(scaffoldKey.currentContext,
                    'Update Profile Info Successfully');

                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false);
              }).catchError((onError) {
                Navigator.pop(context);
                showSnackBarScaffold(scaffoldKey.currentContext,
                    'Error: ${onError}');
              });
            }),
      ]).show();
}