import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shafi_app/widgets/loadingWidget.dart';

class LoadingAlertDialog extends StatelessWidget
{
  final String message;
  const LoadingAlertDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          circularProgress(),
          SizedBox(
            height: 10,
          ),
          Text(message),
        ],
      ),
    );
  }
}
