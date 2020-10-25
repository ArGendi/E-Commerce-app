import 'package:ecommerce/constants.dart';
import 'package:ecommerce/pages/cart.dart';
import 'package:ecommerce/pages/categories.dart';
import 'package:ecommerce/pages/email_requried.dart';
import 'package:ecommerce/pages/email_verification.dart';
import 'package:ecommerce/pages/existing_card.dart';
import 'package:ecommerce/pages/home.dart';
import 'package:ecommerce/pages/hot_offers.dart';
import 'package:ecommerce/pages/login.dart';
import 'package:ecommerce/pages/new_products.dart';
import 'package:ecommerce/pages/payment.dart';
import 'package:ecommerce/pages/signup.dart';
import 'package:ecommerce/pages/single_product.dart';
import 'package:ecommerce/pages/wishlist.dart';
import 'package:ecommerce/providers/cart_item.dart';
import 'package:ecommerce/providers/favorite.dart';
import 'package:ecommerce/providers/modelHud.dart';
import 'package:ecommerce/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ModelHud>(
          create: (context) => ModelHud(),
        ),
        ChangeNotifierProvider<CartItem>(
          create: (context) => CartItem(),
        ),
        ChangeNotifierProvider<Products>(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider<Favorite>(
          create: (context) => Favorite(),
        ),
      ],
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'Montserrat',
            appBarTheme: AppBarTheme(
              color: kAppBarColor,
            ),
          ),
          debugShowCheckedModeBanner: false,
          title: 'E-Commerce',
          initialRoute: HomePage.id,
          routes: {
            LoginPage.id: (context) => LoginPage(),
            SignUpPage.id: (context) => SignUpPage(),
            EmailVerification.id: (context) => EmailVerification(),
            EmailRequired.id: (context) => EmailRequired(),
            HomePage.id: (context) => HomePage(),
            SingleProduct.id: (context) => SingleProduct(),
            Categories.id: (context) => Categories(),
            Cart.id: (context) => Cart(),
            WishList.id: (context) => WishList(),
            HotOffers.id: (context) => HotOffers(),
            NewProducts.id: (context) => NewProducts(),
            Payment.id: (context) => Payment(),
            ExistingCard.id: (context) => ExistingCard(),
          },
        ),
      );
  }
}