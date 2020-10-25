import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/single_product.dart';
import 'package:ecommerce/providers/favorite.dart';
import 'package:ecommerce/providers/products.dart';
import 'package:ecommerce/widgets/wide_cart_card.dart';
import 'package:ecommerce/widgets/wide_product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishList extends StatefulWidget {
  static final String id = 'wish list';
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
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
    List<Product> favList = Provider.of<Favorite>(context).favProducts;
    List<Product> products = Provider.of<Products>(context).products;
    double totalPrice = calculateTotalPriceAfterSale(favList);
    return  Scaffold(
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
          'Wishlist',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
          builder: (context, constrains) {
            if(favList.isNotEmpty){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  itemBuilder: (context,index) {
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      key: Key(favList[index].id),
                      onDismissed: (direction){
                        setState(() {
                          products[products.indexOf(favList[index])].favorite = false;
                          favList.removeAt(index);
                        });
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                      child: WideProductCard(
                        product: favList[index],
                        click: (){
                          Navigator.pushNamed(context, SingleProduct.id, arguments: favList[index]);
                        },
                      ),
                    );
                  },
                  itemCount: favList.length,
                ),
              );
            }
            else return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.turned_in,
                    color: Colors.grey[600],
                    size: 50,
                  ),
                  SizedBox(height: size.height * .01,),
                  Text(
                    'Empty Wishlist',
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
