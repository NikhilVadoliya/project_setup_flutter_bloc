import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterprojectsetup/blocs/theme/theme.dart';
import 'package:flutterprojectsetup/core/app_snackbar.dart';
import 'package:flutterprojectsetup/core/network/network_provider.dart';
import 'package:flutterprojectsetup/core/theme/dark_theme.dart';
import 'package:flutterprojectsetup/core/theme/light_theme.dart';
import 'package:flutterprojectsetup/injector/injector.dart';
import 'package:flutterprojectsetup/routes/navigator_route.dart';
import 'package:flutterprojectsetup/blocs/splash/splash_bloc.dart';
import 'package:flutterprojectsetup/core/bloc/simple_bloc_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'blocs/app/app.dart';

void main() {
  Bloc.observer = SimpleBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  Injector.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<bool> _networkStreamSubscription;
  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _networkStreamSubscription =
        Injector.instance.get<NetworkProvider>().onStateChange().listen((isConnected) {
      if (isConnected) {
        messengerKey.currentState?.hideCurrentSnackBar();
      } else {
        messengerKey.currentState?.showSnackBar(AppSnackBar.snackBarNoInternetConnection());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ApplicationBloc>(
          create: (BuildContext context) => ApplicationBloc(),
        ),
        BlocProvider<ThemeBloc>(
          create: (BuildContext context) => ThemeBloc(ChangeTheme(
              WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark)),
        ),
        BlocProvider<SplashBloc>(
          create: (BuildContext context) => SplashBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
        return ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (BuildContext context, Widget? child) {
            return MaterialApp(
              scaffoldMessengerKey: messengerKey,
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              routes: NavigatorRoute.routes,
              initialRoute: NavigatorRoute.root,
              theme: state.isDark ? darkTheme : lightTheme,
            );
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    _networkStreamSubscription.cancel();
    super.dispose();
  }
}
