import 'package:app/account/account_page.dart';
import 'package:app/account/sign_in_page.dart';
import 'package:app/core/client.dart';
import 'package:app/core/error_dialog.dart';
import 'package:app/forums/forums_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({required this.client, super.key});

  static const route = 'SignUp';

  final Client client;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
      title: const Text('Sign up'),
    );
  }

  Widget _buildForm(BuildContext context) {
    return ListView(
      children: [
        _buildUsernameField(context),
        const SizedBox(height: 16),
        _buildPasswordField(context),
        const SizedBox(height: 16),
        _buildSignUpButton(context),
        const SizedBox(height: 16),
        _buildSignInButton(context),
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

  Widget _buildSignUpButton(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 16),
      child: FilledButton(
        onPressed: () => _handleSignUpPressed(context),
        child: const Text('Sign up'),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: () => context.goNamed(SignInPage.route),
        child: const Text('Have an account? Sign in'),
      ),
    );
  }

  Future<void> _handleSignUpPressed(BuildContext context) async {
    try {
      await widget.client.signUp(_username, _password);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed up as $_username')),
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
