import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel{
  String name='',address='';
  String phone='';
  bool isStuff=false;


  UserModel({required this.name, required this.address, required this.phone});

  UserModel.fromJson(Map<String,dynamic> json){
    name = json['name'];
  //  phone = json['phone'];
    address = json['address'];
    isStuff = json['isStuff'] == null ? false : json['isStuff'] as bool;
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['address'] = this.address;
    data['name'] = this.name;
 //   data['phone'] = this.phone;

    data['isStuff'] = this.isStuff;
    return data;
  }
}