import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/models/product.dart';

class Store {
  final Firestore _firestore = Firestore.instance;

  Stream<QuerySnapshot> loadProduct() {
    return _firestore.collection(kProductCollection).snapshots();
  }
  updateProduct(data, id){
    _firestore.collection(kProductCollection).document(id).updateData(data);
  }
  addOrder(Product product){
    _firestore.collection(kOrdersCollection).add({
      kProductName: product.name,
      kProductPrice: product.price,
      kProductDescription: product.description,
      kProductCategory: product.category,
      kProductIsNew: product.isNew,
      kProductImageLocation: product.imageLocation,
      kAdditionalImage1Location: product.additionalImage1Location,
      kAdditionalImage2Location: product.additionalImage2Location,
      kAdditionalImage3Location: product.additionalImage3Location,
      kProductSale: product.sale,
    });
  }
}