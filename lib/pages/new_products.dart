import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/cart.dart';
import 'package:ecommerce/providers/cart_item.dart';
import 'package:ecommerce/providers/products.dart';
import 'package:ecommerce/widgets/category_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewProducts extends StatelessWidget {
  static final String id = 'new products';

  List<Product> getNewProducts(List<Product> products){
    List<Product> newProducts = [];
    for(var product in products){
      if(product.isNew) newProducts.add(product);
    }
    return newProducts;
  }

  @override
  Widget build(BuildContext context) {
    Products products = Provider.of<Products>(context);
    List<Product> newProducts = getNewProducts(products.products);
    int cartItemsLength = Provider.of<CartItem>(context).products.length;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'New',
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
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: CategoryBody(products: newProducts,),
    );
  }
}
