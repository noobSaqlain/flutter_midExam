import 'package:flutter/material.dart';
import 'package:mid/widgets/networkLayer.dart';

class Myhomepage extends StatelessWidget {
  const Myhomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Space Mission'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: const Networklayer(),
    );
  }
}
