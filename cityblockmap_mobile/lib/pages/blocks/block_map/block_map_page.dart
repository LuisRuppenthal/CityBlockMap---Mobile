import 'package:flutter/material.dart';

class BlockMapPage extends StatefulWidget {
  const BlockMapPage({super.key});

  @override
  State<BlockMapPage> createState() => _BlockMapPageState();
}

class _BlockMapPageState extends State<BlockMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Lista de Quadras')));
  }
}
