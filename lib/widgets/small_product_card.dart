import 'package:ecommerce/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmallProductCard extends StatelessWidget {
  final Product product;
  final Function click;

  const SmallProductCard({Key key,this.click, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: click,
        child: Container(
          color: Colors.red,
          width: size.width * 0.5,
          child: Stack(
            children: <Widget>[
              // image
              Positioned.fill(
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage(product.imageLocation),
                ),
              ),
              // upper content
              Positioned(
                bottom: 0,
                child: Opacity(
                  opacity: .92,
                  child: Container(
                    height: 80,
                    width: size.width * 0.5,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            product.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              //fontWeight: FontWeight.w600
                            ),
                          ),
                          Text(
                            '-' + product.sale.toString() + '%',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
