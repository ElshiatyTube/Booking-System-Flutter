import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barberapp/cloud_firestore/all_salon_ref.dart';
import 'package:flutter_barberapp/model/barber_model.dart';
import 'package:flutter_barberapp/model/booking_model.dart';
import 'package:flutter_barberapp/model/city_model.dart';
import 'package:flutter_barberapp/model/salon_model.dart';
import 'package:flutter_barberapp/shared/styles/colors.dart';
import 'package:flutter_barberapp/shared/styles/commponents/commponents.dart';
import 'package:flutter_barberapp/shared/styles/icon_broken.dart';
import 'package:flutter_barberapp/state/state_managment.dart';
import 'package:flutter_barberapp/utils/utils.dart';
import 'package:flutter_barberapp/view_model/main/booking/booking_view_model.dart';
import 'package:flutter_barberapp/view_model/main/booking/booking_view_model_imp.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';

import '../commponents/user_widgets/barber_list.dart';
import '../commponents/user_widgets/city_list.dart';
import '../commponents/user_widgets/confirm.dart';
import '../commponents/user_widgets/salon_list.dart';
import '../commponents/user_widgets/time_slot.dart';

class BookingScreen extends ConsumerWidget {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  final bookingViewModel =  BookingViewModelImp();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var step = watch(currentStep).state;
    var cityWatch = watch(selectedCity).state;
    var salonWatch = watch(selectedSalon).state;
    var barberWatch = watch(selectedBarber).state;
    var dateWatch = watch(selectedDate).state;
    var timeWatch = watch(selectedTime).state;
    var timeSlotWach = watch(selectedTimeSlot).state;

    return Scaffold(
      key: scaffoldkey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.read(currentStep).state = 1;
            Navigator.pop(context);
          },
          icon: const Icon(Iconly_Broken.Arrow___Left_2),
        ),
      ),
      body: Column(
        children: [
          //Steps
          NumberStepper(
            activeStep: step - 1,
            direction: Axis.horizontal,
            enableNextPreviousButtons: false,
            enableStepTapping: false,
            numbers: const [1, 2, 3, 4, 5],
            stepColor: brounColor,
            activeStepColor: Colors.grey,
            numberStyle: const TextStyle(color: Colors.white),
          ),

          //Screens
          Expanded(
            flex: 10,
            child: step == 1
                ? displayCityList(bookingViewModel)
                : step == 2
                    ? displaySalonList(bookingViewModel,cityWatch.name)
                    : step == 3
                        ? displayBarberList(bookingViewModel,salonWatch)
                        : step == 4
                            ? displayTimeSlot(bookingViewModel,context, barberWatch)
                            : step == 5
                                ? displayConfirmScreen(bookingViewModel,context,scaffoldkey)
                                : Container(),
          ),
          //Buttons
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: const Text('Previous'),
                        onPressed: step == 1
                            ? null
                            : () => context.read(currentStep).state--,
                      ),
                    ),
                    SizedBox(width: 40.0),
                    Expanded(
                      child: ElevatedButton(
                        child: const Text('Next'),
                        onPressed: (step == 1 &&
                                    context.read(selectedCity).state.name.length == 0) ||
                                (step == 2 &&
                                    context
                                            .read(selectedSalon)
                                            .state
                                            .docId!.length == 0 ) ||
                                (step == 3 &&
                                    context.read(selectedBarber).state.docId!.length == 0) ||
                                (step == 4 &&
                                    context.read(selectedTimeSlot).state == -1)
                            ? null
                            : step == 5
                                ? null
                                : () => context.read(currentStep).state++,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }







}
