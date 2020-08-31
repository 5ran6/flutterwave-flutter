import 'package:flutter/material.dart';
import 'package:flutterwave/core/bank_transfer_manager/bank_transfer_payment_manager.dart';
import 'package:flutterwave/core/card_payment_manager/card_payment_manager.dart';
import 'package:flutterwave/core/mobile_money/mobile_money_payment_manager.dart';
import 'package:flutterwave/core/pay_with_account_manager/bank_account_manager.dart';
import 'package:flutterwave/core/ussd_payment_manager/ussd_manager.dart';

class FlutterwavePaymentManager {
  String publicKey;
  String encryptionKey;
  String currency;
  String amount;
  String email;
  String fullName;
  String txRef;
  bool isDebugMode;
  String phoneNumber;
  int frequency;
  int duration;
  bool isPermanent;
  String narration;
  String network;
  bool acceptAccountPayment;
  bool acceptBankTransferPayment;
  bool acceptCardPayment;
  bool acceptUSSDPayment;
  bool acceptUKAccountPayment;
  bool acceptRwandaMoneyPayment;
  bool acceptMpesaPayment;
  bool acceptZambiaPayment;
  bool acceptGhanaPayment;
  bool acceptUgandaPayment;
  bool acceptBarterPayment;
  bool acceptSouthAfricaBankPayment;
  bool acceptFancophoneMobileMoney;

  FlutterwavePaymentManager(
      {@required this.publicKey,
      @required this.encryptionKey,
      @required this.currency,
      @required this.amount,
      @required this.email,
      @required this.fullName,
      @required this.txRef,
      @required this.isDebugMode,
      @required this.phoneNumber,
      this.acceptAccountPayment = false,
      this.acceptBankTransferPayment = false,
      this.acceptCardPayment = false,
      this.acceptUSSDPayment = false,
      this.acceptUKAccountPayment = false,
      this.acceptSouthAfricaBankPayment = false,
      this.acceptRwandaMoneyPayment = false,
      this.acceptMpesaPayment = false,
      this.acceptZambiaPayment = false,
      this.acceptGhanaPayment = false,
      this.acceptUgandaPayment = false,
      this.acceptFancophoneMobileMoney = false,
      this.acceptBarterPayment = false,
      this.frequency,
      this.duration,
      this.isPermanent,
      this.narration,
      this.network = ""});

  CardPaymentManager getCardPaymentManager() {
    return CardPaymentManager(
        publicKey: this.publicKey,
        encryptionKey: this.encryptionKey,
        currency: this.currency,
        email: this.email,
        fullName: this.fullName,
        amount: this.amount,
        txRef: this.txRef,
        isDebugMode: this.isDebugMode,
        narration: this.narration,
        isPermanent: this.isPermanent,
        phoneNumber: this.phoneNumber,
        frequency: this.frequency,
        duration: this.duration);
  }

  BankTransferPaymentManager getBankTransferPaymentManager() {
    return BankTransferPaymentManager(
        publicKey: this.publicKey,
        currency: this.currency,
        email: this.email,
        amount: this.amount,
        txRef: this.txRef,
        isDebugMode: this.isDebugMode,
        narration: this.narration,
        isPermanent: this.isPermanent,
        phoneNumber: this.phoneNumber,
        frequency: this.frequency,
        duration: this.duration);
  }

  BankAccountPaymentManager getBankAccountPaymentManager() {
    return BankAccountPaymentManager(
        publicKey: this.publicKey,
        currency: this.currency,
        email: this.email,
        amount: this.amount,
        txRef: this.txRef,
        isDebugMode: this.isDebugMode,
        phoneNumber: this.phoneNumber,
        fullName: this.fullName);
  }

  USSDPaymentManager getUSSDPaymentManager() {
    return USSDPaymentManager(
        publicKey: this.publicKey,
        currency: this.currency,
        email: this.email,
        amount: this.amount,
        txRef: this.txRef,
        isDebugMode: this.isDebugMode,
        phoneNumber: this.phoneNumber,
        fullName: this.fullName);
  }

  MobileMoneyPaymentManager getMobileMoneyPaymentManager() {
    return MobileMoneyPaymentManager(
        publicKey: this.publicKey,
        currency: this.currency,
        network: this.network,
        amount: this.amount,
        txRef: this.txRef,
        isDebugMode: this.isDebugMode,
        phoneNumber: this.phoneNumber,
        fullName: this.fullName,
        email: this.email);
  }
}
