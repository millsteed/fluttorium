import 'package:app/account/account_page.dart';
import 'package:app/account/sign_in_page.dart';
import 'package:app/account/sign_up_page.dart';
import 'package:app/core/client.dart';
import 'package:app/core/navigation_shell.dart';
import 'package:app/forums/create_thread_page.dart';
import 'package:app/forums/forums_page.dart';
import 'package:app/forums/post_reply_page.dart';
import 'package:app/forums/posts_page.dart';
import 'package:app/forums/threads_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class App extends StatefulWidget {
  const App({required this.client, super.key});

  final Client client;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => state.namedLocation(ForumsPage.route),
      ),
      GoRoute(
        name: SignInPage.route,
        path: '/signin',
        redirect: (context, state) => widget.client.session != null
            ? state.namedLocation(AccountPage.route)
            : null,
        builder: (context, state) => SignInPage(
          client: widget.client,
        ),
      ),
      GoRoute(
        name: SignUpPage.route,
        path: '/signup',
        redirect: (context, state) => widget.client.session != null
            ? state.namedLocation(AccountPage.route)
            : null,
        builder: (context, state) => SignUpPage(
          client: widget.client,
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => NavigationShell(child: child),
        routes: _navigationRoutes,
      ),
    ],
  );

  late final _navigationRoutes = [
    GoRoute(
      name: ForumsPage.route,
      path: '/forums',
      builder: (context, state) => ForumsPage(
        client: widget.client,
      ),
      routes: _forumsRoutes,
    ),
    GoRoute(
      name: AccountPage.route,
      path: '/account',
      redirect: (context, state) => widget.client.session == null
          ? state.namedLocation(SignInPage.route)
          : null,
      pageBuilder: (context, state) => NoTransitionPage(
        child: AccountPage(
          client: widget.client,
        ),
      ),
    ),
  ];

  late final _forumsRoutes = [
    GoRoute(
      name: ThreadsPage.route,
      path: ':forumId',
      builder: (context, state) => ThreadsPage(
        client: widget.client,
        forumId: state.pathParameters['forumId']!,
      ),
      routes: _threadsRoutes,
    ),
  ];

  late final _threadsRoutes = [
    GoRoute(
      name: CreateThreadPage.route,
      path: 'create',
      redirect: (context, state) => widget.client.session == null
          ? state.namedLocation(SignInPage.route)
          : null,
      builder: (context, state) => CreateThreadPage(
        client: widget.client,
        forumId: state.pathParameters['forumId']!,
      ),
    ),
    GoRoute(
      name: PostsPage.route,
      path: ':threadId',
      builder: (context, state) => PostsPage(
        client: widget.client,
        forumId: state.pathParameters['forumId']!,
        threadId: state.pathParameters['threadId']!,
      ),
      routes: _postsRoutes,
    ),
  ];

  late final _postsRoutes = [
    GoRoute(
      name: PostReplyPage.route,
      path: 'reply',
      redirect: (context, state) => widget.client.session == null
          ? state.namedLocation(SignInPage.route)
          : null,
      builder: (context, state) => PostReplyPage(
        client: widget.client,
        forumId: state.pathParameters['forumId']!,
        threadId: state.pathParameters['threadId']!,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: brightness,
        colorSchemeSeed: Colors.blue,
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      routerConfig: _router,
    );
  }
}
