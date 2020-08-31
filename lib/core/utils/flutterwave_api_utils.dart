import 'dart:convert';
import 'dart:io';
import 'package:flutterwave/core/flutterwave_error.dart';
import 'package:flutterwave/models/requests/verify_charge_request.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/models/responses/get_bank/get_bank_response.dart';
import 'package:flutterwave/models/responses/resolve_account/resolve_account_response.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';
import 'package:http/http.dart' as http;

class FlutterwaveAPIUtils {
  static Future<List<GetBanksResponse>> getBanks(
      final http.Client client) async {
    try {
      final response = await client.get(
        FlutterwaveUtils.GET_BANKS_URL,
      );
      if (response.statusCode == 200) {
        print("banks is ${jsonDecode(response.body).runtimeType}");
        final List<dynamic> jsonDecoded = jsonDecode(response.body);
        final banks =
            jsonDecoded.map((json) => GetBanksResponse.fromJson(json)).toList();

        return banks;
      } else {
        throw (FlutterWaveError(
            "Unable to fetch banks. Please contact support"));
      }
    } catch (error) {
      throw (FlutterWaveError(error.toString()));
    } finally {
      client.close();
    }
  }

  static Future<ResolveAccountResponse> resolveAccount(
      final http.Client client) async {
    try {
      final response = await client.get(FlutterwaveUtils.GET_BANKS_URL);
      print("resolved is ${jsonDecode(response.body).runtimeType}");
      final ResolveAccountResponse resolveAccountResponse =
          jsonDecode(response.body);
      return resolveAccountResponse;
    } catch (error) {
      throw (FlutterWaveError(error.toString()));
    } finally {
      client.close();
    }
  }

  static Future<ChargeResponse> verifyPayment(
      final String flwRef,
      final http.Client client,
      final String publicKey,
      final bool isDebugMode) async {
    final url = FlutterwaveUtils.getBaseUrl(isDebugMode) +
        FlutterwaveUtils.VERIFY_TRANSACTION;
    final VerifyChargeRequest verifyRequest = VerifyChargeRequest(flwRef);
    final payload = verifyRequest.toJson();
    print("Verify Bank Url => $url");
    print("Verify Bank Request Payload => ${verifyRequest.toJson()}");
    try {
      final http.Response response = await client.post(url,
          headers: {HttpHeaders.authorizationHeader: publicKey}, body: payload);

      final ChargeResponse cardResponse =
          ChargeResponse.fromJson(jsonDecode(response.body));
      print("Verify Bank Response Payload => ${cardResponse.toJson()}");
      return cardResponse;
    } catch (error) {
      throw (FlutterWaveError(error.toString()));
    } finally {
      client.close();
    }
  }
}
