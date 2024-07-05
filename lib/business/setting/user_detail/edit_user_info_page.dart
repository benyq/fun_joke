import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/utils/widget_util.dart';

class EditUserInfoArgument {
  final String title;
  final String value;
  final String desc;
  final int maxLength;

  const EditUserInfoArgument(
      {required this.title,
      required this.value,
      required this.desc,
      this.maxLength = 20});
}

class EditUserInfoPage extends StatefulWidget {
  final String title;
  final String value;
  final String desc;
  final int maxLength;

  const EditUserInfoPage(
      {super.key,
      required this.title,
      required this.value,
      required this.desc,
      this.maxLength = 20});

  @override
  State<EditUserInfoPage> createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  late final TextEditingController _controller;
  int _currentLength = 0;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _currentLength = widget.value.length;
    _controller = TextEditingController(text: widget.value)
      ..addListener(() {
        setState(() {
          _currentLength = _controller.text.length;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _controller.text);
              },
              child: Text(
                '保存',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ],
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
            child: Theme(
              data: Theme.of(context).copyWith(textSelectionTheme: TextSelectionThemeData(
                  selectionHandleColor: Colors.red, // Change the selection handle color
                  selectionColor: Colors.red.withOpacity(0.5)
              )),
              child: TextField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(widget.maxLength),
                ],
                controller: _controller,
                cursorColor: Colors.blueAccent,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.w, style: BorderStyle.solid)),
                    enabledBorder : UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2.w, style: BorderStyle.solid)),
                    suffix: Text(
                      '$_currentLength / ${widget.maxLength}',
                      textAlign: TextAlign.end,
                    )),
              ),
            ),
          ),
          10.hSize,
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Text(
              widget.desc,
              style: const TextStyle(color: Colors.grey),
            ),
          )
        ]));
  }
}
