import 'package:ecommerce/models/product.dart';
import 'package:flutter/cupertino.dart';

class Products extends ChangeNotifier {
  List<Product> products = List<Product>();
  List<List<Product>> categories = [
    List<Product>(), // blouses
    List<Product>(), // skirts
    List<Product>(), // pants
  ];

  setProducts(List<Product> products){
    this.products = products;
    notifyListeners();
  }
  setCategories(List<List<Product>> categories){
    this.categories = categories;
    notifyListeners();
  }
}