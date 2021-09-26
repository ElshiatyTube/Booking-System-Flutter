import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_barberapp/model/barber_model.dart';
import 'package:flutter_barberapp/model/booking_model.dart';
import 'package:flutter_barberapp/model/city_model.dart';
import 'package:flutter_barberapp/model/salon_model.dart';
import 'package:flutter_barberapp/model/service_model.dart';
import 'package:flutter_barberapp/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userLogged = StateProvider((ref) => FirebaseAuth.instance.currentUser);
final userToken = StateProvider((ref) => '');
final forceReload = StateProvider((ref) => false);

final userInfo = StateProvider((ref) => UserModel(name: '', address: '', phone: ''));

//Booking State
final currentStep = StateProvider((ref) => 1);
final selectedCity = StateProvider((ref) => CityModel(name: ''));
final selectedSalon = StateProvider((ref) => SalonModel(name: '', address: ''));
final selectedBarber = StateProvider((ref) => BarberModel());
final selectedDate = StateProvider((ref) => DateTime.now());
final selectedTimeSlot = StateProvider((ref) => -1);
final selectedTime = StateProvider((ref) => '');

//Delete Booking
final deleteFlagRefresh = StateProvider((ref) => false);
final refreshUserBookings = StateProvider((ref) => BookingModel(
    barberName: '',
    totalPrice: 0,
    customerName: '',
    salonId: '',
    timeStamp: 0,
    barberId: '',
    customerPhone: '',
    customerId: '',
    time: '',
    done: false,
    salonName: '',
    salonAddress: '',
    slot: 0,
    cityBook: ''));

//Staff
final staffStep = StateProvider((ref) => 1);
final selectedBooking = StateProvider((ref) => BookingModel(
    barberName: '',
    totalPrice: 0,
    customerName: '',
    salonId: '',
    timeStamp: 0,
    barberId: '',
    customerPhone: '',
    customerId: '',
    time: '',
    done: false,
    salonName: '',
    salonAddress: '',
    slot: 0,
    cityBook: ''));
final selecedServices =
    StateProvider((ref) => List<ServiceModel>.empty(growable: true));
