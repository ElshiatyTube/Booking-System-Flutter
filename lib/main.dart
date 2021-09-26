import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import 'package:flutter_barberapp/model/booking_model.dart';

import 'package:flutter_barberapp/shared/styles/commponents/commponents.dart';
import 'package:flutter_barberapp/shared/styles/icon_broken.dart';
import 'package:flutter_barberapp/shared/styles/themes.dart';
import 'package:flutter_barberapp/state/state_managment.dart';
import 'package:flutter_barberapp/ui/userScreens/booking_screen.dart';
import 'package:flutter_barberapp/ui/userScreens/home_screen.dart';
import 'package:flutter_barberapp/ui/staffScreens/done_service_screen.dart';
import 'package:flutter_barberapp/ui/staffScreens/staff_home_screen.dart';
import 'package:flutter_barberapp/ui/userScreens/user_history_screen.dart';
import 'package:flutter_barberapp/utils/utils.dart';
import 'package:flutter_barberapp/view_model/main/main_view_model.dart';
import 'package:flutter_barberapp/view_model/main/main_view_model_imp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'cloud_firestore/user_ref.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase
  await Firebase.initializeApp();
 User? userToken = await FirebaseAuth.instance.currentUser;
  print('MyToken: ${userToken}');
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /* SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
    ));*/
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: (settings) {
        final userBookings_arguments = settings.arguments;
        switch (settings.name) {
          case '/home':
            return PageTransition(
              settings: settings,
              child: HomePage(),
              type: PageTransitionType.fade,
            );
            break;
          case '/history':
            return PageTransition(
              settings: settings,
              child: UserHistory(userBookings_arguments as List<BookingModel>),
              type: PageTransitionType.fade,
            );
            break;
          case '/booking':
            return PageTransition(
              settings: settings,
              child: BookingScreen(),
              type: PageTransitionType.fade,
            );
            break;

          //Staff
          case '/staffHome':
            return PageTransition(
              settings: settings,
              child: StaffHomeScreen(),
              type: PageTransitionType.fade,
            );
            break;
          case '/doneService':
            return PageTransition(
              settings: settings,
              child: DoneServiceScreen(),
              type: PageTransitionType.fade,
            );
            break;
          default:
            return null;
        }
      },
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  final scaffoldState = GlobalKey<ScaffoldState>();

  final mainViewModel = MainViewModelImp();


  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
          key: scaffoldState,
          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/my_bg.png'),
              fit: BoxFit.cover,
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder<LOGIN_STATE>(
                    future: mainViewModel.checkLoginState(context, false, scaffoldState),
                    builder: (context,  AsyncSnapshot<LOGIN_STATE> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      else if(snapshot.hasError) return Text('Error${snapshot.error}');
                      else {
                        print('LoginStatesasas ${snapshot.data.toString()}');
                       var userState = snapshot.data as LOGIN_STATE;
                        print('LoginStatesasasBool ${snapshot.data.toString()}');

                        if (userState == LOGIN_STATE.LOGGED) {
                          return Container();
                        } else {
                          //if user not login then return btn
                          return elevatedBtn(
                              iconData: Icons.phone,
                              function: () {
                                mainViewModel.processLogin(context,scaffoldState);
                              },
                              text: 'Login with phone');
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }




}
