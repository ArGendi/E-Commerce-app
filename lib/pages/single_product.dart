import 'package:ecommerce/constants.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/cart.dart';
import 'package:ecommerce/providers/cart_item.dart';
import 'package:ecommerce/providers/favorite.dart';
import 'package:ecommerce/providers/products.dart';
import 'package:ecommerce/services/cart_info.dart';
import 'package:ecommerce/services/store.dart';
import 'package:ecommerce/widgets/empty_photo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/pages/cart.dart';

class SingleProduct extends StatefulWidget {
  static final String id = 'single product';
  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  final pageController = PageController(
    initialPage: 0,
  );
  int imageIndex = 0;
  bool fromPage = false;
  bool showDescription = false;
  Product product;
  String _selectedItem = 'Size';
  int quantity = 1;
  double priceAfterSale;

  List<Product> getProductCategory(){
    int index = -1;
    Products products = Provider.of<Products>(context);
    List<Product> relatedProducts = [];
    if(product.category == 'blouses') index = 0;
    else if(product.category == 'skirts') index = 1;
    else if(product.category == 'pants') index = 2;

    if(products.categories[index].length <= 3){
      for(int i=0; i<products.categories[index].length; i++){
        if(products.categories[index][i].id != product.id)
          relatedProducts.add(products.categories[index][i]);
      }
    }
    else {
      for(int i=0; i<=3; i++){
        if(products.categories[index][i].id != product.id)
          relatedProducts.add(products.categories[index][i]);
      }
    }
    return relatedProducts;
  }

  List<Widget> productImages(){
    List<Widget> images = [];
    if(product.imageLocation.length > 14){
      images.add(Image(
        fit: BoxFit.cover,
        image: AssetImage(product.imageLocation),
      ));
    }
    if(product.additionalImage1Location.length > 14){
      images.add(Image(
        fit: BoxFit.cover,
        image: AssetImage(product.additionalImage1Location),
      ));
    }
    if(product.additionalImage2Location.length > 14){
      images.add(Image(
        fit: BoxFit.cover,
        image: AssetImage(product.additionalImage2Location),
      ));
    }
    if(product.additionalImage3Location.length > 14){
      images.add(Image(
        fit: BoxFit.cover,
        image: AssetImage(product.additionalImage3Location),
      ));
    }
    return images;
  }

  Widget sizeListTile(String productSize){
    return ListTile(
      title: Text(
        productSize,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      onTap: (){
        Navigator.pop(context);
        setState(() {
          _selectedItem = productSize;
          fromPage = true;
        });
      },
    );
  }

  sizeBottomSheet(){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            height: 360,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    'Choose your size',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //SizedBox(height: 10,),
                sizeListTile('XS'),
                sizeListTile('S'),
                sizeListTile('M'),
                sizeListTile('L'),
                sizeListTile('XL'),
              ],
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    product = fromPage ? product : ModalRoute.of(context).settings.arguments;
    priceAfterSale = double.parse(product.price) -  double.parse(product.price) * (product.sale / 100);
    final size = MediaQuery.of(context).size;
    int cartItemsLength = Provider.of<CartItem>(context).products.length;
    Favorite favorite = Provider.of<Favorite>(context);

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: size.width,
                height: 460,
                child: PageView(
                  onPageChanged: (index){
                    setState(() {
                      fromPage = true;
                      imageIndex = index;
                    });
                  },
                  scrollDirection: Axis.vertical,
                  controller: pageController,
                  children: productImages(),
                ),
              ),
              Positioned(
                top: 10,
                left: 5,
                child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ),
              Positioned(
                top: 10,
                right: 5,
                child: Stack(
                  children: <Widget>[
                    IconButton(
                      onPressed: (){
                        Navigator.pushNamed(context, Cart.id);
                      },
                      icon: Icon(Icons.shopping_cart),
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Opacity(
                        opacity: cartItemsLength > 0 ? 1 : 0,
                        child: Container(
                          height: 20,
                          width: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            cartItemsLength.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 200,
                left: 10,
                child: Container(
                  width: 20,
                  height: 50,
                  child: ListView.builder(
                    itemCount: productImages().length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: imageIndex == index ? Colors.black : Colors.grey[500],
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                right: 15,
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      if(product.favorite) {
                        product.favorite = false;
                        favorite.removeProduct(product);
                      }
                      else {
                        product.favorite = true;
                        favorite.addProduct(product);
                      }
                    });
                  },
                  child: Container(
                    width: size.width * .11,
                    height: size.height * .055,
                    color: Colors.black,
                    child: Icon(
                      product.favorite ? Icons.turned_in : Icons.turned_in_not,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * .01,),
          Divider(
            indent: size.width * .42,
            endIndent: size.width * .42,
            thickness: 2,
            color: Colors.black,
          ),
          SizedBox(height: size.height * .01,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    product.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 22,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '\$' + product.price ,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            decoration: product.sale > 0 ? TextDecoration.lineThrough : TextDecoration.none,
                          ),
                        ),
                        TextSpan(
                          text: ' \$' + priceAfterSale.toString().split('.')[0],
                          style: TextStyle(
                            fontSize: 24,
                            color: product.sale > 0 ? Colors.red : kAppBarColor,
                          ),
                        ),
                      ]
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                RatingBar(
                  itemSize: 26,
                  initialRating: 4.5,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
                Text(' 17 rates'),
              ],
            ),
          ),
          SizedBox(height: size.height * .02,),
          InkWell(
            onTap: (){
              setState(() {
                showDescription = !showDescription;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Icon(showDescription ?Icons.keyboard_arrow_left : Icons.keyboard_arrow_down),
                    ],
                  ),
                  if(showDescription)...[
                    SizedBox(height: size.height * .005,),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor'
                          ' incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,'
                          ' quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo'
                          ' consequat. Duis aute irure dolor in reprehenderit in voluptate velit'
                          ' esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat'
                          ' cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id'
                          ' est laborum',
                    ),
                  ],
                ],
              ),
            ),
          ),
          Divider(),
          SizedBox(height: size.height * .01,),
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    sizeBottomSheet();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _selectedItem,
                              style: TextStyle(),
                            ),
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: (){
                    if(quantity > 1) {
                      setState(() { quantity--; });
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.black,
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Text(
                quantity.toString(),
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: (){
                    if(quantity < 10) {
                      setState(() { quantity++; });
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.black,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * .02,),
          Builder(
            builder:(context) => GestureDetector(
              onTap: () async{
                CartInfo cartInfo = CartInfo();
                if(_selectedItem == 'Size'){
                  sizeBottomSheet();
                }
                else
                  cartInfo.addToCart(context, product, quantity, _selectedItem);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  alignment: Alignment.center,
                  width: size.width,
                  height: 50,
                  color: Colors.black,
                  child: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * .02,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Divider(thickness: 1,)),
                Text(
                  '\tRelated Products\t',
                ),
                Expanded(child: Divider(thickness: 1,)),
              ],
            ),
          ),
          SizedBox(height: size.height * .02,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 200,
              child: ListView.builder(
                itemCount: getProductCategory().length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  List<Product> relatedProducts = getProductCategory();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, SingleProduct.id, arguments: relatedProducts[index]);
                      },
                      child: Image(
                        image: AssetImage(relatedProducts[index].imageLocation),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: size.height * .02,),
        ],
      ),
    );
  }
}
