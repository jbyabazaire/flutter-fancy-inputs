import 'package:flutter/material.dart';

enum IconSide { LEFT, RIGHT }

class FancyButton extends StatelessWidget {
  String label;
  Color? backroundColor;
  Color? textColor;
  Color? iconColor;

  IconData? icon;

  dynamic onPressed;
  IconSide iconSide = IconSide.LEFT;

  FancyButton({
    required this.label,
    this.icon,
    this.onPressed,
    this.backroundColor,
    this.textColor,
    this.iconSide = IconSide.LEFT,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Center(
        child: TextButton(
          // color: backroundColor ?? Theme.of(context).colorScheme.primary,
          // textColor: textColor ?? Colors.black,
          // disabledColor: Colors.grey,
          // disabledTextColor: Colors.black,
          // padding: EdgeInsets.all(8.0),
          // splashColor: Colors.blueAccent,
          onPressed: onPressed,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(8),
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              iconSide == IconSide.LEFT
                  ? icon != null
                      ? Icon(
                          icon,
                          size: 25,
                          color: iconColor ?? Colors.black,
                        )
                      : SizedBox.shrink()
                  : SizedBox(),
              icon != null
                  ? SizedBox(
                      width: 15,
                    )
                  : SizedBox.shrink(),
              Text(
                label,
                style: TextStyle(
                  // color: Cc.white,
                  fontSize: 20,
                ),
              ),
              icon != null
                  ? SizedBox(
                      width: 15,
                    )
                  : SizedBox.shrink(),
              iconSide == IconSide.RIGHT
                  ? icon != null
                      ? Icon(
                          icon,
                          size: 25,
                          color: iconColor ?? Colors.black,
                        )
                      : SizedBox.shrink()
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
