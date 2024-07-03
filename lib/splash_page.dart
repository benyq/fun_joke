import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/app_providers/user_service.dart';
import 'package:fun_joke/business/home/home_page.dart';
import 'package:fun_joke/business/joke/publish_joke/publish_joke_page.dart';
import 'package:fun_joke/business/message/messsage_page.dart';
import 'package:fun_joke/business/user/mine/mine_page.dart';
import 'package:fun_joke/business/swap/swap_page.dart';
import 'package:fun_joke/utils/joke_log.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  static const TYPE_HOME = 0;
  static const TYPE_SWAP = 1;
  static const TYPE_MESSAGE = 2;
  static const TYPE_MINE = 3;

  var _selectedIndex = 0;

  final pages = const [
    HomePage(),
    SwapPage(),
    MessagePage(),
    MinePage(),
  ];

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
        onPageChanged: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: (){
        _showAddJokePage();
      }, shape: const CircleBorder(), elevation: 0,),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        height: 65.w,
        shape: const CircularNotchedRectangle(),
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Row(
          children: [
            Expanded(child: _BottomTabButton(
              icon: Icons.home,
              label: '首页',
              isSelected: _selectedIndex == TYPE_HOME,
              onTap: (){
                _onItemChanged(TYPE_HOME);
              },
            ),),
            Expanded(
              child: _BottomTabButton(
                icon: Icons.swap_vert,
                label: '划一划',
                isSelected: _selectedIndex == TYPE_SWAP,
                onTap: (){
                  _onItemChanged(TYPE_SWAP);
                },
              ),
            ),
            const SizedBox(width: 48), // 占位，以便 FloatingActionButton 不遮挡
            Expanded(
              child: _BottomTabButton(
                icon: Icons.message,
                label: '消息',
                isSelected: _selectedIndex == TYPE_MESSAGE,
                onTap: (){
                  if (UserService.checkLogin(context)) {
                    _onItemChanged(TYPE_MESSAGE);
                  }
                },
              ),
            ),
            Expanded(
              child: _BottomTabButton(
                icon: Icons.person,
                label: '我的',
                isSelected: _selectedIndex == TYPE_MINE,
                onTap: (){
                  _onItemChanged(TYPE_MINE);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _onItemChanged(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  _showAddJokePage() {
    publishAction() {
      Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, anim, secAnim) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(anim),
          child: const PublishJokePage(),
        );
      }));
    }
    bool isLoggedIn = UserService.checkLogin(
      context,
      onLogin: (result) {
        if (result != null) {
          publishAction();
        }
      },
    );
    if (isLoggedIn) {
      publishAction();
    }
  }

}

class _BottomTabButton extends StatelessWidget {
  const _BottomTabButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.black,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

