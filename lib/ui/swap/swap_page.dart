import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fun_joke/ui/user/login/login_page.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({super.key});

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.yellow,),
      body: Column(
        children: [
          Container(
            color: Colors.yellow,
            width: double.infinity,
            height: MediaQuery.of(context).padding.top,
          ),
          InkWell(
            onTap: (){
              Navigator.of(context).pushNamed('/login');
            },
              child: Text('data'))
        ],
      ),
    );
    }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
