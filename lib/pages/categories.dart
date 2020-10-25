import 'package:ecommerce/constants.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/cart.dart';
import 'package:ecommerce/providers/cart_item.dart';
import 'package:ecommerce/providers/products.dart';
import 'package:ecommerce/services/store.dart';
import 'package:ecommerce/widgets/category_body.dart';
import 'package:ecommerce/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  static final String id = 'categories';

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<List<Product>> categories = List<List<Product>>();

  @override
  Widget build(BuildContext context) {
    int tabIndex = ModalRoute.of(context).settings.arguments;
    categories = Provider.of<Products>(context).categories;
    int cartItemsLength = Provider.of<CartItem>(context).products.length;
    return DefaultTabController(
      initialIndex: tabIndex,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            'Categories',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            Stack(
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    Navigator.pushNamed(context, Cart.id);
                  },
                  icon: Icon(Icons.shopping_cart),
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: Opacity(
                    opacity: cartItemsLength > 0 ? 1 : 0,
                    child: Container(
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        cartItemsLength.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: 'Blouses',),
              Tab(text: 'Skirts',),
              Tab(text: 'Pants',),
            ],
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.grey[600],
            labelColor: Colors.black,
            labelStyle: TextStyle(
              fontSize: 18,
            ),
            indicatorSize: TabBarIndicatorSize.label,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            CategoryBody(products: categories[0],),
            CategoryBody(products: categories[1],),
            CategoryBody(products: categories[2],),
          ],
        ),
      ),
    );
  }
}
