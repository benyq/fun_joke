import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/utils/joke_log.dart';

const _maxContentLength = 300;

class AddJokePage extends StatefulWidget {
  const AddJokePage({super.key});

  @override
  State<AddJokePage> createState() => _AddJokePageState();
}

class _AddJokePageState extends State<AddJokePage> {

  late StateSetter _contentStateSetter;
  late TextEditingController _contentController;


  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    JokeLog.i('AddJokePage build');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 30.w,
                  ),
                ),
                const Expanded(
                    child: Center(
                  child: Text(
                    '发布帖子',
                    style: TextStyle(fontSize: 18),
                  ),
                )),
                GestureDetector(
                  child: const Text('发布', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(
              width: double.infinity,
              height: 230.h,
              child: TextField(
                maxLines: 30,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(_maxContentLength),
                ],
                onChanged: (value) {
                  _contentStateSetter((){});
                },
                controller: _contentController,
                decoration: InputDecoration(
                    hintText: '来点料呗，我送你上推荐~',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.w),
                        borderSide: BorderSide.none),
                    fillColor: Colors.grey.withOpacity(0.2)),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: Row(
              children: [
                GestureDetector(
                  child: Icon(Icons.image, size: 35.w,),
                ),
                SizedBox(width: 20.w,),
                GestureDetector(
                  child: Icon(Icons.ondemand_video, size: 35.w,),
                ),
                const Spacer(),
                StatefulBuilder(builder: (context, setter) {
                  _contentStateSetter = setter;
                  return Text('${_contentController.text.length} / $_maxContentLength字');
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}
