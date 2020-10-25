import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/categories.dart';
import 'package:ecommerce/pages/single_product.dart';
import 'package:ecommerce/providers/products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataSearch extends SearchDelegate<String>{
  List history = ['No history'];
  List<String> categoriesNames = [
    'blouses',
    'skirts',
    'pants',
  ];
  List<Product> allProducts;
  List<String> selectedCategories;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(
      icon: Icon(Icons.clear),
      onPressed: (){
        query = '';
      },
    )];
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> products = Provider.of<Products>(context).products;
    selectedCategories = categoriesNames.where((element) => element.contains(query)).toList();
    allProducts = products.where((element) => element.name.contains(query)).toList();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if(query.isEmpty){
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Categories',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: Container(
                    height: 120,
                    child: Expanded(
                      child: ListView.builder(
                        itemCount: categoriesNames.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, Categories.id, arguments: index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Text(
                              categoriesNames[index],
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        else {
          return ListView(
            children: <Widget>[
              Container(
                height: 55.0 * selectedCategories.length,
                child: ListView.builder(
                  itemBuilder: (context,index,) =>
                      ListTile(
                        onTap: (){
                          int tabIndex = 0;
                          if(selectedCategories[index] == 'blouses') tabIndex = 0;
                          else if(selectedCategories[index] == 'skirts') tabIndex = 1;
                          else if(selectedCategories[index] == 'pants') tabIndex = 2;
                          Navigator.pushNamed(context, Categories.id, arguments: tabIndex);
                        },
                        leading: Icon(Icons.search),
                        title: Text(
                          query.isEmpty ? history[index] : selectedCategories[index],
                        ),
                        subtitle: query.isEmpty ? Text('') : Text('Category'),
                      ),
                  itemCount: query.isEmpty ? history.length : selectedCategories.length,
                  itemExtent: 50,
                ),
              ),
              Divider(),
              Container(
                height: 55.0 * allProducts.length,
                child: ListView.builder(
                  itemBuilder: (context,index) =>
                      ListTile(
                        onTap: (){
                          Navigator.pushNamed(context, SingleProduct.id, arguments: allProducts[index]);
                        },
                        leading: Icon(Icons.search),
                        title: Text(
                          query.isEmpty ? '' : allProducts[index].name,
                        ),
                        subtitle: Text('Product'),
                      ),
                  itemCount: query.isEmpty ? 0 : allProducts.length,
                  itemExtent: 50,
                ),
              ),
            ],
          );
        }
      },
    );
    throw UnimplementedError();
  }
}