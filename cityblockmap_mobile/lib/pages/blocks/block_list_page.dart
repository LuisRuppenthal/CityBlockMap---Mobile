import 'package:flutter/material.dart';

class BlockListPage extends StatefulWidget {
  const BlockListPage({super.key});

  @override
  State<BlockListPage> createState() => _BlockListPageState();
}

class _BlockListPageState extends State<BlockListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Lista de Quadras')));
  }
}
