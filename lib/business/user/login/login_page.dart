import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_joke/business//user/agreement/agreement_page.dart';
import 'package:fun_joke/business/user/login/login_view_model.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {

  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _verificationCodeController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _verificationCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(loginPageVMProvider.notifier);
    final loginByPassword = ref.watch(loginPageVMProvider.select((it) => it.isPassword));
    final loginText = loginByPassword ? '验证码登录': '密码登录';
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, toolbarHeight: 0,),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: const Icon(Icons.close_rounded),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20,),
            const Text('验证码登录', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: '请输入手机号',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: loginByPassword ? TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: '请输入密码',
                        border: InputBorder.none,
                      ),
                    ) : TextField(
                      controller: _verificationCodeController,
                      decoration: const InputDecoration(
                        hintText: '请输入验证码',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !loginByPassword,
                    child: Row(children: [
                      Container(
                        width: 1,
                        height: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: const DecoratedBox(
                            decoration: BoxDecoration(color: Colors.grey)
                        ),
                      ),
                      InkWell(
                        onTap: (){},
                        child: const Text('获取验证码'),
                      ),
                    ],),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){},
                child: const Text('登录'),
              ),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    viewModel.toggleLoginType();
                  },
                  child: Text(loginText, style: const TextStyle(color: Colors.blue, fontSize: 16)),
                ),
                GestureDetector(
                  onTap: (){},
                  child: const Text('遇到问题？', style: TextStyle(color: Colors.blue, fontSize: 16)),
                ),
              ],
            ),
            const Expanded(
              flex: 1,
                child: SizedBox.shrink()),
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
            )
          ],
        ),
      ),
    );
  }
}
