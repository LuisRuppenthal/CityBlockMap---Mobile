import 'package:flutter/material.dart';

class BlockEditPage extends StatefulWidget {
  const BlockEditPage({super.key});

  @override
  State<BlockEditPage> createState() => _BlockEditPageState();
}

class _BlockEditPageState extends State<BlockEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Lista de Quadras')));
  }
}
