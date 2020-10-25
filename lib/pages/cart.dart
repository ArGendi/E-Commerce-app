import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/payment.dart';
import 'package:ecommerce/providers/cart_item.dart';
import 'package:ecommerce/services/store.dart';
import 'package:ecommerce/widgets/wide_cart_card.dart';
import 'package:ecommerce/widgets/wide_product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  static final String id = 'cart';

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  Store _store = Store();
  double calculateTotalPriceAfterSale(List<Product> cartItems){
    double total = 0;
    for(var item in cartItems){
        total += (double.parse(item.price) -  double.parse(item.price) * (item.sale / 100)) * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appBarSize = AppBar().preferredSize;
    final statusBar = MediaQuery.of(context).padding.top;
    CartItem cartItem = Provider.of<CartItem>(context);
    double totalPriceAfterSale = calculateTotalPriceAfterSale(cartItem.products);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Cart',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constrains) {
          if(cartItem.products.isNotEmpty){
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    height: size.height - (size.height * .2 + appBarSize.height + statusBar),
                    child: ListView.builder(
                      itemBuilder: (context,index) {
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          key: Key(cartItem.products[index].id),
                          onDismissed: (direction){
                            setState(() {
                              cartItem.removeProduct(cartItem.products[index]);
                            });
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            color: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 40),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                          child: WideCartCard(
                            product: cartItem.products[index],
                          ),
                        );
                      },
                      itemCount: cartItem.products.length,
                    ),
                  ),
                ),
                Container(
                  height: size.height * .2,
                  width: size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Items (${cartItem.products.length})',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\$' + totalPriceAfterSale.floor().toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * .01,),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Total price'.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\$' + totalPriceAfterSale.floor().toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //SizedBox(height: size.height * .02,),
                        ButtonTheme(
                          minWidth: size.width,
                          height: size.height * .07,
                          child: FlatButton(
                            color: Colors.black,
                            textColor: Colors.white,
                            onPressed: (){
                              Navigator.pushNamed(context, Payment.id, arguments: totalPriceAfterSale);
                            },
                            child: Text(
                              'Checkout',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            shape: RoundedRectangleBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          else return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.shopping_cart,
                  color: Colors.grey[600],
                  size: 40,
                ),
                Text(
                  'Empty Cart',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
