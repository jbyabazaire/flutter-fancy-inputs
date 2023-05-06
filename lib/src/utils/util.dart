import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class Util {
  static void showNoInternetError(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text("Connection Error"),
              content: Text("Please check your internet and try again"),
              actions: <Widget>[
                CupertinoDialogAction(
                    textStyle: TextStyle(color: Colors.red),
                    isDefaultAction: true,
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text("Okay")),
              ],
            ));
  }

  static void showErrorNotification(
      BuildContext context, String title, String message) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text("${title}"),
              content: Text("${message}"),
              actions: <Widget>[
                CupertinoDialogAction(
                    textStyle: TextStyle(color: Colors.red),
                    isDefaultAction: true,
                    onPressed: () async {
                      Navigator.pop(context);
                      // Navigator.pop(context);
                    },
                    child: Text("Okay")),
              ],
            ));
  }

  /*static formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd – kk:mm').format(date);
  }*/
}
