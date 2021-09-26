import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';

class PayTabPaymentScreen extends StatefulWidget {

  @override
  _PayTabPaymentScreenState createState() => _PayTabPaymentScreenState();
}

class _PayTabPaymentScreenState extends State<PayTabPaymentScreen> {

  String _instructions = 'Tap on "Pay" Button to try PayTabs plugin';

  @override
  void initState() {
    super.initState();
  }

  Future<void> payPressed() async {
    var billingDetails = BillingDetails(
        "Mohamed Adly",
        "m.adly@paytabs.com",
        "+201111111111",
        "st. 12",
        "ae",
        "dubai",
        "dubai",
        "12345");
    var shippingDetails = ShippingDetails(
        "Mohamed Adly",
        "email@example.com",
        "+201111111111",
        "st. 12",
        "ae",
        "dubai",
        "dubai",
        "12345");

    var configuration = PaymentSdkConfigurationDetails(
      profileId: "*Your profile id*",
      serverKey: "*server key*",
      clientKey: "*client key*",
      cartId: "12433",
      cartDescription: "Flowers",
      merchantName: "Flowers Store",
      screentTitle: "Pay with Card",
      billingDetails: billingDetails,
      shippingDetails: shippingDetails,
      amount: 20.0,
      currencyCode: "AED",

      merchantCountryCode: "ae",);
    if (Platform.isIOS) {
      // Set up here your custom theme
      // var theme = IOSThemeConfigurations();
      // configuration.iOSThemeConfigurations = theme;
    }
    FlutterPaytabsBridge.startCardPayment(configuration, (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PayTabs Plugin Example App'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('$_instructions'),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      payPressed();
                    },
                    child: Text('Pay with Card'),
                  ),
                  SizedBox(height: 16),
                ])),
      ),
    );
  }
}


