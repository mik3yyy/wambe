import 'package:go_router/go_router.dart';
import 'package:wambe/models/media.dart';
import 'package:wambe/screens/login_screen/login_screen.dart';
import 'package:wambe/screens/login_screen/welcome.dart';
import 'package:wambe/screens/main_screen/Home_screen/view_time.dart';
import 'package:wambe/screens/main_screen/local_widget/upload_file_screen.dart';
import 'package:wambe/screens/main_screen/main_screen.dart';
import 'package:wambe/screens/share_screen/share_screen.dart';
import 'package:wambe/screens/splash_screen/splash_screen.dart';
import 'package:wambe/settings/hive.dart';

final GoRouter router = GoRouter(
  initialLocation: HiveFunction.userExist() ? '/main' : '/',

  // redirect: (_, __) => null,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: '/share/:id',
      builder: (context, state) => ShareScreen(
        id: state.pathParameters['id']!,
      ),
    ),

    // // //ONBOARDING
    GoRoute(
      path: '/login',
      builder: (context, state) => Eventlogin(),
      routes: <RouteBase>[
        GoRoute(
          path: 'welcome',
          builder: (context, state) => const WelcomScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const CustomMainScreen(),
      routes: <RouteBase>[
        GoRoute(
          name: UploadFileScreen.id,
          path: 'upload/:tag',
          builder: (context, state) => UploadFileScreen(
            tag: state.pathParameters['tag']!,
          ),
        ),
        GoRoute(
          name: ViewTimeMoment.id,
          path: 'view_moment',
          builder: (context, state) => ViewTimeMoment(
            time: state.uri.queryParameters['time']!,
            medialist: state.extra as List<Media>,
          ),
        ),
      ],
    ),
  ],
);
