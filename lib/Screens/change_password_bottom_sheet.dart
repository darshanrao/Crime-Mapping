import 'package:crimemapping/Widgets/button_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../palette.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  @override
  _ChangePasswordBottomSheetState createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  bool passwordBool1;
  bool passwordBool2;
  bool passwordBool3;
  @override
  void initState() {
    passwordBool1 = true;
    passwordBool2 = true;
    passwordBool3 = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Color(0xFF000014),
        child: Container(
          decoration: BoxDecoration(
            color: kBackGroundColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            child: Column(
              children: [
                ButtonTile(text: 'Change Password'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TextField(
                    obscureText: passwordBool1,
                    cursorColor: kSecondaryColor,
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Password',
                      suffixIcon: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            passwordBool1 = passwordBool1 ? false : true;
                          });
                        },
                        icon: passwordBool1
                            ? Icon(
                                CupertinoIcons.eye_slash_fill,
                                size: 16,
                                color: kPrimaryColor,
                              )
                            : Icon(
                                CupertinoIcons.eye_fill,
                                size: 16,
                                color: kPrimaryColor,
                              ),
                        label: SizedBox(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TextField(
                    obscureText: passwordBool2,
                    cursorColor: kSecondaryColor,
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Confirm Password',
                      suffixIcon: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            passwordBool2 = passwordBool2 ? false : true;
                          });
                        },
                        icon: passwordBool2
                            ? Icon(
                                CupertinoIcons.eye_slash_fill,
                                size: 16,
                                color: kPrimaryColor,
                              )
                            : Icon(
                                CupertinoIcons.eye_fill,
                                size: 16,
                                color: kPrimaryColor,
                              ),
                        label: SizedBox(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TextField(
                    obscureText: passwordBool3,
                    cursorColor: kSecondaryColor,
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Confirm Password',
                      suffixIcon: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            passwordBool3 = passwordBool3 ? false : true;
                          });
                        },
                        icon: passwordBool3
                            ? Icon(
                                CupertinoIcons.eye_slash_fill,
                                size: 16,
                                color: kPrimaryColor,
                              )
                            : Icon(
                                CupertinoIcons.eye_fill,
                                size: 16,
                                color: kPrimaryColor,
                              ),
                        label: SizedBox(),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    ButtonTile(
                      onPress: () {
                        Navigator.pop(context);
                      },
                      text: 'Save',
                    ),
                    ButtonTile(
                        onPress: () {
                          Navigator.pop(context);
                        },
                        text: 'Cancel'),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
