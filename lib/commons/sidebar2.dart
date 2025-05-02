import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylaundry/service/assets.dart';

import '../service/themes.dart';

class CustomSidebarLayout extends StatefulWidget {
  final Widget pageContent;
  final String userName;
  final String userHandle;
  final String userAvatarUrl;
  final Function(int index) onMenuItemTap;

  const CustomSidebarLayout({
    super.key,
    required this.pageContent,
    required this.userName,
    required this.userHandle,
    required this.userAvatarUrl,
    required this.onMenuItemTap,
  });

  @override
  State<CustomSidebarLayout> createState() => _CustomSidebarLayoutState();
}

class _CustomSidebarLayoutState extends State<CustomSidebarLayout> {
  bool _isSidebarOpen = false;
  bool _showOverlayEffect = false;
  bool _showeOver = false;
  int _selectedIndex = 0;

  void toggleSidebar() {
    if (_isSidebarOpen) {
      setState(() {
        _showeOver = false;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_isSidebarOpen) {
          setState(() {
            _showOverlayEffect = false;
          });
        }
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          _isSidebarOpen = false;
        });
      });
    } else {
      setState(() {
        _isSidebarOpen = true;
      });

      Future.delayed(const Duration(milliseconds: 200), () {
        if (_isSidebarOpen) {
          setState(() {
            _showOverlayEffect = true;
          });
          Future.delayed(const Duration(milliseconds: 100), () {
            if (_isSidebarOpen && _showOverlayEffect) {
              setState(() {
                _showeOver = true;
              });
            }
          });
        }
      });
    }
  }
  


  @override
  Widget build(BuildContext context) {
    final sidebarWidth = 240.0;

    return GestureDetector(
        onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 10 && !_isSidebarOpen) {
          toggleSidebar(); 
        } else if (details.delta.dx < -10 && _isSidebarOpen) {
          toggleSidebar();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedPadding(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(0),
              child: AnimatedScale(
                scale: _isSidebarOpen ? 0.90 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(_isSidebarOpen ? 230 : 0, 0), // Geser dikit biar mantul
                  child: GestureDetector(
                    onTap: _isSidebarOpen ? toggleSidebar : null,
                    child: AbsorbPointer(
                      absorbing: _isSidebarOpen,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(_isSidebarOpen ? 20.r : 0),
                        child: widget.pageContent,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            
            Positioned(top: 0, right: 0, left: 0, child: Container(height: 60.h, width: double.infinity, color: _isSidebarOpen ? Color(primaryColor) : Colors.transparent)),
            Positioned(bottom: 0, right: 0, left: 0, child: Container(height: 80.h, width: double.infinity, color: _isSidebarOpen ? Color(primaryColor) : Colors.transparent)),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              top: 0,
              bottom: 0,
              left: _isSidebarOpen ? 0 : -sidebarWidth,
              child: Container(
                width: sidebarWidth,
                color: const Color(primaryColor),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40.h),
                        CircleAvatar(radius: 30, backgroundImage: NetworkImage(widget.userAvatarUrl)),
                        SizedBox(height: 10.h),
                        Text(widget.userName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp)),
                        Text(widget.userHandle, style: TextStyle(color: Colors.white70)),
                         SizedBox(height: 30.h),
                        _sidebarItem(Icons.home, 'Home', 0),
                        _sidebarItem(Icons.local_laundry_service, 'My Laundry', 1),
                        _sidebarItem(Icons.chat, 'Chat', 2),
                        _sidebarItem(Icons.person, 'Profile', 3),
                        Spacer(),
                        _sidebarItem(Icons.logout, 'Logout', 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(bottom: 0, child: GestureDetector(
              onTap: () {
                 toggleSidebar();
                _showConfirmationLogout(); 
              },
              child:!_isSidebarOpen?Container(): Container(width: 209.w, height: 216.h, decoration: BoxDecoration(image: DecorationImage(image: AssetImage(bgSideBar)))))),
            Positioned(
              top: _isSidebarOpen ? 50.sp : 40.sp,
              left:_isSidebarOpen ? 16.sp: 20.sp,
                child: _isSidebarOpen
                    ? IconButton(icon: Icon(Icons.close), color: Colors.white, onPressed: toggleSidebar): GestureDetector(onTap: toggleSidebar, child: Container(height: 45.sp,width: 45,color: Colors.transparent,))
                    // : GestureDetector(onTap: toggleSidebar, child: Container(width: 45.w, height: 45.h, padding: EdgeInsets.all(10.sp), decoration: BoxDecoration(color: Color(primaryColor), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r), topRight: Radius.circular(10.r))), child: Image.asset(icHomeMenu, height: 24.h, width: 24.w, fit: BoxFit.cover)))
            ),
            if (_showOverlayEffect)
              Positioned(
                top: 80.sp,
                bottom: 120.sp,
                left: 205.sp,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  child: Container(width: 30.w, decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r)))),
                ),
              ),
            if (_showeOver)
              Positioned(
                  top: 100.sp,
                  bottom: 140.sp,
                  left: 190.sp,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    child: Container(width: 20.w, decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r)))))),
            if (_isSidebarOpen)
              Positioned(
                top: 55.sp,
                bottom: 74.sp,
                left: 220.sp,
                child: AnimatedContainer( duration: const Duration(milliseconds: 400), curve: Curves.easeOut, child: Container(width: 20.w, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r)))))),
          ],
        ),
      ),
    );
  }

  
  Widget _sidebarItem(IconData icon, String label, int index) {
    bool selected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        toggleSidebar();
        if (index == 4) {
          _showConfirmationLogout(); 
        } else {
          setState(() {
            _selectedIndex = index;
          });
          widget.onMenuItemTap(index); 
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.sp),
        child: Container(
          padding: EdgeInsets.all(10.sp),
          width: 160,
          height: 50,
          decoration: BoxDecoration(
            color: selected ? Color(selectedColor) : Colors.transparent,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
            boxShadow: [BoxShadow(color: selected ? Colors.black12 : Colors.transparent, blurRadius: 4, offset: Offset(0, 4))]),
          child: Row(
            children: [
              Icon(icon, color: selected ? Colors.white : Color(unSelectColor)),
              SizedBox(width: 10),
              Text(label, style: TextStyle(color: selected ? Colors.white : Color(unSelectColor), fontWeight: selected ? FontWeight.bold : FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmationLogout() async {
    return await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoAlertDialog(
        content: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.sp),
          child: Text(
            "Are you sure you want to log out?",
            style: TextStyle(fontSize: 14.sp),
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
              style: TextStyle(fontSize: 16.sp, color: Color(primaryColor),fontWeight: FontWeight.bold,),
            ),
          ),
        ],
      ),
    );
  }
}
