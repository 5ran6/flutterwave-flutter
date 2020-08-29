import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterwave/core/flutterwave_error.dart';
import 'package:flutterwave/models/requests/bank_transfer/bank_transfer_request.dart';
import 'package:flutterwave/models/requests/pay_with_bank_account/pay_with_bank_account.dart';
import 'package:flutterwave/models/requests/verify_charge_request.dart';
import 'package:flutterwave/models/responses/charge_card_response.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';
import 'package:http/http.dart' as http;

class BankAccountPaymentManager {
  String publicKey;
  String currency;
  String amount;
  String email;
  String txRef;
  bool isDebugMode;
  String phoneNumber;
  String accountBank;
  String accountNumber;
  
  
  BankAccountPaymentManager({
    @required this.publicKey,
    @required this.currency,
    @required this.amount,
    @required this.email,
    @required this.txRef,
    @required this.isDebugMode,
    @required this.phoneNumber,
    @required this.accountBank,
    @required this.accountNumber,
  });

  Future<ChargeResponse> payWithBankTransfer(
      BankAccountRequest bankAccountRequest, http.Client client) async {
    final requestBody = bankAccountRequest.toJson();

    final url = FlutterwaveUtils.getBaseUrl(this.isDebugMode) + FlutterwaveUtils.PAY_WITH_ACCOUNT;
    print("url iss ==> $url");

    try {
      print("Pay With Bank Request Payload => ${bankAccountRequest.toJson()}");

      final http.Response response = await client.post(url,
          headers: {HttpHeaders.authorizationHeader: this.publicKey},
          body: requestBody);

      ChargeResponse bankTransferResponse =
      ChargeResponse.fromJson(json.decode(response.body));

      print("Pay with bank response => ${bankTransferResponse.toJson()}");

      return bankTransferResponse;
    } catch (error) {
      throw (FlutterError(error.toString()));
    }
  }

  Future<ChargeResponse> verifyPayment(final String flwRef, final http.Client client) async {
    final url = FlutterwaveUtils.getBaseUrl(this.isDebugMode) + FlutterwaveUtils.VERIFY_TRANSACTION;
    final VerifyChargeRequest verifyRequest = VerifyChargeRequest(flwRef);
    final payload = verifyRequest.toJson();
    print("Verify Bank Url => $url");
    print("Verify Bank Request Payload => ${verifyRequest.toJson()}");
    try {
      final http.Response response = await client.post(url,
          headers: {HttpHeaders.authorizationHeader: this.publicKey},
          body: payload);

      final ChargeResponse cardResponse =
      ChargeResponse.fromJson(jsonDecode(response.body));
      print("Verify Bank Response Payload => ${cardResponse.toJson()}");

      return cardResponse;
    } catch (error) {
      throw(FlutterWaveError(error.toString()));
    }
  }
}
