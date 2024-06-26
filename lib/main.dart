import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:wambe/blocs/media_bloc/media_bloc.dart';
import 'package:wambe/blocs/user_bloc/user_bloc.dart';
import 'package:wambe/models/event.dart';
import 'package:wambe/models/media.dart';
import 'package:wambe/models/media_data.dart';
import 'package:wambe/models/user.dart';
import 'package:wambe/observer.dart';
import 'package:wambe/repository/media_repo/media_implementation.dart';
import 'package:wambe/repository/user_repo/user_implementation.dart';
import 'package:wambe/screens/share_screen/provider.dart';
import 'package:wambe/settings/hive.dart';
import 'package:wambe/settings/router.dart';
import 'package:wambe/settings/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(MediaDataAdapter());
  Hive.registerAdapter(TopContributorAdapter());
  Hive.registerAdapter(MediaAdapter());
  Hive.registerAdapter(MediaResponseAdapter());

  await Hive.openBox('wambe');
  Bloc.observer = SimpleBlocObserver();
  setPathUrlStrategy();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShareProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        return MaterialApp(
          title: 'Wambe',
          debugShowCheckedModeBanner: false,
          home: const Scaffold(
            body: Center(
              child:
                  Text("Wambe Application is Only available on Mobile Browser"),
            ),
          ),
          // routerConfig: router,
          theme: appThemeData,
          scrollBehavior: MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
              PointerDeviceKind.unknown
            },
          ),
        );
      }
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<userRepoImp>(create: (context) => userRepoImp()),
          RepositoryProvider<mediaRepoImp>(create: (context) => mediaRepoImp()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => UserBloc(
                userRepo: context.read<userRepoImp>(),
              ),
            ),
            BlocProvider(
              create: (context) => MediaBloc(
                mediaRepo: context.read<mediaRepoImp>(),
              ),
            ),
          ],
          child: Builder(builder: (context) {
            if (HiveFunction.userExist()) {
              context.read<UserBloc>().add(RestoreEvent(
                  event: HiveFunction.getEvent(),
                  user: HiveFunction.getUser()));
            }
            if (HiveFunction.myMomentExist()) {
              context.read<MediaBloc>().add(RestoreMyMomentEvent());
            }
            return MaterialApp.router(
              title: 'Wambe',
              debugShowCheckedModeBanner: false,
              routerConfig: router,
              theme: appThemeData,
              scrollBehavior: MaterialScrollBehavior().copyWith(
                dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.unknown
                },
              ),
            );
          }),
        ),
      );
    });
  }
}
