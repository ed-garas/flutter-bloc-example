import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/bloc/authentication/authentication_bloc.dart';
import 'package:flutterbloc/datamodels/post.dart';
import 'package:flutterbloc/features/login/login_screen.dart';
import 'package:flutterbloc/features/main/main_screen.dart';
import 'package:flutterbloc/features/post/post_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static String homeName = 'home';
  static String homePath = '/';

  static String singlePostName = 'SinglePost';
  static String singlePostPath = 'post/:id';

  static String loginName = 'login';
  static String loginPath = '/login';

  static final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
          name: homeName,
          path: homePath,
          builder: (BuildContext context, GoRouterState state) {
            return BlocBuilder<AuthenticationBloc, AuthenticationState>(builder: (context, state) {
              if (state is UnknownState || state is UnauthenticatedState) {
                return const LoginScreen();
              } else if (state is LoadingState) {
                return const Scaffold(
                  body: Center(
                    child: Text('Authenticating...'),
                  ),
                );
              } else if (state is AuthenticatedState) {
                return const MainScreen();
              }
              return const SizedBox.shrink();
            });
          },
          routes: [
            GoRoute(
              name: singlePostName,
              path: singlePostPath,
              builder: (BuildContext context, GoRouterState state) {
                return PostScreen(
                  id: int.parse(state.params['id']!),
                  post: state.extra as Post,
                );
              },
            ),
          ]),
      GoRoute(
        name: loginName,
        path: loginPath,
        builder: (BuildContext context, GoRouterState state) =>
        const LoginScreen(),
      ),
    ],
  );
}