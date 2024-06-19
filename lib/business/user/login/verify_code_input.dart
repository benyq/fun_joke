import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


/// 验证码输入组件
class VerifyCodeInput extends StatefulWidget {
  final int codeLength;
  final double width;
  final double height;
  final BoxDecoration? codeBoxDecoration;
  final TextStyle? codeTextStyle;
  final ValueChanged<String>? onSubmit;

  const VerifyCodeInput(
      {Key? key,
      this.codeLength = 6,
      this.width = double.infinity,
      this.height = 60,
      this.codeBoxDecoration,
      this.codeTextStyle,
      this.onSubmit})
      : super(key: key);

  @override
  State<VerifyCodeInput> createState() => _VerifyCodeInputState();
}

class _VerifyCodeInputState extends State<VerifyCodeInput>
    with SingleTickerProviderStateMixin {
  String _text = "";
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if(widget.onSubmit != null) {
        widget.onSubmit!(_controller.text);
      }
      setState(() {
        _text = _controller.text;
      });
    });
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          //动画执行结束时反向执行动画
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          //动画恢复到初始状态时执行动画（正向）
          _animationController.forward();
        }
      })
      ..addListener(() {
        setState(() {});
      });

    ///启动动画
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(children: [_codeBoxRow(), _inputField()]),
    );
  }

  Widget _inputField() {
    _focusNode.requestFocus();
    return TextField(
        controller: _controller,
        style: const TextStyle(
          color: Colors.transparent,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.codeLength),
        ],
        cursorColor: Colors.transparent,
        cursorWidth: 0.0,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.done,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        focusNode: _focusNode,
        autofocus: true,
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ));
  }

  Widget _codeBoxRow() {
    List<Widget> codeBoxItems = [];
    for (int index = 0; index < widget.codeLength; index++) {
      String text =
          (_text.length > index) ? _text.substring(index, index + 1) : "";
      codeBoxItems.add(_codeBoxItem(text, index));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: codeBoxItems,
    );
  }

  Widget _codeBoxItem(String text, int index) {
    return GestureDetector(
      child: AbsorbPointer(
        absorbing: false,
        child: Container(
            width: widget.height,
            height: widget.height,
            alignment: Alignment.center,
            decoration: widget.codeBoxDecoration ??
                BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5.w)),
            child: text.length == 1
                ? Text(text,
                    style: widget.codeTextStyle ??
                        TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.w))
                : _cursor(index == _text.length)),
      ),
    );
  }

  Widget _cursor(bool show) {
    return show
        ? Opacity(
            opacity: _animation.value,
            child: Container(
                width: 3.w,
                height: widget.height * 0.4,
                color: Colors.black),
          )
        : const SizedBox();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
