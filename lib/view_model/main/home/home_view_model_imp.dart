import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barberapp/cloud_firestore/banner_ref.dart';
import 'package:flutter_barberapp/cloud_firestore/lookbook_ref.dart';
import 'package:flutter_barberapp/cloud_firestore/user_ref.dart';
import 'package:flutter_barberapp/model/image_model.dart';
import 'package:flutter_barberapp/model/user_model.dart';
import 'package:flutter_barberapp/view_model/main/home/home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_barberapp/state/state_managment.dart';

class HomeViewModelImp implements HomeViewModel{
  @override
  Future<List<ImageModel>> displayBanner() {
   return getBanners();
  }

  @override
  Future<List<ImageModel>> displayLookbook() {
    // TODO: implement displayLookbook
    return  getLookBook();
  }

  @override
  Future<UserModel> displayUserProfile(BuildContext context, String phoneNumber) {
    // TODO: implement displayUserProfile
   return getUserProfiles(context, phoneNumber);
  }

  @override
  bool isStaff(BuildContext context) {
    return context.read(userInfo).state.isStuff;
  }


}