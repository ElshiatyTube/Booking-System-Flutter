import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/scaffold.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barberapp/cloud_firestore/all_salon_ref.dart';
import 'package:flutter_barberapp/cloud_firestore/services_ref.dart';
import 'package:flutter_barberapp/model/booking_model.dart';
import 'package:flutter_barberapp/model/service_model.dart';
import 'package:flutter_barberapp/utils/utils.dart';
import 'package:flutter_barberapp/view_model/main/done_service/done_service_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_barberapp/state/state_managment.dart';
import 'package:intl/intl.dart';

class DoneServiceViewModelImp implements DoneServiceViewModel{
  @override
  double calculateTotalPrice(List<ServiceModel> serviceSelected) {
   return serviceSelected
       .map((e) => e.price)
       .fold(
       0, (value, element) => double.parse(value.toString()) + element);
  }

  @override
  Future<BookingModel> displayDetailBooking(BuildContext context, int timeSlot) {
    return getDetailBooking(context, timeSlot);
  }

  @override
  Future<List<ServiceModel>> displayServices(BuildContext context) {
    return getServices(context);
  }

  @override
  void finishService(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {

    var batch = FirebaseFirestore.instance.batch();
    var barberBook = context
        .read(selectedBooking)
        .state;

    var userBook = FirebaseFirestore.instance
        .collection(USER_COLLECTION)
        .doc('${barberBook.customerPhone}')
        .collection('${BOOKING_COLLECTION}_${barberBook.customerId}')
        .doc(
        '${barberBook.barberId}_${DateFormat('dd_MM_yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(barberBook.timeStamp))}');

    Map<String, dynamic> updateDone = new Map();
    updateDone['done'] = true;
    updateDone['services'] =
        convertServices(context
            .read(selecedServices)
            .state);
    updateDone['totalPrice'] = context
        .read(selecedServices)
        .state
        .map((e) => e.price)
        .fold(0, (previousValue, element) => double.parse(previousValue.toString()) + element);

    batch.update(userBook, updateDone);
    batch.update(barberBook.reference!, updateDone);

    batch.commit().then((value) {
      ScaffoldMessenger
          .of(scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text('Finish Success')))
          .closed
          .then((value) {
        Navigator.pop(context);
      });
    });
  }

  @override
  bool isDone(BuildContext context) {
   return context.read(selectedBooking).state.done;
  }

  @override
  bool isSelectedService(BuildContext context, ServiceModel serviceModel) {
   return context.read(selecedServices).state.contains(serviceModel);
  }

  @override
  void onSelectedChip(BuildContext context, bool isSelected, ServiceModel e) {
    var list = context.read(selecedServices).state;
    if(isSelected){
      list.add(e);
      context.read(selecedServices).state = list;
    }
    else{
      list.remove(e);
      context.read(selecedServices).state = list;
    }
  }

}