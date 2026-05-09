import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/services.dart';

class Utils {
  static final _selectedDate = DateTime.now();

  static final _initialTime = TimeOfDay.now();

  static String formatPrice(double price) => '\$${price.toStringAsFixed(1)}';

  static String formatDate(var date) {
    late DateTime dateTime;
    if (date is String) {
      dateTime = DateTime.parse(date);
    } else {
      dateTime = date;
    }

    return DateFormat.yMd().format(dateTime);
  }

  static String numberCompact(num number) =>
      NumberFormat.compact().format(number);

  static String timeAgo(String? time) {
    try {
      if (time == null) return '';
      return timeago.format(DateTime.parse(time));
    } catch (e) {
      return '';
    }
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(message, textAlign: TextAlign.center),
    ));
  }

  static Future<DateTime?> selectDate(BuildContext context) => showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1990, 1),
        lastDate: DateTime(2050),
      );

  static Future<TimeOfDay?> selectTime(BuildContext context) =>
      showTimePicker(context: context, initialTime: _initialTime);

  static Future showCustomDialog(BuildContext context, {Widget? child}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        );
      },
    );
  }

  static showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Log out?"),
          content: const Text("Are you sure you want to log out?"),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: false,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            CupertinoDialogAction(
                textStyle: const TextStyle(color: Colors.red),
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Text("Log out")),
          ],
        );
      },
    );
  }
}

class ShowDialog {
  static waitDialog(
      {bool isDismissible = true,
      bool canPop = true,
      required BuildContext context}) {
    showDialog(
        barrierDismissible: isDismissible,
        context: context,
        builder: (context) {
          return PopScope(
            canPop: canPop,
            child: Dialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 100,
                width: 50,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Harap tunggu...',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  static warningDialog(
      {bool isDismissible = true,
      bool canPop = true,
      IconData dialogIcon = Icons.error_outline_outlined,
      double iconSize = 40,
      Color? iconColor,
      required String message,
      TextStyle? messageStyle,
      List<Widget>? action,
      required BuildContext context}) {
    showDialog(
        barrierDismissible: isDismissible,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  dialogIcon,
                  size: iconSize,
                  color: iconColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: messageStyle,
                  ),
                ),
              ],
            ),
            actions: action,
          );
        });
  }

  static warningDialogRichText(
      {bool isDismissible = true,
      bool canPop = true,
      IconData dialogIcon = Icons.error_outline_outlined,
      double iconSize = 40,
      Color? iconColor,
      required RichText message,
      TextStyle? messageStyle,
      List<Widget>? action,
      required BuildContext context}) {
    showDialog(
        barrierDismissible: isDismissible,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  dialogIcon,
                  size: iconSize,
                  color: iconColor,
                ),
                Padding(padding: const EdgeInsets.all(10.0), child: message),
              ],
            ),
            actions: action,
          );
        });
  }
}

class ShowNotif {
  static success(
      {int duration = 1500,
      required String message,
      Color backgroundColor = Colors.green,
      required BuildContext context}) {
    Flushbar(
      icon: const Icon(
        Icons.done_outlined,
        color: Colors.white,
      ),
      backgroundColor: backgroundColor,
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: duration),
    ).show(context);
  }

  static failed(
      {int duration = 1500,
      required String message,
      Color backgroundColor = Colors.red,
      required BuildContext context}) {
    Flushbar(
      icon: const Icon(
        Icons.done_outlined,
        color: Colors.white,
      ),
      backgroundColor: backgroundColor,
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: duration),
    ).show(context);
  }

  static warning(
      {int duration = 1500,
      required String message,
      Color backgroundColor = Colors.yellow,
      required BuildContext context}) {
    Flushbar(
      icon: const Icon(
        Icons.error_outline_outlined,
        color: Colors.blue,
      ),
      backgroundColor: backgroundColor,
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.blue),
      ),
      duration: Duration(milliseconds: duration),
    ).show(context);
  }

  static info(
      {int duration = 1500,
      required String message,
      Color backgroundColor = Colors.blueAccent,
      context}) {
    Flushbar(
      icon: const Icon(
        Icons.done_outlined,
        color: Colors.white,
      ),
      backgroundColor: backgroundColor,
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: duration),
    ).show(context);
  }
}

void notif(String message, String status, context) {
  if (status == "berhasil") {
    Flushbar(
      icon: const Icon(
        Icons.done_outlined,
        color: Colors.white,
      ),
      backgroundColor: const Color.fromARGB(255, 0, 212, 0),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(milliseconds: 1500),
    ).show(context);
  } else {
    Flushbar(
      icon: const Icon(
        Icons.info_outlined,
        color: Colors.white,
      ),
      backgroundColor: Colors.red,
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 10),
    ).show(context);
  }
}

class FocusChannel {
  static const MethodChannel _channel =
      MethodChannel('com.example.screen_pinning');

  static void listenForFocusChanges() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == "windowFocusChanged") {
        bool hasFocus = call.arguments as bool;
        if (!hasFocus) {
          SystemNavigator.pop();
          print("Window focus lost!");
        } else {
          print("Window focus regained!");
        }
      }
    });
  }
}
