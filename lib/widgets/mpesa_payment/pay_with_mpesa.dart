import 'package:flutter/material.dart';
import 'package:flutterwave/core/utils/flutterwave_api_utils.dart';
import 'package:flutterwave/models/requests/mpesa/mpesa_request.dart';
import 'package:http/http.dart' as http;
import 'package:flutterwave/core/mpesa/mpesa_payment_manager.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';
import 'package:hexcolor/hexcolor.dart';

class PayWithMpesa extends StatefulWidget {
  final MpesaPaymentManager _paymentManager;

  PayWithMpesa(this._paymentManager);

  @override
  _PayWithMpesaState createState() => _PayWithMpesaState();
}

class _PayWithMpesaState extends State<PayWithMpesa> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController networkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  BuildContext loadingDialogContext;

  @override
  Widget build(BuildContext context) {
    final String initialPhoneNumber = this.widget._paymentManager.phoneNumber;
    this._phoneNumberController.text =
        initialPhoneNumber != null ? initialPhoneNumber : "";

    final String currency = this.widget._paymentManager.currency;
    return MaterialApp(
      home: Scaffold(
        key: this._scaffoldKey,
        appBar: AppBar(
          backgroundColor: Hexcolor("#fff1d0"),
          title: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: "Pay with ",
              style: TextStyle(fontSize: 20, color: Colors.black),
              children: [
                TextSpan(
                  text: "Mpesa",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                )
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 35, 20, 20),
            width: double.infinity,
            child: Form(
              key: this._formKey,
              child: ListView(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      hintText: "Phone Number",
                    ),
                    controller: this._phoneNumberController,
                    validator: (value) =>
                        value.isEmpty ? "Phone number is required" : null,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(0, 40, 0, 20),
                    child: RaisedButton(
                      onPressed: this._onPayPressed,
                      color: Colors.orange,
                      child: Text(
                        "Pay with Mpesa",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPayPressed() {
    if (this._formKey.currentState.validate()) {
      this._removeFocusFromView();
      this._handlePayment();
    }
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        this.loadingDialogContext = context;
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.orangeAccent,
              ),
              SizedBox(
                width: 40,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        );
      },
    );
  }

  void closeDialog() {
    if (this.loadingDialogContext != null) {
      Navigator.of(this.loadingDialogContext).pop();
      this.loadingDialogContext = null;
    }
  }

  void _removeFocusFromView() {
    FocusScope.of(this.context).requestFocus(FocusNode());
  }

  void showSnackBar(String message) {
    SnackBar snackBar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    );
    this._scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _handlePayment() async {
    this.showLoading("initiating payment...");
    final MpesaPaymentManager mpesaPaymentManager = this.widget._paymentManager;

    final MpesaRequest request = MpesaRequest(
        amount: mpesaPaymentManager.amount,
        currency: mpesaPaymentManager.currency,
        txRef: mpesaPaymentManager.txRef,
        fullName: mpesaPaymentManager.fullName,
        email: mpesaPaymentManager.email,
        phoneNumber: this._phoneNumberController.text);

    final http.Client client = http.Client();
    try {
      final response = await mpesaPaymentManager.payWithMpesa(request, client);
      this.closeDialog();
      if (FlutterwaveUtils.SUCCESS == response.status &&
          FlutterwaveUtils.CHARGE_INITIATED == response.message) {
        this._verifyPayment(response.data.flwRef);
      } else {
        this.showSnackBar(response.message);
      }
    } catch (error) {
      this.closeDialog();
      this.showSnackBar(error.toString());
    }
  }

  void _verifyPayment(final String flwRef) async {
    this.showLoading("verifying payment...");
    final client = http.Client();
    try {
      final response = await FlutterwaveAPIUtils.verifyPayment(
          flwRef,
          client,
          this.widget._paymentManager.publicKey,
          this.widget._paymentManager.isDebugMode);
      this.closeDialog();
      print("Verify Bank staus => ${response.data.status}");
      print("Verify Bank amount => ${response.data.amount}");
      print("Verify Bank flwRef => ${response.data.flwRef}");

      if (response.data.status == FlutterwaveUtils.SUCCESS &&
          response.data.amount == this.widget._paymentManager.amount &&
          response.data.flwRef == flwRef &&
          response.data.currency == this.widget._paymentManager.currency) {
        this.showSnackBar("Payment complete.");
        Navigator.of(this.context).pop(response);
      } else {
        print("response Data don't match");
        this.closeDialog();
        this.showSnackBar(response.data.status);
      }
    } catch (error) {
      this.showSnackBar(error.toString());
    }
  }
}
