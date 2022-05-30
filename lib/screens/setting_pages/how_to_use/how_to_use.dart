import 'package:flutter/material.dart';

class HowToUseScreen extends StatelessWidget {

  static const String id = 'howToUse';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "アプリの使い方",
            style: TextStyle(color: Theme.of(context).selectedRowColor)
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).selectedRowColor,
          ),
        ),
      ),

      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Image.asset('images/home_add.png'),
                _imageContainer(context,'images/home_add.png'),
                _imageContainer(context,'images/home_add.png'),
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget _imageContainer(context,String imagePath) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
            //画像の外枠に黒線をつける
            border: Border.all(width: 1)
        ),
      child: Image.asset(imagePath),
    );
  }

}
