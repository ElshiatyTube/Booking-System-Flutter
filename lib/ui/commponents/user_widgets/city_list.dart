import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barberapp/cloud_firestore/all_salon_ref.dart';
import 'package:flutter_barberapp/model/city_model.dart';
import 'package:flutter_barberapp/shared/styles/icon_broken.dart';
import 'package:flutter_barberapp/string/strings.dart';
import 'package:flutter_barberapp/view_model/main/booking/booking_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_barberapp/state/state_managment.dart';
import 'package:google_fonts/google_fonts.dart';

displayCityList(BookingViewModel bookingViewModel) {
  return FutureBuilder(
    future: bookingViewModel.displayCities(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting)
        return Center(
          child: CircularProgressIndicator(),
        );
      else {
        var cities = snapshot.data as List<CityModel>;
        if (cities.length == 0)
          return Center(
            child: Text(cannotLoadCityText),
          );
        else {
          return ListView.builder(
            key: PageStorageKey('keep'),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => bookingViewModel.onSelectedCity(context, cities[index]),
                child: Card(
                  child: ListTile(
                    leading: const Icon(
                      Iconly_Broken.Location,
                      size: 35.0,
                    ),
                    trailing: bookingViewModel.isCitySelected(context, cities[index])
                        ? const Icon(Icons.check)
                        : null,
                    title: Text(
                      '${cities[index].name}',
                      style: GoogleFonts.robotoMono(),
                    ),
                  ),
                ),
              );
            },
            itemCount: cities.length,
          );
        }
      }
    },
  );
}