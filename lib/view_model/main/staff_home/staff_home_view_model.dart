import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_barberapp/model/city_model.dart';
import 'package:flutter_barberapp/model/salon_model.dart';

abstract class StaffHomeViewModel{
  //City
  Future<List<CityModel>> displayCities();
  void onSelectedCity(BuildContext context,CityModel cityModel);
  bool isCitySelected(BuildContext context,CityModel cityModel);

  //Salon
  Future<List<SalonModel>> displaySalonByCity(String cityName);
  void onSelectedSalon(BuildContext context,SalonModel salonModel);
  bool isSalonSelected(BuildContext context,SalonModel salonModel);

  //Appoinment
  Future<bool> isStaffOfThisSalon(BuildContext context);
  Future<int> displayMaxAvailableTimeSlot(DateTime dt);
  Stream<QuerySnapshot> displayBookingSlotOfBarber(BuildContext context,String date);
  bool isTimeSlotBooked(List<int> listTimeSlot,int index);
  void processDoneServices(BuildContext context,int index);
  Color getColorOfThisSlot(BuildContext context,List<int> listTimeSlot,int index,int maxTimeSlot);

}