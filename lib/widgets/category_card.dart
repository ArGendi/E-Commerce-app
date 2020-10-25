import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String imageLocation;
  final String text;
  final Function click;

  const CategoryCard({Key key, this.imageLocation, this.text, this.click}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: click,
      child: Container(
        width: size.width,
        height: 200,
        child: Stack(
          children: <Widget>[
            Image(
              fit: BoxFit.cover,
              image: AssetImage(imageLocation),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Opacity(
                opacity: .9,
                child: Container(
                  alignment: Alignment.center,
                  width: size.width * .42,
                  height: 60,
                  color: Colors.white,
                  child: Text(
                    text.toUpperCase(),
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
