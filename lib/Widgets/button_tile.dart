import 'package:flutter/material.dart';
import 'package:crimemapping/palette.dart';

class ButtonTile extends StatelessWidget {
  final Function onPress;
  final String text;
  ButtonTile({this.onPress, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFFbb3fdd),
                  Color(0xFFfb6da9),
                  Color(0xFFff9f7c),
                ])),
        child: TextButton(
          onPressed: onPress,
          child: Text(
            text,
            style: TextStyle(fontSize: 15),
          ),
          // style: ElevatedButton.styleFrom(primary: Colors.transparent),
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.transparent)),
        ),
      ),
    );
  }
}
