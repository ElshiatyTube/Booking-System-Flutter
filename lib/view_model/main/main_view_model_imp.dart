import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/scaffold.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import 'package:flutter_barberapp/cloud_firestore/user_ref.dart';
import 'package:flutter_barberapp/shared/styles/commponents/commponents.dart';
import 'package:flutter_barberapp/shared/styles/icon_broken.dart';
import 'package:flutter_barberapp/ui/commponents/user_widgets/register_dialog.dart';
import 'package:flutter_barberapp/utils/utils.dart';
import 'package:flutter_barberapp/view_model/main/main_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_barberapp/state/state_managment.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MainViewModelImp implements MainViewModel{
  @override
  Future<LOGIN_STATE> checkLoginState(BuildContext context, bool fromLogin,
      GlobalKey<ScaffoldState> scaffoldState) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    print('Crrrrr: ${currentUser}');

    if(currentUser!=null)
      {
        if (!context.read(forceReload).state) {

          await Future.delayed(Duration(seconds: fromLogin == true ? 0 : 3))
              .then((value) {

            FirebaseAuth.instance.currentUser!.getIdToken().then((token) async {
              print('UserTokenddddd');
              //Force reload state
              context.read(forceReload).state = true;

              print('UserToken $token');
              context.read(userToken).state = token;
              //check user in Firestore
              CollectionReference userRef =
              FirebaseFirestore.instance.collection(USER_COLLECTION);
              DocumentSnapshot snapshotUser = await userRef
                  .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
                  .get();


              if (snapshotUser.exists) {
                getUserProfiles(context,FirebaseAuth.instance.currentUser!.phoneNumber!).then((value) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (route) => false);
                });

              } else {
                showRegisterDialog(context,userRef,scaffoldState);
              }
            }).catchError((onError) {});
          });
        }
      }

    return  currentUser != null
        ? LOGIN_STATE.LOGGED
        : LOGIN_STATE.NOT_LOGIN;


  }

  @override
    processLogin(BuildContext context ,GlobalKey<ScaffoldState> scaffoldState) {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      FlutterAuthUi.startUi(
          items: [AuthUiProvider.phone],
          tosAndPrivacyPolicy: TosAndPrivacyPolicy(
            tosUrl: 'https://google.com',
            privacyPolicyUrl: 'https://google.com',
          ),
          androidOption: AndroidOption(
              enableSmartLock: false, showLogo: true, overrideTheme: true))
          .then((value) async {
        //Refrsh State
        context.read(userLogged).state = FirebaseAuth.instance.currentUser;
        //Start new Screen
        await checkLoginState(context, true, scaffoldState);
      }).catchError((onError) {
        showSnackBarScaffold(
            scaffoldState.currentContext!, '${onError.toString()}');
      });
    } else {
      //user login , start home

    }
  }

}