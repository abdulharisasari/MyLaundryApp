import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../service/assets.dart';
import '../service/themes.dart';

class AppBarLaundry extends StatefulWidget {
  final String title;
  final bool? logo;
  const AppBarLaundry({super.key, required this.title, this.logo = true});

  @override
  State<AppBarLaundry> createState() => _AppBarLaundryState();
}

class _AppBarLaundryState extends State<AppBarLaundry> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 45.w,
          height: 40.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Color(primaryColor), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r), topRight: Radius.circular(10.r))),
          child: Icon(Icons.chevron_left, color: Colors.white),
        ),
        SizedBox(width: 2.w),
        Text("${widget.title}", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
        Container(child:widget.logo == true? Image.asset(logoMyLaundry, height: 60.h, color: Color(primaryColor).withOpacity(0.9)): Container(width: 95.w)),
      ],
    );
  }
}
