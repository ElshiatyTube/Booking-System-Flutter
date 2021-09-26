import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barberapp/cloud_firestore/all_salon_ref.dart';
import 'package:flutter_barberapp/model/city_model.dart';
import 'package:flutter_barberapp/model/salon_model.dart';
import 'package:flutter_barberapp/shared/styles/icon_broken.dart';
import 'package:flutter_barberapp/string/strings.dart';
import 'package:flutter_barberapp/view_model/main/booking/booking_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_barberapp/state/state_managment.dart';
import 'package:google_fonts/google_fonts.dart';

displaySalonList(BookingViewModel bookingViewModel,String cityName) {
  return FutureBuilder(
    future: bookingViewModel.displaySalonByCity(cityName),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting)
        return Center(
          child: CircularProgressIndicator(),
        );
      else {
        var salons = snapshot.data as List<SalonModel>;
        if (salons.length == 0)
          return Center(
            child: Text(cannotLoadSalonsText),
          );
        else {
          return ListView.builder(
            key: PageStorageKey('keep'),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () =>
                context.read(selectedSalon).state = salons[index],
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Iconly_Broken.Home,
                      size: 35.0,
                    ),
                    trailing: context.read(selectedSalon).state.docId ==
                        salons[index].docId
                        ? const Icon(Icons.check)
                        : null,
                    title: Text(
                      '${salons[index].name}',
                      style: GoogleFonts.robotoMono(),
                    ),
                    subtitle: Text(
                      '${salons[index].address}',
                      style:
                      GoogleFonts.robotoMono(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              );
            },
            itemCount: salons.length,
          );
        }
      }
    },
  );
}