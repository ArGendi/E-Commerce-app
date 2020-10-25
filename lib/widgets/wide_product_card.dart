import 'package:ecommerce/constants.dart';
import 'package:ecommerce/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WideProductCard extends StatelessWidget {
  final Product product;
  final Function click;

  const WideProductCard({Key key, this.click, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double priceAfterSale = double.parse(product.price) -  double.parse(product.price) * (product.sale / 100);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: click,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(15),
            height: size.height * .2,
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Image(
                  image: AssetImage(product.imageLocation),
                ),
                SizedBox(width: size.width * .1,),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(height: size.height * .01,),
                      Text(
                        'Trending fashion',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[500],
                        ),
                      ),
                      SizedBox(height: size.height * .01,),
                      RichText(
                        text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: '\$' + product.price,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  decoration: product.sale > 0 ? TextDecoration.lineThrough : TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: ' \$' + priceAfterSale.toString().split('.')[0],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: product.sale > 0 ? Colors.red : kAppBarColor,
                                ),
                              ),
                            ]
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
    );
  }
}
