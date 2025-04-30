import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/src/consumer.dart';
import '../../commons/sidebar2.dart';
import '../../provider/app_provider.dart';
import '../../routers/constants.dart';
import '../../service/assets.dart';
import '../home/index.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

// class _MainPageState extends State<MainPage> {
class _MainPageState extends State<MainPage> with RouteAware {

  late List<Widget> _pages;
  
  final PageStorageBucket _bucket = PageStorageBucket();
  
  int _currentPageIndex = 0;

  void _init() async {
    _pages = [
      HomePage(key: PageStorageKey<String>('home'), onTapMenuItem: navigateToPage, isGuest: false),
    ];
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void navigateToPage(int index) {
    print(index);
    setState(() {
      _currentPageIndex = index;
    });
  }


  @override
  void didPush() {
    super.didPush();
    final currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.settings.name == homeRoute) {
      setState(() {
        _currentPageIndex = 0;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (!didPop) {
            bool exitApp = await _showConfirmationDialog();
            if (exitApp) {
              SystemNavigator.pop();
            }
          }
        },
        child: Consumer<AppProvider>(builder: (context, prov, _) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body:CustomSidebarLayout(
              userName: 'Abdul Haris',
              userHandle: '@haris',
              userAvatarUrl: 'https://i.pravatar.cc/150?img=3',
              pageContent: Stack(
              children: [
                PageStorage(
                  bucket: _bucket,
                  child: PageView(
                    controller: prov.pageController,
                    children: _pages,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ),
              ],
            ),
            )
             
          );
        }),
      ),
    );
  }


  Future<bool> _showConfirmationDialog() async {
    return await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoAlertDialog(
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Are you sure you want to exit?",
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 16.sp, color: CupertinoColors.systemGrey),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Confirm',
              style: TextStyle(fontSize: 16.sp, color: Color(primaryColor)),
            ),
          ),
        ],
      ),
    );
  }
}
