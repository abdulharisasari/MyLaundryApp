import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylaundry/commons/appbar.dart';
import 'package:mylaundry/service/themes.dart';
import 'package:provider/src/provider.dart';

import '../../models/user_model.dart';
import '../../provider/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel mUser = UserModel();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getProfile();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 22.sp,vertical: 10.sp),
          child: Column(
            children: [
              AppBarLaundry(title: "Profile", logo: false),
              SizedBox(height: 10.h),
              Container(
                width: 150,
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(radius: 75, backgroundImage: NetworkImage("${mUser.imageUrl}")),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        height: 35.h,
                        width: 35.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(primaryColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit, size: 18, color: Colors.white),
                          padding: EdgeInsets.all(4),
                          constraints: BoxConstraints(),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text("${mUser.fullName}", style: TextStyle(fontSize: 20.sp)),
              Text("@ ${mUser.userName}", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400)),
              SizedBox(height: 50.h),
              field(label: "Phone Number", hintext: "+6288225236570", ic: Icons.call),
              field(label: "Password", hintext: "*****", ic: Icons.key),
              field(label: "Address", hintext: "+6288225236570", ic: Icons.location_on_outlined),
              Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 200.h,
                    height: 55.h,
                    decoration: BoxDecoration(color: Colors.red[900], borderRadius: BorderRadius.only(topRight: Radius.circular(12.r), bottomLeft: Radius.circular(12.r))),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete, color: Colors.white),
                        SizedBox(width: 5.w),
                        Text("Delete Account", style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  InkWell(
                    onTap: () {
                      _showConfirmationLogout();
                    },
                    child: Container(
                      width: 135.w,
                      decoration: BoxDecoration(color: Color(primaryColor), borderRadius: BorderRadius.only(topRight: Radius.circular(12.r), bottomLeft: Radius.circular(12.r))),
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(width: 5.w),
                          Text("Logout", style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 35.h)
            ],
          ),
        ),
      ),
    );
  }

  Widget field({required String label, required String hintext, required IconData ic}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 5.h),
        Container(
          decoration: BoxDecoration(border: Border.all(width: 1.sp, color: Color(darkColor4)), borderRadius: BorderRadius.all(Radius.circular(12.r))),
          padding: EdgeInsets.symmetric(horizontal: 12.sp),
          alignment: Alignment.center,
          child: TextField(decoration: InputDecoration(hintText: hintext, hintStyle: TextStyle(fontSize: 14.sp), enabledBorder: InputBorder.none, border: InputBorder.none, icon: Icon(ic, color: Color(primaryColor), size: 23.sp))),
        ),
        SizedBox(height: 20.h)
      ],
    );
  }

  Future<bool> _showConfirmationLogout() async {
    return await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoAlertDialog(
        content: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.sp),
          child: Text("Are you sure you want to log out?", style: TextStyle(fontSize: 14.sp)),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(fontSize: 16.sp, color: CupertinoColors.systemGrey)),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Confirm', style: TextStyle(fontSize: 16.sp, color: Color(primaryColor), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
