import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_barberapp/model/barber_model.dart';
import 'package:flutter_barberapp/model/booking_model.dart';
import 'package:flutter_barberapp/model/city_model.dart';
import 'package:flutter_barberapp/model/image_model.dart';
import 'package:flutter_barberapp/model/salon_model.dart';
import 'package:flutter_barberapp/model/service_model.dart';
import 'package:flutter_barberapp/model/user_model.dart';
import 'package:flutter/material.dart';
abstract class  DoneServiceViewModel{

  Future<BookingModel> displayDetailBooking(BuildContext context,int timeSlot);
  Future<List<ServiceModel>> displayServices(BuildContext context);
  void finishService(BuildContext context,GlobalKey<ScaffoldState> scaffoldKey);
  double calculateTotalPrice(List<ServiceModel> serviceSelected);
  bool isDone(BuildContext context);
  bool isSelectedService(BuildContext context,ServiceModel serviceModel);
  void onSelectedChip(BuildContext context,bool isSelected,ServiceModel e);

}