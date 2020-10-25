import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/providers/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartInfo {
  addToCart(context,Product product, quantity, size){
    CartItem cartItem = Provider.of<CartItem>(context, listen: false);
    bool productFounded = false;
    product.quantity = quantity;
    if(size == 'Size'){
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Select your Size',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.white,
      ));
    }
    else{
      product.size = size;
      for(var p in cartItem.products){
        if(p.id == product.id)
          productFounded = true;
      }
      if(!productFounded){
        cartItem.addProduct(product);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            'Added to Cart',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.white,
        ));
      }
      else{
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            'Item already exist',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.white,
        ));
      }
    }
  }
}