import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barberapp/cloud_firestore/all_salon_ref.dart';
import 'package:flutter_barberapp/cloud_firestore/user_ref.dart';
import 'package:flutter_barberapp/model/barber_model.dart';
import 'package:flutter_barberapp/model/booking_model.dart';
import 'package:flutter_barberapp/model/city_model.dart';
import 'package:flutter_barberapp/model/salon_model.dart';
import 'package:flutter_barberapp/shared/styles/colors.dart';
import 'package:flutter_barberapp/shared/styles/commponents/commponents.dart';
import 'package:flutter_barberapp/shared/styles/icon_broken.dart';
import 'package:flutter_barberapp/state/state_managment.dart';
import 'package:flutter_barberapp/utils/utils.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UserHistory extends ConsumerWidget {
  List<BookingModel> userBookings;

  UserHistory(this.userBookings);

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    var watchRefresh = watch(deleteFlagRefresh).state;

    return Scaffold(
      key: scaffoldState,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('User History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: displayBookingHistory(),
      ),
    );
  }

  displayBookingHistory() {
    return FutureBuilder(
      future: syncTime(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          var syncTime = snapshot.data as DateTime;

          return ListView.builder(
            itemCount: userBookings.length,
            itemBuilder: (context, index) {
              bool isExpried = DateTime.fromMillisecondsSinceEpoch(
                      userBookings[index].timeStamp)
                  .isBefore(syncTime);
              return Card(
                color: Colors.grey[500],
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(22))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date',
                                    style: GoogleFonts.robotoMono(
                                        color: Colors.white),
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            userBookings[index].timeStamp)),
                                    style: GoogleFonts.robotoMono(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Time',
                                    style: GoogleFonts.robotoMono(
                                        color: Colors.white),
                                  ),
                                  Text(
                                    TIME_SLOT
                                        .elementAt(userBookings[index].slot),
                                    style: GoogleFonts.robotoMono(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                          myDivider(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${userBookings[index].salonName}',
                                    style: GoogleFonts.robotoMono(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${userBookings[index].barberName}',
                                    style: GoogleFonts.robotoMono(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${userBookings[index].salonAddress}',
                                style: GoogleFonts.robotoMono(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap:(userBookings[index].done || isExpried) ? null  : () {

                       Alert(
                           context: context,
                           type: AlertType.warning,
                           title: 'Delete Booking',
                           desc: 'Remember Delete also in your calender too',
                           buttons: [
                             DialogButton(child: Text('CANCEL',style: TextStyle(color: Colors.white)), onPressed:() => Navigator.pop(context),color: brounColor,),
                             DialogButton(child: Text('DELETE',style: TextStyle(color: Colors.red),),color: brounColor, onPressed:() {
                               Navigator.of(context).pop();
                               cancelBooking(context,userBookings[index]);
                             } ),

                           ]
                       ).show();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: brounColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(22.0),
                              bottomRight: Radius.circular(22.0),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                userBookings[index].done
                                    ? 'FINISH'
                                    : isExpried
                                        ? 'EXPIRED'
                                        : 'CANCEL',
                                style:
                                    GoogleFonts.robotoMono(color: isExpried?Colors.grey : Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
            physics: BouncingScrollPhysics(),
          );
        }
      },
    );
  }

  void cancelBooking(BuildContext context, BookingModel bookingModel) {
    var batch = FirebaseFirestore.instance.batch();
    var barberBooking = FirebaseFirestore.instance
    .collection(AllSALON_COLLECTION)
    .doc(bookingModel.cityBook)
    .collection(BRANCH_COLLECTION)
    .doc(bookingModel.salonId)
    .collection(BARBER_COLLECTION)
    .doc(bookingModel.barberId)
    .collection(DateFormat('dd_MM_yyyy').format(DateTime.fromMillisecondsSinceEpoch(bookingModel.timeStamp)))
    .doc(bookingModel.slot.toString());

    var userBooking = bookingModel.reference;

    //Delete
    batch.delete(userBooking!);
    batch.delete(barberBooking);

    batch.commit().then((value) {
      //Refresh Data

      userBookings.remove(bookingModel);
      if(userBookings.length == 0)
        Navigator.pop(context);
      else
        context.read(deleteFlagRefresh).state = !context.read(deleteFlagRefresh).state;


    });
  }

}
