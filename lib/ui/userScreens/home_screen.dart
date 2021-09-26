import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barberapp/cloud_firestore/banner_ref.dart';
import 'package:flutter_barberapp/cloud_firestore/lookbook_ref.dart';
import 'package:flutter_barberapp/cloud_firestore/user_ref.dart';
import 'package:flutter_barberapp/fawry_payment/fawry_payment_screen.dart';
import 'package:flutter_barberapp/model/booking_model.dart';
import 'package:flutter_barberapp/model/image_model.dart';
import 'package:flutter_barberapp/model/user_model.dart';
import 'package:flutter_barberapp/paytab_payment/paytab_payment_screen.dart';
import 'package:flutter_barberapp/shared/styles/colors.dart';
import 'package:flutter_barberapp/shared/styles/commponents/commponents.dart';
import 'package:flutter_barberapp/shared/styles/icon_broken.dart';
import 'package:flutter_barberapp/state/state_managment.dart';
import 'package:flutter_barberapp/view_model/main/home/home_view_model_imp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends ConsumerWidget {
  final homeViewModel = HomeViewModelImp();
  @override
  Widget build(BuildContext context, ScopedReader watch) {

    var userInfoWatch = watch(userInfo).state;
    print('Userrr: ${userInfoWatch.name}');
    print('UserrrPhone: ${userInfoWatch.phone}');
    print('UserrrStaff: ${userInfoWatch.isStuff}');

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const Icon(Iconly_Broken.User),
        title: Text('Hello ${context.read(userInfo).state.name}'),

        actions: [

          homeViewModel.isStaff(context)?  IconButton(
            onPressed: ()=>Navigator.of(context).pushNamed('/staffHome'),
            icon: const Icon(Iconly_Broken.Shield_Done),) :Container() ,

        /*  FutureBuilder(
            future: getUserProfiles(context,FirebaseAuth.instance.currentUser!.phoneNumber!),
            builder: (context,snapshot)
            {
              if (snapshot.hasError) {
                return Text('${snapshot.error.toString()}');
              }
              else{
                print('dsdfasfdfsdfdsfsd');
                var userModel = snapshot.data as UserModel;
                return userModel.isStuff ?  IconButton(
                  onPressed: ()=>Navigator.of(context).pushNamed('/staffHome'),
                  icon: const Icon(Iconly_Broken.Shield_Done),) : Container();
              }
            },
          ),*/

        ],
      ),
      body: Column(
        children: [
          //Menu
          Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/booking'),
                    child: Container(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconly_Broken.Bookmark,
                                size: 50,
                              ),
                              Text('Booking',style: TextStyle(color: brounColor),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: ()
                    {
                     navigateTo(context, PayTabPaymentScreen());
                    },
                    child: Container(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconly_Broken.Bag_2,
                                size: 50,
                              ),
                              Text('Cart',style: TextStyle(color: brounColor),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap:() async
                    {
                      getUserHistory().then((value) {
                        List<BookingModel> userBookings = value;
                        if (userBookings == null || userBookings.length == 0)
                        {
                          showToast(msg: 'No Booking Yet!', state: ToastedStates.WARNING);

                        }
                        else {
                          Navigator.pushNamed(context, '/history',arguments: userBookings);
                        }
                      });
                    },
                    child: Container(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconly_Broken.Calendar,
                                size: 50,
                              ),
                              Text('History',style: TextStyle(color: brounColor),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //Banner
                  FutureBuilder(
                    future: homeViewModel.displayBanner(),
                    builder: (context,snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: LinearProgressIndicator(),);
                      else{
                        var banner = snapshot.data as List<ImageModel>;
                        return CarouselSlider(
                          items: banner.map((e) => Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(e.image),
                            ),
                          )).toList(),
                          options: CarouselOptions(
                              enlargeCenterPage: true,
                              aspectRatio: 3.0,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3)
                          ),

                        );
                      }

                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('LookBook',style: GoogleFonts.robotoMono(fontSize: 18.0,color: brounColor),), //Theme.of(context).textTheme.bodyText1
                      ],
                    ),
                  ),
                  //Lookbook
                  FutureBuilder(
                    future: homeViewModel.displayLookbook(),
                    builder: (context,snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: LinearProgressIndicator(),);
                      else{
                        var lookbook = snapshot.data as List<ImageModel>;
                        print('LookBookLenght: ${lookbook.length}');
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: lookbook.length,
                          itemBuilder: (context,index)
                          {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: lookbook[index].image!=null ? Image.network(lookbook[index].image) : Container(),
                              ),
                            );
                          },

                        );
                      }

                    },
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
