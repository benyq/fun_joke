import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({super.key});

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.yellow,
          width: double.infinity,
          height: MediaQuery.of(context).padding.top,
        ),
        Text('data')
      ],
    );
    }
}
