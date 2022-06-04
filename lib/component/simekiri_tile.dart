import 'package:flutter/material.dart';

enum Menu { edit, delete }

class CustomTile extends StatelessWidget {
  CustomTile(
      {required this.title,
      required this.subtitle,
      required this.icon,
      Key? key})
      : super(key: key);

  String title;
  String subtitle;
  Icon icon;

  @override
  Widget build(BuildContext context) {

    var deviceSize = MediaQuery.of(context).size;

    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                deviceSize.width * 0.045,
                deviceSize.height * 0.007,
                deviceSize.width * 0.031,
                deviceSize.height * 0.007,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //subtitleがなかった場合paddingを入れてカードを大きくする
                      subtitle == ''
                          ? Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: deviceSize.width * 0.022),
                              child: Text(
                                title,
                                //17↓
                                style: TextStyle(fontSize: deviceSize.height * 0.02),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ))
                          //subtitleがあったら普通通り
                          : Text(
                              title,
                              //17↓
                              style: TextStyle(fontSize: deviceSize.height * 0.02),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                      subtitle == ''
                          //　subtitleがなかったらスペースが入るから、サイズボックス入れて、空白を無くす
                          ? SizedBox.shrink()
                          : Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                //12
                                fontSize: deviceSize.height * 0.014,
                                color: Colors.grey,
                              ),
                            ),
                    ],
                  ),
                ),
                icon,
                // popUpMenu
              ],
            ),
          ),
        ],
      ),
    );
  }
}
