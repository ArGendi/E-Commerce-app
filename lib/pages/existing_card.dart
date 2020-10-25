import 'package:ecommerce/providers/cart_item.dart';
import 'package:ecommerce/services/payment_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

class ExistingCard extends StatefulWidget {
  static final String id = 'existing card';

  @override
  _ExistingCardState createState() => _ExistingCardState();
}

class _ExistingCardState extends State<ExistingCard> {
  List cards = [{
    'cardNumber': '4242424242424242',
    'expiryDate': '04/24',
    'cardHolderName': 'Muhammed Gamal',
    'cvvCode': '424',
    'showBackView': false,
    },{
    'cardNumber': '5555555555554444',
    'expiryDate': '04/23',
    'cardHolderName': 'Abdelrahman Abdallah',
    'cvvCode': '123',
    'showBackView': false,
    },
  ];

  payViaExistingCard(BuildContext context, card, double totalPrice, CartItem cartItem) async{
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(
      message: 'Please wait...',
    );
    await dialog.show();
    var expiryArr = card['expiryDate'].split('/');
    CreditCard stripeCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),

    );
    var response = await StripeService.payViaExistingCard(
      amount: totalPrice.toString().split('.')[0] + '00',
      currency: 'EGP',
      card: stripeCard,
    );
    await dialog.hide();
    if(response.success){
      cartItem.clearAll();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          duration: Duration(milliseconds: 1200),
        ),
      ).closed.then((_){
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = ModalRoute.of(context).settings.arguments;
    CartItem cartItem = Provider.of<CartItem>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Existing Card',
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (context, index){
            var card = cards[index];
            return InkWell(
              onTap: (){
                payViaExistingCard(context, card, totalPrice, cartItem);
              },
              child: CreditCardWidget(
                cardNumber: card['cardNumber'],
                expiryDate: card['expiryDate'],
                cardHolderName: card['cardHolderName'],
                cvvCode: card['cvvCode'],
                showBackView: false,
              ),
            );
          },
        ),
      ),
    );
  }
}
