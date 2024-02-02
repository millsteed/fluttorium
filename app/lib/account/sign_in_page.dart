import 'package:app/account/account_page.dart';
import 'package:app/account/sign_up_page.dart';
import 'package:app/core/client.dart';
import 'package:app/core/error_dialog.dart';
import 'package:app/forums/forums_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({required this.client, super.key});

  static const route = 'SignIn';

  final Client client;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var _username = '';
  var _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildForm(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: CloseButton(
        onPressed: () => context.goNamed(ForumsPage.route),
      ),
      title: const Text('Sign in'),
    );
  }

  Widget _buildForm(BuildContext context) {
    return ListView(
      children: [
        _buildUsernameField(context),
        const SizedBox(height: 16),
        _buildPasswordField(context),
        const SizedBox(height: 16),
        _buildSignInButton(context),
        const SizedBox(height: 16),
        _buildSignUpButton(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildUsernameField(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        decoration: const InputDecoration(hintText: 'Username'),
        onChanged: (username) => setState(() => _username = username),
        initialValue: _username,
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        decoration: const InputDecoration(hintText: 'Password'),
        obscureText: true,
        onChanged: (password) => setState(() => _password = password),
        initialValue: _password,
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 16),
      child: FilledButton(
        onPressed: () => _handleSignInPressed(context),
        child: const Text('Sign in'),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: () => context.goNamed(SignUpPage.route),
        child: const Text('Need an account? Sign up'),
      ),
    );
  }

  Future<void> _handleSignInPressed(BuildContext context) async {
    try {
      await widget.client.signIn(_username, _password);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed in as $_username')),
      );
      context.goNamed(AccountPage.route);
    } on ClientException catch (e) {
      if (!context.mounted) {
        return;
      }
      ErrorDialog.show(context, e.error);
    }
  }
}
