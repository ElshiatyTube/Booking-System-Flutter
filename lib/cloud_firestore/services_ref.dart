import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_barberapp/model/service_model.dart';
import 'package:flutter_barberapp/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_barberapp/state/state_managment.dart';

Future<List<ServiceModel>> getServices(BuildContext context) async{
  var services = List<ServiceModel>.empty(growable: true);
  CollectionReference servicesRef =
      FirebaseFirestore.instance.collection(SERVICES_COLLECTION);
  QuerySnapshot snapshot = await servicesRef
  //.where(context.read(selectedSalon).state.docId!,isEqualTo: true)
  .get();
  print('SelSlaonId: ${context.read(selectedSalon).state.docId}');
  snapshot.docs.forEach((element) {
    final data  = element.data() as Map<String,dynamic>;
    var servicesModel = ServiceModel.fromJson(data);
    servicesModel.docId = element.id;
    services.add(servicesModel);
  });
  return services;
}

