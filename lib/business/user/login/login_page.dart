import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fun_joke/business//user/agreement/agreement_page.dart';
import 'package:fun_joke/business/user/login/verify_code_input.dart';
import 'package:fun_joke/business/user/login/login_state.dart';
import 'package:fun_joke/business/user/login/login_view_model.dart';
import 'package:fun_joke/utils/joke_log.dart';
import 'package:fun_joke/utils/string_util.dart';
import 'package:fun_joke/utils/widget_util.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {

  late TextEditingController _phoneController;

  bool isCodeEnabled = false;
  bool isLoginEnabled = false;

  String _code = "";

  @override
  void initState() {
    super.initState();
    final phone = ref.read(loginPageVMProvider.select((value) => value.phoneNumber));
    _phoneController = TextEditingController(text: phone)..addListener(() {
      setState(() {
        isCodeEnabled = _phoneController.text.length == 11;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(loginPageVMProvider.notifier);
    final pageType = ref.watch(loginPageVMProvider.select((value) => value.pageType));
    ref.listen(loginPageVMProvider.select((value) => value.loading), (previous, next) {
      if (next) {
        SmartDialog.showLoading(msg: "处理中...");
      } else {
        SmartDialog.dismiss();
      }
    });
    ref.listen(loginPageVMProvider.select((value) => value.loginSuccess), (previous, next) {
      JokeLog.i('loginSuccess: previous: $Element.pre(), next: $next');
      if (next) {
        Navigator.pop(context, true);
      }
    });
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, toolbarHeight: 0,),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 25.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: const Icon(Icons.close_rounded),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            Builder(builder: (context) {
              if (pageType == LoginPageType.code) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    40.hSize,
                    const Text('请输入手机号', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    10.hSize,
                    const Text('未注册的手机号验证后将自动登录', style:  TextStyle(fontSize: 12, color: Colors.grey),),
                    40.hSize,
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.w),
                      ),
                      height: 50.w,
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Center(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(fontSize: 20),
                          decoration: const InputDecoration(
                            hintText: '请输入手机号',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    20.hSize,
                    SizedBox(
                      width: double.infinity,
                      height: 50.w,
                      child: ElevatedButton(
                        onPressed: isCodeEnabled ? (){
                          var phone = _phoneController.text;
                          if (!isPhoneNum(phone)) {
                            SmartDialog.showToast('请输入正确的手机号');
                            return;
                          }
                          viewModel.getVerificationCode(phone);
                        } : null,
                        style: ElevatedButton.styleFrom(
                          animationDuration: const Duration(milliseconds: 0),
                        ),
                        child: const Text('获取验证码', style: TextStyle(fontSize: 18),),
                      ),
                    ),
                  ],
                );
              }else if (pageType == LoginPageType.login) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    40.hSize,
                    const Text('请输入验证码', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    10.hSize,
                    const Text('请关注微信公众号【Cretin的开发之路】，在输入框输入【#13】获取验证码', style: TextStyle(fontSize: 12, color: Colors.grey),),
                    40.hSize,
                    VerifyCodeInput(
                      height: 48.w,
                      onSubmit: (value) {
                        _code = value;
                        setState(() {
                          isLoginEnabled = value.length == 6;
                        });
                      },
                    ),
                    20.hSize,
                    SizedBox(
                      width: double.infinity,
                      height: 50.w,
                      child: ElevatedButton(
                        onPressed: isLoginEnabled ? (){
                           viewModel.login(_code);
                        } : null,
                        style: ElevatedButton.styleFrom(
                          animationDuration: const Duration(milliseconds: 0),
                        ),
                        child: const Text('登录', style: TextStyle(fontSize: 18),),
                      ),
                    ),
                  ],
                );
              }else {
                return const SizedBox();
              }
            }),
            20.hSize,
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Spacer(),
                 Text('遇到问题？', style: TextStyle(color: Colors.blue, fontSize: 16)),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Text.rich(TextSpan(
                children: [
                  const TextSpan(text: '登录/注册代表您同意段子乐'),
                  TextSpan(
                    text: '《隐私协议》',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()..onTap = (){
                      Navigator.push(context, CupertinoPageRoute(builder: (context) {
                        return const AgreementPage('隐私协议');
                      }));
                    },
                  ),
                  const TextSpan(text: '和'),
                  TextSpan(
                    text: '《用户服务协议》',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()..onTap = (){
                      Navigator.push(context, CupertinoPageRoute(builder: (context) {
                        return const AgreementPage('用户服务协议');
                      }));
                    },
                  ),
                ]
              )),
            ),
          ],
        ),
      ),
    );
  }
}
