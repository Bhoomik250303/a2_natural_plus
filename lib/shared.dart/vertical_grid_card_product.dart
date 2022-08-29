import 'package:flutter/material.dart';

class VerticalGridCardProduct extends StatefulWidget {
  const VerticalGridCardProduct({Key? key}) : super(key: key);

  @override
  _VerticalGridCardProductState createState() =>
      _VerticalGridCardProductState();
}

class _VerticalGridCardProductState extends State<VerticalGridCardProduct> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      children: [],
      crossAxisCount: 2,
    );
  }
}
