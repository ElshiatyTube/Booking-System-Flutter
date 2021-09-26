import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barberapp/cloud_firestore/all_salon_ref.dart';
import 'package:flutter_barberapp/model/barber_model.dart';
import 'package:flutter_barberapp/model/city_model.dart';
import 'package:flutter_barberapp/model/salon_model.dart';
import 'package:flutter_barberapp/shared/styles/icon_broken.dart';
import 'package:flutter_barberapp/string/strings.dart';
import 'package:flutter_barberapp/view_model/main/booking/booking_view_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_barberapp/state/state_managment.dart';
import 'package:google_fonts/google_fonts.dart';

displayBarberList(BookingViewModel bookingViewModel,SalonModel salonModel) {
  return FutureBuilder(
    future: bookingViewModel.displayBarberBySalon(salonModel),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting)
        return Center(
          child: CircularProgressIndicator(),
        );
      else {
        var barbers = snapshot.data as List<BarberModel>;
        if (barbers.length == 0)
          return Center(
            child: Text(cannotLoadBarbersText),
          );
        else {
          return ListView.builder(
            key: PageStorageKey('keep'),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () =>
                bookingViewModel.onSelectedBarber(context, barbers[index]),
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Iconly_Broken.User,
                      size: 35.0,
                    ),
                    trailing: bookingViewModel.isBarberSelected(context, barbers[index])
                        ? const Icon(Icons.check)
                        : null,
                    title: Text(
                      '${barbers[index].name}',
                      style: GoogleFonts.robotoMono(),
                    ),
                    subtitle: RatingBar.builder(
                      itemSize: 16,
                      allowHalfRating: true,
                      ignoreGestures: true,
                      initialRating: barbers[index].rating,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                        Iconly_Broken.Star,
                        color: Colors.amber,
                      ),
                      itemPadding: const EdgeInsets.all(4.0),
                      onRatingUpdate: (value) {},
                    ),
                  ),
                ),
              );
            },
            itemCount: barbers.length,
          );
        }
      }
    },
  );
}
