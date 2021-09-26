import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_barberapp/model/image_model.dart';
import 'package:flutter_barberapp/utils/utils.dart';

Future<List<ImageModel>> getBanners() async{
  List<ImageModel> result = new List<ImageModel>.empty(growable: true);
  
/*  FirebaseFirestore.instance
  .collection('Banner')
  .get()
  .then((value) {
    value.docs.forEach((element) {
      result.add(ImageModel.fromJson(element.data()));
      print('BannerData: ${element.data()}');
    });
  }).catchError((onError){
    print(onError.toString());
  });
  return result;*/
  CollectionReference bannerRef = FirebaseFirestore.instance.collection(BANNER_COLLECTION);
  QuerySnapshot snapshot = await bannerRef.get();
  snapshot.docs.forEach((element) {
    final data  = element.data() as Map<String,dynamic>;

    result.add(ImageModel.fromJson(data));
    print('BannerData: ${element.data()}');

  });
  return result;
}
