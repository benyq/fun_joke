import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({super.key});

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> with AutomaticKeepAliveClientMixin{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 10, backgroundColor: Colors.black,),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          InkWell(
            onTap: (){
              Navigator.of(context).pushNamed('/login');
            },
              child: Text('data1'))
        ],
      ),
    );
    }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
