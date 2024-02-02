import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildLoadingIndicator(context),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
