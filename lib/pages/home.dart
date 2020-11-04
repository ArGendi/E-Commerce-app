import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/pages/categories.dart';
import 'package:ecommerce/pages/hot_offers.dart';
import 'package:ecommerce/pages/new_products.dart';
import 'package:ecommerce/pages/single_product.dart';
import 'package:ecommerce/pages/wishlist.dart';
import 'package:ecommerce/providers/products.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:ecommerce/services/data_search.dart';
import 'package:ecommerce/services/store.dart';
import 'package:ecommerce/widgets/category_card.dart';
import 'package:ecommerce/widgets/drawer_list.dart';
import 'package:ecommerce/widgets/small_product_card.dart';
import 'package:ecommerce/widgets/wide_product_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/models/product.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static final String id = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Store _store = Store();
  final Auth _auth = Auth();
  FirebaseUser loggedUser;
  List<Product> allProducts = List<Product>();
  List<Product> sales = List<Product>();
  List<List<Product>> categories = [
    List<Product>(), // blouses
    List<Product>(), // skirts
    List<Product>(), // pants
  ];

  List<Product> getProducts(snapshot){
    for(List<Product> list in categories){
      list.clear();
    }
    sales.clear();
    List<Product> products = List<Product>();
    for(var doc in snapshot.data.documents){
      var data = doc.data;
      products.add(Product(
        name: data[kProductName],
        price: data[kProductPrice],
        sale: data[kProductSale],
        description: data[kProductDescription],
        category: data[kProductCategory],
        isNew: true,
        favorite: false,
        imageLocation: data[kProductImageLocation],
        additionalImage1Location: data[kAdditionalImage1Location],
        additionalImage2Location: data[kAdditionalImage2Location],
        additionalImage3Location: data[kAdditionalImage3Location],
        id: doc.documentID,
      ));

      if(data[kProductCategory] == 'blouses')
        categories[0].add(products[products.length - 1]);
      else if(data[kProductCategory] == 'skirts')
        categories[1].add(products[products.length - 1]);
      else if(data[kProductCategory] == 'pants')
        categories[2].add(products[products.length - 1]);

      if(data[kProductSale] > 0){
        if(sales.length == 4){
          for(int i=0; i<sales.length; i++){
            if(data[kProductSale] > sales[i].sale){
              sales[i] = data[kProductSale];
            }
          }
        }
        else sales.add(products[products.length - 1]);
      }
      sales.sort((Product a, Product b) => b.sale.compareTo(a.sale));
    }
    return products;
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Products _products = Provider.of<Products>(context);
    return Scaffold(
      drawer: Drawer(
        child: DrawerList(),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'E-Commerce'.toUpperCase(),
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              showSearch(context: context, delegate: DataSearch());
            },
            icon: Icon(Icons.search),
          ),
        ],
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: StreamBuilder(
        stream: _store.loadProduct(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            _products.products.clear();
            _products.categories = [
              List<Product>(), // blouses
              List<Product>(), // skirts
              List<Product>(), // pants
            ];
            _products.products = getProducts(snapshot);
            _products.categories = [...categories];
            categories = [
              List<Product>(), // blouses
              List<Product>(), // skirts
              List<Product>(), // pants
            ];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: ListView(
                children: <Widget>[
                  // Most popular
                  Row(
                    children: <Widget>[
                      Text(
                        'Hot Offers',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: size.width * .05,),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * .02,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Spring Summer 2020',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, HotOffers.id);
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * .01,),
                  // Horizontal ListView
                  Container(
                    height: 250,
                    child: ListView.builder(
                        itemCount: sales.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                          return SmallProductCard(
                            product: sales[index],
                            click: (){
                              Navigator.pushNamed(context, SingleProduct.id, arguments: sales[index]);
                            },
                          );
                        }
                    ),
                  ),
                  SizedBox(height: size.height * .02,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[500],
                        ),
                      ),
                      SizedBox(width: size.width * .05,),
                      Text(
                        'New',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: size.width * .05,),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * .01,),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, NewProducts.id);
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  WideProductCard(
                    product: _products.products[0],
                    click: (){
                      Navigator.pushNamed(context, SingleProduct.id, arguments: _products.products[0]);
                    },
                  ),
                  WideProductCard(
                    product: _products.products[1],
                    click: (){
                      Navigator.pushNamed(context, SingleProduct.id, arguments: _products.products[1]);
                    },
                  ),
                  WideProductCard(
                    product: _products.products[2],
                    click: (){
                      Navigator.pushNamed(context, SingleProduct.id, arguments: _products.products[2]);
                    },
                  ),
                  SizedBox(height: size.height * .02,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[500],
                        ),
                      ),
                      SizedBox(width: size.width * .05,),
                      Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * .02,),
                  CategoryCard(
                    imageLocation: 'assets/images/blouse.jpg',
                    text: 'Blouses',
                    click: (){
                      Navigator.pushNamed(context, Categories.id, arguments: 0);
                    },
                  ),
                  SizedBox(height: size.height * .02,),
                  CategoryCard(
                    imageLocation: 'assets/images/skirtt.jpg',
                    text: 'skirts',
                    click: (){
                      Navigator.pushNamed(context, Categories.id, arguments: 1);
                    },
                  ),
                  SizedBox(height: size.height * .02,),
                  CategoryCard(
                    imageLocation: 'assets/images/pant.jpg',
                    text: 'pants',
                    click: (){
                      Navigator.pushNamed(context, Categories.id, arguments: 2);
                    },
                  ),
                ],
              ),
            );
          }
          else{
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            );
          }
        },
      ),
    );
  }
}
