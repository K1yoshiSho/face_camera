import 'dart:io';

import 'package:face_camera_example/src/features/auth/login_screen.dart';
import 'package:face_camera_example/src/features/home/presentation/screens/home_screen.dart';
import 'package:face_camera_example/src/features/home/presentation/screens/images_screen.dart';
import 'package:face_camera_example/src/features/home/presentation/screens/initial_screen.dart';
import 'package:face_camera_example/src/features/home/presentation/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
export 'package:go_router/go_router.dart';

/// This line declares a global key variable which is used to access the [NavigatorState] object associated with a widget.

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// This function returns a [CustomTransitionPage] widget with default fade animation.

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

String? getCurrentPath() {
  if (navigatorKey.currentContext != null) {
    final GoRouterDelegate routerDelegate = GoRouter.of(navigatorKey.currentContext!).routerDelegate;
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch ? lastMatch.matches : routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  } else {
    return null;
  }
}

/// This function returns a [NoTransitionPage] widget with no animation.

CustomTransitionPage buildPageWithNoTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return NoTransitionPage<T>(
    key: state.pageKey,
    child: child,
  );
}

/// This function returns a dynamic [Page] widget based on the input parameters.
/// It uses the '[buildPageWithDefaultTransition]' function to create a page with a default [fade animation].

Page<dynamic> Function(BuildContext, GoRouterState) defaultPageBuilder<T>(Widget child) => (BuildContext context, GoRouterState state) {
      return buildPageWithDefaultTransition<T>(
        context: context,
        state: state,
        child: child,
      );
    };

/// [createRouter] is a factory function that creates a [GoRouter] instance with all routes.

GoRouter createRouter() => GoRouter(
      initialLocation: InitialScreen.routeName,
      debugLogDiagnostics: true,
      navigatorKey: navigatorKey,
      observers: [
        HeroController(),
      ],
      routes: [
        GoRoute(
          name: InitialScreen.name,
          path: InitialScreen.routeName,
          builder: (context, pathParameters) => const InitialScreen(),
        ),
        GoRoute(
          name: HomeScreen.name,
          path: HomeScreen.routeName,
          builder: (context, pathParameters) {
            return const HomeScreen();
          },
          routes: [
            GoRoute(
              name: SettingsScreen.name,
              path: SettingsScreen.routeName,
              builder: (context, pathParameters) {
                return const SettingsScreen();
              },
            ),
            GoRoute(
              name: ImagesScreen.name,
              path: ImagesScreen.routeName,
              builder: (context, pathParameters) {
                Map<String, dynamic>? args = pathParameters.extra as Map<String, dynamic>?;
                return ImagesScreen(
                  images: args?[ImagesScreen.paramImages] as List<File>? ?? <File>[],
                );
              },
            ),
          ],
        ),

        /// --------------------------- `Auth` ---------------------------
        GoRoute(
          name: LoginScreen.name,
          path: LoginScreen.routeName,
          builder: (context, pathParameters) {
            Map<String, dynamic>? args = pathParameters.extra as Map<String, dynamic>?;
            return LoginScreen(
              isInitial: args?[LoginScreen.paramIsInitial] as bool? ?? false,
            );
          },
        ),
      ],
    );
