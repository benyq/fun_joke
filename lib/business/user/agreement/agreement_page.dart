import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AgreementPage extends StatelessWidget {
  const AgreementPage(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(title),
      ),
      body: FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString('assets/agreement/$title.txt'),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(snapshot.data.toString()),
                  ),
                );
              }else {
                return Center(
                  child: Text(snapshot.error?.toString() ?? 'error'),
                );
              }
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
       }
      )
    );
  }
}
