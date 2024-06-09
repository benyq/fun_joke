import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
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
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
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
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '请输入验证码',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
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
                  onTap: (){},
                  child: const Text('密码登录', style: TextStyle(color: Colors.blue, fontSize: 16)),
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
                      Navigator.pushNamed(context, '/register');
                    },
                  ),
                  const TextSpan(text: '和'),
                  TextSpan(
                    text: '《用户服务协议》',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()..onTap = (){
                      Navigator.pushNamed(context, '/register');
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
