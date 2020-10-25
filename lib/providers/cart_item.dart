import 'package:ecommerce/models/product.dart';
import 'package:flutter/cupertino.dart';

class CartItem extends ChangeNotifier {
  List<Product> products = List<Product>();

  addProduct(Product product){
    products.add(product);
    notifyListeners();
  }
  removeProduct(Product product){
    products.remove(product);
    notifyListeners();
  }
  clearAll(){
    products.clear();
    notifyListeners();
  }
}