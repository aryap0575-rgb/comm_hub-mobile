import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/router_name.dart';
import 'utils/k_strings.dart';
import 'utils/my_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('pt_BR', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>()!;
  }
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  //Test Binding Observer
  ThemeMode _themeMode = ThemeMode.light;

  //Test Binding Observer
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  //Test Binding Observer
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //Test Binding Observer
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // The app has gone to the background or is not visible
      print('App is in the background');
    } else if (state == AppLifecycleState.resumed) {
      // The app has come back to the foreground
      print('App is in the foreground');
    }
  }

  void setThemeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Kstrings.appName,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: _themeMode,
      onGenerateRoute: RouteNames.generateRoute,
      initialRoute: RouteNames.animatedSplashScreen,
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
      },
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
