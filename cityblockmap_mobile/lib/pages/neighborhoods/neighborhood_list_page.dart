import 'package:flutter/material.dart';

class NeighborhoodListPage extends StatefulWidget {
  const NeighborhoodListPage({super.key});

  @override
  State<NeighborhoodListPage> createState() => _NeighborhoodListPageState();
}

class _NeighborhoodListPageState extends State<NeighborhoodListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Lista de Quadras')));
  }
}
