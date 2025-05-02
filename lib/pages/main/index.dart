import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylaundry/provider/user_provider.dart';
import 'package:provider/src/consumer.dart';
import 'package:provider/src/provider.dart';
import '../../commons/sidebar2.dart';
import '../../models/user_model.dart';
import '../../provider/app_provider.dart';
import '../../routers/constants.dart';
import '../../service/themes.dart';
import '../chat/index.dart';
import '../home/index.dart';
import '../laundry/index.dart';
import '../profile/index.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with RouteAware {
  late PageController _pageController;
  late List<Widget> _pages;
  
  final PageStorageBucket _bucket = PageStorageBucket();
  
  int _currentPageIndex = 0;
  UserModel mUser = UserModel();
  bool _isLoading = false;




  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
    _init();
    _getProfile();

  }

  void _init() async {
    _pages = [
      HomePage(key: PageStorageKey<String>('home'), onTapMenuItem: navigateToPage, isGuest: false),
      MyLaundryPage(),
      ChatPage(),
      ProfilePage(),
      Container(),
    ];
  }

  Future<void> _getProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    try {
      final userState = await userProvider.getMe(context);
      if (userState != null) {
        mUser = userState;
      }
      debugPrint("mUser ${mUser.fullName}");
    } catch (e) {
      debugPrint("catch _getProfile -- $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  


  void navigateToPage(int index) {
    if (index == 4) return;

    setState(() {
      _currentPageIndex = index;
    });
    _pageController.jumpToPage(index); 
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
              body: CustomSidebarLayout(
                userName: "${mUser.fullName}",
                userHandle: '@${mUser.userName}',
                userAvatarUrl: '${mUser.imageUrl}',
                onMenuItemTap: navigateToPage,
                pageContent: Stack(
                  children: [
                    PageView(
                      controller: _pageController, 
                      children: _pages,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ],
                ),
              ));
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
