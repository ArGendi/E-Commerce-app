import 'package:ecommerce/pages/cart.dart';
import 'package:ecommerce/pages/login.dart';
import 'package:ecommerce/pages/wishlist.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerList extends StatefulWidget {
  @override
  _DrawerListState createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> futureSnapshot) {
        return ListView(
          children: <Widget>[
            Container(
              height: size.height * .24,
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: size.width * .16,
                    height: size.height * .08,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        )
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Text(
                    futureSnapshot.hasData ? futureSnapshot.data.email : 'Guest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Have a great day :)',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, Cart.id);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 20, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.shopping_cart,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: size.height * 0.03,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Cart',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, WishList.id);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.turned_in,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: size.height * 0.03,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'WishList',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.info,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: size.height * 0.03,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'About us',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.phone,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: size.height * 0.03,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Contact us',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  if(futureSnapshot.hasData){
                    FirebaseAuth.instance.signOut();
                  }
                  else
                    Navigator.pushNamed(context, LoginPage.id);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        futureSnapshot.hasData ? Icons.exit_to_app : Icons.lock_open,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: size.height * 0.03,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        futureSnapshot.hasData ? 'Log out' : 'Log in',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
