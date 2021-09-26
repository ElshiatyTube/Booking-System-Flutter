import 'package:flutter/cupertino.dart';
import 'package:flutter_barberapp/model/image_model.dart';
import 'package:flutter_barberapp/model/user_model.dart';
import 'package:flutter/material.dart';

abstract class HomeViewModel{
  Future<UserModel> displayUserProfile(BuildContext context,String phoneNumber);
  Future<List<ImageModel>> displayBanner();
  Future<List<ImageModel>> displayLookbook();

  bool isStaff(BuildContext context);

}
