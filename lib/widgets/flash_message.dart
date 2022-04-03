import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:expoleap/enums/enums.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class FlashMessage {
  FlashMessage._();
  static snackBuilder(BuildContext context, String message, SnackBarType type) {
    Icon icon;
    Color color;
    switch (type) {
      case SnackBarType.Error:
        color = Colors.red;
        icon = Icon(Icons.error, size: 25, color: Colors.white);
        break;
      case SnackBarType.Success:
        color = Colors.green[600]!;
        icon = Icon(MaterialIcons.check_circle, size: 25, color: Colors.white);
        break;
      case SnackBarType.Notification:
        color = Colors.orange[600]!;
        icon = Icon(MaterialIcons.notifications, size: 25, color: Colors.white);
        break;
      default:
        color = Colors.amber[300]!;
        icon = Icon(MaterialIcons.warning, size: 25, color: Colors.white);
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: <Widget>[
          icon,
          Text(' $message',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.3)))
        ]),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        action: new SnackBarAction(
          label: '',
          textColor: Colors.yellow,
          onPressed: () => null,
        )));
  }
}
