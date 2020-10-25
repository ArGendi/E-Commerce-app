import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/providers/favorite.dart';
import 'package:provider/provider.dart';

class WishListInfo {
  addToWishList(Product product, context){
    Favorite favorite = Provider.of<Favorite>(context);
    if(!favorite.favProducts.contains(product)){
      favorite.addProduct(product);
    }
  }
}