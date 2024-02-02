import 'package:app/core/client.dart';
import 'package:app/core/error_dialog.dart';
import 'package:app/forums/forums_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({required this.client, super.key});

  static const route = 'Account';

  final Client client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildAccount(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Account'),
    );
  }

  Widget _buildAccount(BuildContext context) {
    final account = client.session!.user;
    return ListView(
      children: [
        _buildAvatar(context),
        const SizedBox(height: 16),
        _buildUsername(context, account),
        const SizedBox(height: 16),
        _buildSignOutButton(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Icon(
      Icons.account_circle,
      size: 64,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }

  Widget _buildUsername(BuildContext context, User account) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        account.username,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: () => _handleSignOutPressed(context),
        child: const Text('Sign out'),
      ),
    );
  }

  Future<void> _handleSignOutPressed(BuildContext context) async {
    try {
      await client.signOut();
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out')),
      );
    } on ClientException catch (e) {
      if (!context.mounted) {
        return;
      }
      ErrorDialog.show(context, e.error);
    }
    context.goNamed(ForumsPage.route);
  }
}
