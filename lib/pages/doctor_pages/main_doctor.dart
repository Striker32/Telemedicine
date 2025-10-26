import 'package:flutter/material.dart';

class MainDoctor extends StatelessWidget {
  const MainDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Page')),
      body: const Center(child: Text('Hello from NewPage')),
    );
  }
}
