import 'package:flutter/material.dart';
import 'package:skool_app/home.dart';
import 'package:skool_app/views/add_event.dart';
import 'package:skool_app/views/event_detail.dart';
import 'package:skool_app/views/event_home.dart';
import 'package:skool_app/views/main.dart';
import 'package:skool_app/views/sign_up.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => MyHomePage(title: "  "));
      case '/signUp':
        return MaterialPageRoute(builder: (context) => SignUpView());
      case '/home':
        return MaterialPageRoute(builder: (context) => EventHome());
      case '/detail':
        var id = settings.arguments as String;
        return MaterialPageRoute(builder: (context) => EventDetail(id: id));
      case '/root_view':
        return MaterialPageRoute(builder: (context) => RootView());
      case '/add_event':
        return MaterialPageRoute(builder: (context) => AddEventView());

      default:
        return MaterialPageRoute(builder: (context) => RootView());
    }
  }
}

String formatDate(int dateString) {
  try {
    final date = DateTime.fromMicrosecondsSinceEpoch(dateString);
    return '${date.day}/${date.month}/${date.year}';
  } catch (e) {
    return 'Invalid Date';
  }
}
