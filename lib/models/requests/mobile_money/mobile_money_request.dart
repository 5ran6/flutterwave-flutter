import 'package:flutter/material.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';

class MobileMoneyRequest {
  String amount;
  String currency;
  String network;
  String txRef;
  String fullName;
  String email;
  String phoneNumber;
  String redirectUrl;

  MobileMoneyRequest({
    @required this.amount,
    @required this.currency,
    @required this.network,
    @required this.txRef,
    @required this.fullName,
    @required this.email,
    @required this.phoneNumber,
    this.redirectUrl = FlutterwaveUtils.DEFAULT_REDIRECT_URL
  });

  MobileMoneyRequest.fromJson(Map<String, dynamic> json) {
    this.amount = json['amount'];
    this.currency = json['currency'];
    this.network = json['network'];
    this.txRef = json['tx_ref'];
    this.fullName = json['fullname'];
    this.email = json['email'];
    this.phoneNumber = json["phone_number"];
    this.redirectUrl = json["redirect_url"];
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': this.amount,
      'currency': this.currency,
      'network': this.network,
      'tx_ref': this.txRef,
      'fullname': this.fullName,
      'email': this.email,
      'phone_number': this.phoneNumber,
      'redirect_url': this.redirectUrl
    };
  }
}
