import 'package:ecommerce/models/product.dart';
import 'package:flutter/cupertino.dart';

class Favorite extends ChangeNotifier {
  List<Product> favProducts = List<Product>();

  addProduct(Product product){
    favProducts.add(product);
    notifyListeners();
  }
  removeProduct(Product product){
    favProducts.remove(product);
    notifyListeners();
  }
}