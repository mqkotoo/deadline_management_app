// 赤、青、黒、白、黄色、緑、オレンジ、ピンク、

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/theme/theme_provider.dart' as theme;
import '../calendar_screen.dart';

class ChangeThemeScreen extends StatefulHookConsumerWidget {

  static const String id = 'changeTheme';

  @override
  _ChangeThemeScreenState createState() => _ChangeThemeScreenState();
}

class _ChangeThemeScreenState extends ConsumerState<ChangeThemeScreen> {
  @override
  Widget build(BuildContext context) {

    var themeProvider = ref.watch(theme.ThemeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('テーマ着せ替え',style: TextStyle(color: Theme.of(context).selectedRowColor)),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios,
            color: Theme.of(context).selectedRowColor,
          ),
        ),
      ),
      body : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //dark
                _colorContainer(
                  onPress: () => themeProvider.changeDarkTheme(),
                  color: Color(0xff212121),
                ),

                Spacer(),

                //pink
                _colorContainer(
                  onPress: () => themeProvider.changePinkTheme(),
                  color: Colors.pink[200],
                ),

                Spacer(),

                //light
                _colorContainer(
                  onPress: () => themeProvider.changeLightTheme(),
                  color: Color(0xFFfffaf0),
                ),

                Spacer(),

                //  blue
                _colorContainer(
                  onPress: () => themeProvider.changeBlueTheme(),
                  color: Colors.blue,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //  orange
                _colorContainer(
                  onPress: () => themeProvider.changeOrangeTheme(),
                  color: Colors.orange,
                ),

                Spacer(),

                //  red
                _colorContainer(
                  onPress: () => themeProvider.changeRedTheme(),
                  color: Colors.red,
                ),

                Spacer(),

                //  green
                _colorContainer(
                  onPress: () => themeProvider.changeGreenTheme(),
                  color: Colors.green,
                ),

                Spacer(),

                //  yellow
                _colorContainer(
                  onPress: () => themeProvider.changeYellowTheme(),
                  color: Colors.yellow,
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () =>  Navigator.popUntil(
              context, ModalRoute.withName(CalendarScreen.id)),
              child: Text('決定'),
          )
        ],
      ),
    );
  }

  Widget _colorContainer({required void Function()? onPress,required Color? color}) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 70,
        height: 70,
      ),
    );
  }
}



