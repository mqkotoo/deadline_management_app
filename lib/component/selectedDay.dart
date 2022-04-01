import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class selectedDay extends StatelessWidget {
  const selectedDay({
    Key? key,
    required DateTime selectedDay,
  }) : _selectedDay = selectedDay, super(key: key);

  final DateTime _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Theme.of(context).primaryColor,
      width: MediaQuery.of(context).size.width,
      height: 54.78,
      child: Padding(
        padding: EdgeInsets.only(left: 30),
        child: Text(DateFormat.MMMEd('ja').format(_selectedDay),
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
      ),
    );
  }
}