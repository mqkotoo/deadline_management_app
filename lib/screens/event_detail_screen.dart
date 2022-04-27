import 'package:flutter/material.dart';
import 'package:futuristic_ui/futuristic_ui.dart';

class EventDetailScreen extends StatelessWidget {
  static const String id = 'detail';
  const EventDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('テスト'),
      ),
      body: Center(
        // child: FuturisticTile(
        //   title: Text('テスト'),
        //   subtitle: Text('てすと'),
        //   leading: Icon(Icons.watch),
        //   trailing: Icon(Icons.watch),
        //   decoration: BoxDecoration(
        //     color: Colors.purple,
        //     shape: BoxShape.circle
        //   ),
        // ),
        child: Text('テスト',style: TextStyle(fontSize: 20),),
      ),
    );
  }
}
