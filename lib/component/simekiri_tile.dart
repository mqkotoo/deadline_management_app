import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  CustomTile(
      {required this.title,
        required this.subtitle,
        required this.onTap,
        Key? key})
      : super(key: key);
  String title;
  String subtitle;
  Function onTap;

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
            padding: const EdgeInsets.fromLTRB(20, 4, 4, 4),
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
                IconButton(
                  onPressed: () => onTap,
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}