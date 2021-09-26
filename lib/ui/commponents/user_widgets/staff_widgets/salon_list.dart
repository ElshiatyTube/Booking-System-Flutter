import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barberapp/model/city_model.dart';
import 'package:flutter_barberapp/model/salon_model.dart';
import 'package:flutter_barberapp/shared/styles/icon_broken.dart';
import 'package:flutter_barberapp/string/strings.dart';
import 'package:flutter_barberapp/view_model/main/staff_home/staff_home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_barberapp/state/state_managment.dart';
import 'package:google_fonts/google_fonts.dart';

staffDisplaySalon(StaffHomeViewModel staffHomeViewModel,String name) {
  return FutureBuilder(
    future: staffHomeViewModel.displaySalonByCity(name),
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
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () =>staffHomeViewModel.onSelectedSalon(context, salons[index]),
                child: Card(
                  child: ListTile(
                    shape: staffHomeViewModel.isSalonSelected(context, salons[index])
                        ? RoundedRectangleBorder(
                      side: BorderSide(color: Colors.green, width: 4.0),
                      borderRadius: BorderRadius.circular(5),
                    )
                        : null,
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
