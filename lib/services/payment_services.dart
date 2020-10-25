import 'dart:convert';
import 'package:ecommerce/pages/cart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret = 'sk_test_51HZkSdHErf50rqSk5ibVQwjExJ4MXdbP9c4icwrm6ZmGZcZbjCLTuVyBkQODl9q9g9iQw5xOd4CTeKD9AqMsdf5b00DVZFZLAs';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  static init(){
    StripePayment.setOptions(
        StripeOptions(
            publishableKey: "pk_test_51HZkSdHErf50rqSkoY7hYXOO6CLha3pTbjMFXsrUSAqUNyNc1SZ2PvLBfRfYANu0lhqhR9Pbc38IhvY15jLnI2LH00Z98juVxo",
            merchantId: "Test",
            androidPayMode: 'test',
        )
    );
  }
  static Future<StripeTransactionResponse> payViaExistingCard({String amount, String currency, CreditCard card}) async{
    try{
      var paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card),
      );
      var paymentIntent = await StripeService.createPaymentIntent(amount, currency);
      var response =  await StripePayment.confirmPaymentIntent(
          PaymentIntent(
            clientSecret: paymentIntent['client_secret'],
            paymentMethodId: paymentMethod.id,
          )
      );
      if(response.status == 'succeeded'){
        return StripeTransactionResponse(
          message: 'Transaction successful',
          success: true,
        );
      }
      else{
        return StripeTransactionResponse(
          message: 'Transaction Failed',
          success: false,
        );
      }
    }
    catch(e){
      return StripeTransactionResponse(
        message: 'Transaction failed: ${e.toString()}',
        success: false,
      );
    }
  }
  static Future<StripeTransactionResponse> payViaNewCard({String amount, String currency}) async{
    try{
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );
      var paymentIntent = await StripeService.createPaymentIntent(amount, currency);
      var response =  await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id,
        )
      );
      if(response.status == 'succeeded'){
        return StripeTransactionResponse(
          message: 'Transaction successful',
          success: true,
        );
      }
      else{
        return StripeTransactionResponse(
          message: 'Transaction Failed',
          success: false,
        );
      }
    }
    catch(e){
      return StripeTransactionResponse(
        message: 'Transaction failed: ${e.toString()}',
        success: false,
      );
    }
  }
  static Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try{
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        StripeService.paymentApiUrl,
        body: body,
        headers: StripeService.headers,
      );
      return jsonDecode(response.body);
    }catch(e){
      print('error charging user: ${e.toString()}');
    }
    return null;
  }
}