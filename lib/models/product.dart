class Product {
  String id;
  String name;
  String price;
  String category;
  String description;
  bool favorite = false;
  bool isNew = false;
  int sale = 0;
  int quantity = 0;
  String size;
  String imageLocation;
  String additionalImage1Location;
  String additionalImage2Location;
  String additionalImage3Location;

  Product({this.id, this.price,this.sale, this.name, this.category, this.description,
    this.isNew, this.favorite,
    this.imageLocation, this.additionalImage1Location,
    this.additionalImage2Location,this.additionalImage3Location});
}