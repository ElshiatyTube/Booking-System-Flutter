import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barberapp/model/image_model.dart';
import 'package:flutter_barberapp/utils/utils.dart';

Future<List<ImageModel>> getLookBook() async{
  List<ImageModel> result = new List<ImageModel>.empty(growable: true);

  CollectionReference lookbookRef = FirebaseFirestore.instance.collection(LOOKBOOK_COLLECTION);
  QuerySnapshot snapshot = await lookbookRef.get();
  snapshot.docs.forEach((element) {
    final data  = element.data() as Map<String,dynamic>;

    result.add(ImageModel.fromJson(data));
    print('LookBookDataaaaa: ${element.data()}');

  });
  return result;

  FirebaseFirestore.instance
      .collection('Lookbook')
      .get()
      .then((value) {
    value.docs.forEach((element) {
      result.add(ImageModel.fromJson(element.data()));
      print('Lookbook: ${element.data()}');
    });
  }).catchError((onError){
    print(onError.toString());
  });
  return result;

}