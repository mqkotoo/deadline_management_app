import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class selectedDay extends StatelessWidget {
  const selectedDay({
    Key? key,
    required DateTime selectedDay,
    this.onTap
  }) : _selectedDay = selectedDay, super(key: key);

  final DateTime _selectedDay;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.centerLeft,
      color: Theme.of(context).primaryColor,
      width: deviceSize.width,
      // 55↓
      height: deviceSize.height * 0.061,
      child: Padding(
        padding: EdgeInsets.only(left: deviceSize.width * 0.072),
        child: Row(
          children: [
            Expanded(
              child: Text(DateFormat.MMMEd('ja').format(_selectedDay),
                style: TextStyle(
                    fontSize: deviceSize.height * 0.02,
                    fontWeight: FontWeight.bold,
                  color: Theme.of(context).selectedRowColor
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}