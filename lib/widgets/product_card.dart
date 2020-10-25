import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/single_product.dart';
import 'package:ecommerce/providers/favorite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final Function click;

  const ProductCard({Key key, this.product, this.click}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Favorite favorite = Provider.of<Favorite>(context);
    double priceAfterSale = double.parse(widget.product.price) -  double.parse(widget.product.price) * (widget.product.sale / 100);
    return GestureDetector(
      onTap: widget.click,
      child: Stack(
        children: <Widget>[
          Container(
            width: size.width * .43,
            child: Image(
              image: AssetImage(widget.product.imageLocation),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Opacity(
              opacity: 0.97,
              child: Container(
                padding: const EdgeInsets.all(10),
                width: size.width * .4,
                height: size.height * .18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 20,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.product.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.product.category,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '\$' + widget.product.price,
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.black,
                                      decoration: widget.product.sale > 0 ? TextDecoration.lineThrough : TextDecoration.none,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n\$' + priceAfterSale.toString().split('.')[0],
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: widget.product.sale > 0 ? Colors.red : Colors.white,
                                    ),
                                  ),
                                ]
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                if(widget.product.favorite){
                                  widget.product.favorite = false;
                                  favorite.removeProduct(widget.product);
                                }
                                else{
                                  widget.product.favorite = true;
                                  favorite.addProduct(widget.product);
                                }
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              color: Colors.black,
                              child: Icon(
                                widget.product.favorite ? Icons.turned_in : Icons.turned_in_not,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
