import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/add_event_screen.dart';

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
    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 13, 6),
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
                                  const EdgeInsets.symmetric(vertical: 9.0),
                              child: Text(
                                title,
                                style: const TextStyle(fontSize: 17),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ))
                          //subtitleがあったら普通通り
                          : Text(
                              title,
                              style: const TextStyle(fontSize: 17),
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
                              style: const TextStyle(
                                fontSize: 12,
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
