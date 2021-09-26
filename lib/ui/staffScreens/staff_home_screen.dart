import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barberapp/cloud_firestore/all_salon_ref.dart';
import 'package:flutter_barberapp/cloud_firestore/banner_ref.dart';
import 'package:flutter_barberapp/cloud_firestore/lookbook_ref.dart';
import 'package:flutter_barberapp/cloud_firestore/user_ref.dart';
import 'package:flutter_barberapp/model/booking_model.dart';
import 'package:flutter_barberapp/model/city_model.dart';
import 'package:flutter_barberapp/model/image_model.dart';
import 'package:flutter_barberapp/model/salon_model.dart';
import 'package:flutter_barberapp/model/user_model.dart';
import 'package:flutter_barberapp/shared/styles/colors.dart';
import 'package:flutter_barberapp/shared/styles/commponents/commponents.dart';
import 'package:flutter_barberapp/shared/styles/icon_broken.dart';
import 'package:flutter_barberapp/state/state_managment.dart';
import 'package:flutter_barberapp/ui/commponents/user_widgets/staff_widgets/appoiment_list.dart';
import 'package:flutter_barberapp/ui/commponents/user_widgets/staff_widgets/city_list.dart';
import 'package:flutter_barberapp/ui/commponents/user_widgets/staff_widgets/salon_list.dart';
import 'package:flutter_barberapp/utils/utils.dart';
import 'package:flutter_barberapp/view_model/main/staff_home/staff_home_view_model_imp.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StaffHomeScreen extends ConsumerWidget {
  final staffHomeViewModel = StaffHomeViewModelImp();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var currentStaffStep = watch(staffStep).state;
    var cityWatch = watch(selectedCity).state;
    var salonWatch = watch(selectedSalon).state;
    var dateWatch = watch(selectedDate).state;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          currentStaffStep == 1
              ? 'Selected City'
              : currentStaffStep == 2
                  ? 'Selected Salon'
                  : currentStaffStep == 3
                      ? 'Your Appointment'
                      : 'Staff Home',
        ),
      ),
      body: Column(
        children: [
          //Area
          Expanded(
            child: currentStaffStep == 1
                ? staffDisplayCity(staffHomeViewModel)
                : currentStaffStep == 2
                    ? staffDisplaySalon(staffHomeViewModel,cityWatch.name)
                    : currentStaffStep == 3
                        ? displayAppointment(staffHomeViewModel,context)
                        : Container(),
            //  flex: 10,
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: const Text('Previous'),
                      onPressed: currentStaffStep == 1
                          ? null
                          : () => context.read(staffStep).state--,
                    ),
                  ),
                  SizedBox(width: 40.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (currentStaffStep == 1 &&
                                  context.read(selectedCity).state.name.length == 0) ||
                              (currentStaffStep == 2 &&
                                  context.read(selectedSalon).state.docId!.length ==0) ||
                              currentStaffStep == 3
                          ? null
                          : () => context.read(staffStep).state++,
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }







}
