import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/add_event_screen.dart';

enum Menu {edit, delete}

class CustomTile extends StatelessWidget {

  CustomTile({required this.title, required this.subtitle, required this.popUpMenu,Key? key})
      : super(key: key);

  String title;
  String subtitle;
  Widget popUpMenu;

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
                      Text(
                        title,
                        style: const TextStyle(fontSize: 17),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
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
                popUpMenu
              ],
            ),
          ),
        ],
      ),
    );
  }
}

