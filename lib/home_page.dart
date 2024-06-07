import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with KeepAliveParentDataMixin {
  @override
  Widget build(BuildContext context) {
    print('homepage build');
    return Center(
      child: Consumer(
        builder: (context, ref, child) {
          return Text('home');
        },
      ),
    );
  }

  @override
  void detach() {
  }

  @override
  bool get keptAlive => true;
}
