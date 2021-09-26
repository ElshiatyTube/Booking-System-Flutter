import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barberapp/cloud_firestore/all_salon_ref.dart';
import 'package:flutter_barberapp/model/barber_model.dart';
import 'package:flutter_barberapp/model/city_model.dart';
import 'package:flutter_barberapp/model/salon_model.dart';
import 'package:flutter_barberapp/shared/styles/commponents/commponents.dart';
import 'package:flutter_barberapp/shared/styles/icon_broken.dart';
import 'package:flutter_barberapp/string/strings.dart';
import 'package:flutter_barberapp/view_model/main/booking/booking_view_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_barberapp/state/state_managment.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

displayConfirmScreen(BookingViewModel bookingViewModel,BuildContext context,GlobalKey<ScaffoldState> scaffoldKey) {
  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            //  flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          Expanded(
            //   flex: 6,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          thankServiceText.toUpperCase(),
                          style:
                          GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          bookingInfoText.toUpperCase(),
                          style: GoogleFonts.robotoMono(),
                        ),
                        Row(
                          children: [
                            Icon(Iconly_Broken.Calendar),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              '${context.read(selectedTime).state} - ${DateFormat('dd/MM/yyyy').format(context.read(selectedDate).state)}'
                                  .toUpperCase(),
                              style: GoogleFonts.robotoMono(),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Icon(Iconly_Broken.User1),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              '${context.read(selectedBarber).state.name}'
                                  .toUpperCase(),
                              style: GoogleFonts.robotoMono(),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        myDivider(),
                        Row(
                          children: [
                            Icon(Iconly_Broken.Home),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              '${context.read(selectedSalon).state.name}'
                                  .toUpperCase(),
                              style: GoogleFonts.robotoMono(),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Icon(Iconly_Broken.Location),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              '${context.read(selectedSalon).state.address}'
                                  .toUpperCase(),
                              style: GoogleFonts.robotoMono(),
                            )
                          ],
                        ),
                        elevatedBtn(
                            text: 'Confirm',
                            function: () => bookingViewModel.confirmBooking(context,scaffoldKey),
                            iconData: Iconly_Broken.Send),
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    ),
  );
}
