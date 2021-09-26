import 'package:carousel_slider/carousel_slider.dart';

//import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barberapp/cloud_firestore/all_salon_ref.dart';
import 'package:flutter_barberapp/cloud_firestore/banner_ref.dart';
import 'package:flutter_barberapp/cloud_firestore/lookbook_ref.dart';
import 'package:flutter_barberapp/cloud_firestore/services_ref.dart';
import 'package:flutter_barberapp/cloud_firestore/user_ref.dart';
import 'package:flutter_barberapp/model/booking_model.dart';
import 'package:flutter_barberapp/model/city_model.dart';
import 'package:flutter_barberapp/model/image_model.dart';
import 'package:flutter_barberapp/model/salon_model.dart';
import 'package:flutter_barberapp/model/service_model.dart';
import 'package:flutter_barberapp/model/user_model.dart';
import 'package:flutter_barberapp/shared/styles/colors.dart';
import 'package:flutter_barberapp/shared/styles/commponents/commponents.dart';
import 'package:flutter_barberapp/shared/styles/icon_broken.dart';
import 'package:flutter_barberapp/state/state_managment.dart';
import 'package:flutter_barberapp/string/strings.dart';
import 'package:flutter_barberapp/utils/utils.dart';
import 'package:flutter_barberapp/view_model/main/done_service/done_service_view_model.dart';
import 'package:flutter_barberapp/view_model/main/done_service/done_service_view_model_imp.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DoneServiceScreen extends ConsumerWidget {
 final scaffoldKey =  GlobalKey<ScaffoldState>();
 final doneServiceViewModel = DoneServiceViewModelImp();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    //When refresh, clear servicesSelected as chips choies not hold state
    context
        .read(selecedServices)
        .state
        .clear();
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          doneServiceText,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: doneServiceViewModel.displayDetailBooking(
                  context, context
                  .read(selectedTimeSlot)
                  .state),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else {
                  var bookingModel = snapshot.data as BookingModel;
                  return Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                child: Icon(
                                  Iconly_Broken.User1,
                                  color: Colors.white,
                                ),
                                backgroundColor: Colors.black,
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${bookingModel.customerName}',
                                    style: GoogleFonts.robotoMono(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${bookingModel.customerPhone}',
                                    style: GoogleFonts.robotoMono(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          myDivider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Consumer(builder: (context, watch, _) {
                                var servicesSelected =
                                    watch(selecedServices).state;


                                return Text(
                                  'Price \$${context
                                      .read(selectedBooking)
                                      .state
                                      .totalPrice == 0 ? doneServiceViewModel.calculateTotalPrice(servicesSelected) : context
                                      .read(selectedBooking)
                                      .state
                                      .totalPrice}',
                                  style: GoogleFonts.robotoMono(fontSize: 22.0),
                                );
                              }),
                              context
                                  .read(selectedBooking)
                                  .state
                                  .done
                                  ? Chip(label: Text('Finished',),)
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                  future: doneServiceViewModel.displayServices(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    else {
                      var serives = snapshot.data as List<ServiceModel>;
                      print('Serivess: ${serives.length}');
                      return Consumer(builder: (context, watch, _) {
                        var serivesWatch = watch(selecedServices).state;
                        return SingleChildScrollView(
                          child: Column(
                            children: [

                              Wrap(
                                children: serives.map((e) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ChoiceChip(
                                    selected:doneServiceViewModel.isSelectedService(context, e),
                                    selectedColor: Colors.blue,
                                    label: Text('${e.name}'),
                                    labelStyle: TextStyle(color: Colors.white),
                                    backgroundColor: Colors.teal,
                                    onSelected: (isSelected) => doneServiceViewModel.onSelectedChip(context, isSelected, e),
                                  ),
                                ),
                                ).toList(),
                              ),
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: ElevatedButton(
                                  onPressed:
                        doneServiceViewModel.isDone(context)
                                      ? null
                                      : serivesWatch.length > 0
                                      ? () => doneServiceViewModel.finishService(context,scaffoldKey)
                                      : null,
                                  child: Text(
                                    'Finish',
                                    style: GoogleFonts.robotoMono(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      });
                    }
                  }),
            ),
          ),

        ],
      ),
    );
  }

}
