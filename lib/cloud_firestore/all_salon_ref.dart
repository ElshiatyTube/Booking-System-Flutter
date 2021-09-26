import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_barberapp/model/barber_model.dart';
import 'package:flutter_barberapp/model/booking_model.dart';
import 'package:flutter_barberapp/model/city_model.dart';
import 'package:flutter_barberapp/model/salon_model.dart';
import 'package:flutter_barberapp/shared/styles/commponents/commponents.dart';
import 'package:flutter_barberapp/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_barberapp/state/state_managment.dart';
import 'package:intl/intl.dart';


Future<List<CityModel>> getCities() async{
  var cities = new List<CityModel>.empty(growable: true);
  var cityRef = FirebaseFirestore.instance.collection(AllSALON_COLLECTION);
  var snapShot = await cityRef.get();
  snapShot.docs.forEach((element) {
    cities.add(CityModel.fromJson(element.data()));
  });
  return cities;
}

Future<List<SalonModel>> getSalonByCity(String cityName) async{
  var salons = new List<SalonModel>.empty(growable: true);
  var salonRef = FirebaseFirestore.instance.collection(AllSALON_COLLECTION).doc(cityName).collection(BRANCH_COLLECTION);
  var snapShot = await salonRef.get();
  snapShot.docs.forEach((element) {
    var salonModel = SalonModel.fromJson(element.data());
    salonModel.docId = element.id;
    salonModel.reference = element.reference;
    salons.add(salonModel);
    print('DocId: ${element.id} Ref: ${element.reference}');
  });
  return salons;
}

Future<List<BarberModel>> getBarberBySalon(SalonModel salon) async{
  var barbers = new List<BarberModel>.empty(growable: true);
  var barberRef = salon.reference!.collection(BARBER_COLLECTION);
  var snapShot = await barberRef.get();
  snapShot.docs.forEach((element) {
    var barberModel = BarberModel.fromJson(element.data());
    barberModel.docId = element.id;
    barberModel.reference = element.reference;
    barbers.add(barberModel);
  });
  return barbers;
}

Stream<QuerySnapshot> getTimeSlotOfBarber(BarberModel barberModel,String date) {

  var resultSnap = barberModel.reference!.collection(date).snapshots();
  return resultSnap;

 /* List<int> result = new List<int>.empty(growable: true);
  var bookingRef = barberModel.reference!.collection(date);
  QuerySnapshot snapShot = await bookingRef.get();
  snapShot.docs.forEach((element) {
    result.add(int.parse(element.id));
  });
  return result;*/

}


//Staff
Future<bool> checkStaffOfThisSalon(BuildContext context) async{
 DocumentSnapshot barberSnapShot = await FirebaseFirestore.instance
     .collection(AllSALON_COLLECTION)
     .doc(context.read(selectedCity).state.name)
     .collection(BRANCH_COLLECTION)
     .doc(context.read(selectedSalon).state.docId)
     .collection(BARBER_COLLECTION)
     .doc(FirebaseAuth.instance.currentUser!.uid) //Compare Uid of current user
     .get();
 return barberSnapShot.exists;
}

Stream<QuerySnapshot> getBookingSlotOfBarber(BuildContext context,String date) {
var resultSnap=  FirebaseFirestore.instance
      .collection(AllSALON_COLLECTION)
      .doc(context.read(selectedCity).state.name)
      .collection(BRANCH_COLLECTION)
      .doc(context.read(selectedSalon).state.docId)
      .collection(BARBER_COLLECTION)
      .doc(FirebaseAuth.instance.currentUser!.uid)
  .collection(date)
  .snapshots();

  return resultSnap;

/* var dsd;
   var result =  List<int>.empty(growable: true);

  var bookingRef = barberDoc.collection(date);
   bookingRef.snapshots().listen((event) {
    event.docs.forEach((element) {
      dsd.add(int.parse(element.id));
    });

  *//*  snapshot.docs.forEach((element) {
      result.add(int.parse(element.id));
    });*//*
  });


  return dsd;*/
}

Future<BookingModel> getDetailBooking(BuildContext context,int timeSlot) async{
  CollectionReference userRef=  FirebaseFirestore.instance
      .collection(AllSALON_COLLECTION)
      .doc(context.read(selectedCity).state.name)
      .collection(BRANCH_COLLECTION)
      .doc(context.read(selectedSalon).state.docId)
      .collection(BARBER_COLLECTION)
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection(DateFormat('dd_MM_yyyy').format(context.read(selectedDate).state));

  DocumentSnapshot snapshot = await userRef.doc(timeSlot.toString()).get();
  if(snapshot.exists)
    {
      var bookingModel = BookingModel.fromJson(json.decode(json.encode(snapshot.data())));
      bookingModel.docId = snapshot.id;
      bookingModel.reference = snapshot.reference;
      context.read(selectedBooking).state = bookingModel;
      return bookingModel;
    }
  else  return BookingModel(  barberName: '',
      totalPrice: 0,
      customerName: '',
      salonId: '',
      timeStamp: 0,
      barberId: '',
      customerPhone: '',
      customerId: '',
      time: '',
      done: false,
      salonName: '',
      salonAddress: '',
      slot: 0,
      cityBook: '');

}




