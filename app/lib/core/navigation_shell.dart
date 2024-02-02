import 'package:app/account/account_page.dart';
import 'package:app/forums/forums_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationShell extends StatelessWidget {
  const NavigationShell({required this.child, super.key});

  final Widget child;

  static final _items = [
    (Icons.forum, 'Forums', ForumsPage.route),
    (Icons.account_circle, 'Account', AccountPage.route),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _buildNavigationBar(context),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    return NavigationBar(
      destinations: [
        for (final item in _items) ...[
          NavigationDestination(icon: Icon(item.$1), label: item.$2),
        ],
      ],
      onDestinationSelected: (index) => context.goNamed(_items[index].$3),
      selectedIndex: _items
          .map((e) => e.$3)
          .map(context.namedLocation)
          .toList()
          .lastIndexWhere(GoRouterState.of(context).uri.path.startsWith),
    );
  }
}
