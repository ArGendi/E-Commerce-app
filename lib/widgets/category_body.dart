import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/single_product.dart';
import 'package:ecommerce/widgets/product_card.dart';
import 'package:flutter/material.dart';

class CategoryBody extends StatelessWidget {
  final List<Product> products;

  const CategoryBody({Key key, this.products}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 18,
            mainAxisSpacing: 20,
            crossAxisCount: 2,
            childAspectRatio: 0.7
          ),
          itemBuilder: (context, index){
            return ProductCard(
              product: products[index],
              click: (){
                Navigator.pushNamed(context, SingleProduct.id, arguments: products[index]);
              },
            );
          },
          itemCount: products.length,
      ),
    );
  }
}
