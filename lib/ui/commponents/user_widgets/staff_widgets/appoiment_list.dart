import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barberapp/model/city_model.dart';
import 'package:flutter_barberapp/model/salon_model.dart';
import 'package:flutter_barberapp/shared/styles/commponents/commponents.dart';
import 'package:flutter_barberapp/shared/styles/icon_broken.dart';
import 'package:flutter_barberapp/string/strings.dart';
import 'package:flutter_barberapp/utils/utils.dart';
import 'package:flutter_barberapp/view_model/main/staff_home/staff_home_view_model.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_barberapp/state/state_managment.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


displayAppointment(StaffHomeViewModel staffHomeViewModel,BuildContext context) {
  //Check if user is staff in this salon
  return FutureBuilder(
    future: staffHomeViewModel.isStaffOfThisSalon(context),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting)
        return Center(
          child: CircularProgressIndicator(),
        );
      else {
        var result = snapshot.data as bool;
        if (result)
          return displaySlot(staffHomeViewModel,context);
        else
          return Center(
            child: Text('Sorry ! You\'r not a Staff of this salon'),
          );
      }
    },
  );
}

displaySlot(StaffHomeViewModel staffHomeViewModel,BuildContext context) {
  var now = context.read(selectedDate).state;
  return Column(
    children: [
      Container(
        color: Colors.amber,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(
                          '${DateFormat.MMMM().format(now)}',
                          style: GoogleFonts.robotoMono(color: Colors.white),
                        ),
                        Text(
                          '${now.day}',
                          style: GoogleFonts.robotoMono(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0),
                        ),
                        Text(
                          '${DateFormat.EEEE().format(now)}',
                          style: GoogleFonts.robotoMono(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )),
            GestureDetector(
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime.now(), //To can select current date
                  maxTime: now.add(Duration(days: 31)),
                  onConfirm: (date) =>
                  context.read(selectedDate).state = date,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Iconly_Broken.Calendar,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      Expanded(
        child: Container(
          color: Colors.white60,
          child: FutureBuilder(
            future: staffHomeViewModel.displayMaxAvailableTimeSlot(context.read(selectedDate).state),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else {
                var maxTimeSlot = snapshot.data as int;
                return StreamBuilder(
                  stream:
                 /* FirebaseFirestore.instance
                      .collection(AllSALON_COLLECTION)
                      .doc(context.read(selectedCity).state.name)
                      .collection(BRANCH_COLLECTION)
                      .doc(context.read(selectedSalon).state.docId)
                      .collection(BARBER_COLLECTION)
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection(DateFormat('dd_MM_yyyy')
                      .format(context.read(selectedDate).state))
                    .snapshots(),*/
                  staffHomeViewModel.displayBookingSlotOfBarber(
                    context,
                    DateFormat('dd_MM_yyyy')
                        .format(context.read(selectedDate).state),
                  ),
                  builder: (context, AsyncSnapshot<QuerySnapshot>  snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    else {
                      var listTimeSlot =  List<int>.empty(growable: true);
                      //showToast(msg: 'Change', state: ToastedStates.SUCCESS);

                      snapshot.data!.docs.forEach((e) {
                        listTimeSlot.add(int.parse(e.id));
                      });

                      return GridView.builder(
                        itemCount: TIME_SLOT.length,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (context, index) => GestureDetector(
                          onTap:
                          !listTimeSlot.contains(index)
                              ? null
                              : () => staffHomeViewModel.processDoneServices(context,index),
                          child: Card(
                            color: staffHomeViewModel.getColorOfThisSlot(context, listTimeSlot, index, maxTimeSlot),
                            child: GridTile(
                              child: Center(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${TIME_SLOT.elementAt(index)}'),
                                    Text(listTimeSlot.contains(index)
                                        ? 'Full'
                                        : maxTimeSlot > index
                                        ? 'Not Available'
                                        : 'Available'),
                                  ],
                                ),
                              ),
                              header: context.read(selectedTime).state ==
                                  TIME_SLOT.elementAt(index)
                                  ? const Icon(Icons.check)
                                  : null,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
      ),
    ],
  );
}
