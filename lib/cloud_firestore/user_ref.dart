import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_barberapp/model/booking_model.dart';
import 'package:flutter_barberapp/model/user_model.dart';
import 'package:flutter_barberapp/state/state_managment.dart';
import 'package:flutter_barberapp/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<UserModel> getUserProfiles(BuildContext context,String phone) async{
  CollectionReference userRef = FirebaseFirestore.instance.collection(USER_COLLECTION);

  DocumentSnapshot snapshot = await userRef.doc(phone).get();
  if(snapshot.exists)
    {
      final data  = snapshot.data() as Map<String,dynamic>;

      var userModel = UserModel.fromJson(data);
      userModel.phone = snapshot.id;
      context.read(userInfo).state = userModel;
      return userModel;
    }
  else {
    return UserModel(name: '', address: '', phone: '');
  } //Empty Object
}

Future<List<BookingModel>> getUserHistory() async {
  var listBooking = new List<BookingModel>.empty(growable: true);
  var userRef = FirebaseFirestore.instance.collection(USER_COLLECTION)
  .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
  .collection('${BOOKING_COLLECTION}_${FirebaseAuth.instance.currentUser!.uid}');
  var snapshot = await userRef.orderBy('timeStamp',descending: true).get();
  snapshot.docs.forEach((element) {
    var booking = BookingModel.fromJson(element.data());
    booking.docId = element.id;
    booking.reference = element.reference;
    listBooking.add(booking);
  });
  print(listBooking.length);
  return listBooking;
}