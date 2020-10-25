import 'package:ecommerce/pages/existing_card.dart';
import 'package:ecommerce/providers/cart_item.dart';
import 'package:ecommerce/services/payment_services.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'cart.dart';

class Payment extends StatefulWidget {
  static final String id = 'payment';

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {

  @override
  void initState() {
    StripeService.init();
    super.initState();
  }

  payViaNewCard(BuildContext context, double totalPrice, CartItem cartItem) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(
      message: 'Please wait...',
    );
    await dialog.show();
    var response = await StripeService.payViaNewCard(
      amount: totalPrice.toString().split('.')[0] + '00',
      currency: 'EGP',
    );
    await dialog.hide();
    if(response.success){
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          duration: Duration(milliseconds: 1200),
        ),
      );
      cartItem.clearAll();
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
          'Payments',
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            itemBuilder: (context, index){
              Icon icon;
              Text text;
              switch(index){
                case 0:
                  icon = Icon(
                    Icons.add,
                    color: Colors.black,
                  );
                  text = Text('Pay via new card');
                  break;
                case 1:
                  icon = Icon(
                    Icons.credit_card,
                    color: Colors.black,
                  );
                  text = Text('Pay via existing card');
                  break;
              }
              return InkWell(
                onTap: () async{
                  switch(index){
                    case 0:
                      payViaNewCard(context, totalPrice, cartItem);
                      break;
                    case 1:
                      Navigator.pushNamed(context, ExistingCard.id, arguments: totalPrice);
                  }
                },
                child: ListTile(
                  title: text,
                  leading: icon,
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: 2
        ),
      ),
    );
  }
}
