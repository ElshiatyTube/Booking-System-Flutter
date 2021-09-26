import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barberapp/utils/utils.dart';

abstract class MainViewModel{
  void processLogin(BuildContext context,GlobalKey<ScaffoldState> scaffoldKey);

  Future<LOGIN_STATE> checkLoginState(BuildContext context, bool fromLogin,
      GlobalKey<ScaffoldState> scaffoldState);
}