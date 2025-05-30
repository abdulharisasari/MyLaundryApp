import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mylaundry/service/themes.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageTC = TextEditingController();

  FocusNode messageFN = FocusNode();
  String time = DateFormat.Hm().format(DateTime.now());

  List<Map<String, dynamic>> messages = [
    {
      'sender': 'user',
      'text': "P"
    },
    {
      'sender': 'user',
      'text': "Sombong amat!!!!"
    },
  ];

  void sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      messages.add({
        "sender": "admin",
        "text": message.trim()
      });
    });

    messageTC.clear();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        messages.add({
          "sender": "user",
          "text": _generateAutoReply(message)
        });
      });
    });
  }

  String _generateAutoReply(String input) {
    input = input.toLowerCase();

    if (input.contains("apa") || input.contains("kenapa?") || input.contains("kenapa")) {
      return "Pinjem dulu 100 bro 😊";
    } else if (input.contains("ga")) {
      return "Pelit amat jadi orang \n padahal sama temen sendiri 😒";
    } else if (input.contains("terima kasih")) {
      return "Sama-sama!";
    } else if (input.contains("lu siapa?")) {
      return "Saya adalah bot admin otomatis 😊";
    }
    return "Ngetik yang benerlah 😒";
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Color(primaryColor), statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        body: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Container(
                height: 93.h,
                width: double.infinity,
                color: Color(primaryColor),
                padding: EdgeInsets.only(top: 30.h, left: 18.w, right: 18.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.chevron_left, size: 30.sp, color: Color(lightColor3).withOpacity(0.5)),
                        SizedBox(width: 6.w),
                        Container(height: 45.h, child: CircleAvatar(radius: 25.sp, backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"))),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Miso Dry Cleaning", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                            Text("Online", style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: Color(lightColor3).withOpacity(0.7))),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.videocam, size: 24.sp, color: Color(lightColor3).withOpacity(0.5)),
                        SizedBox(width: 10.w),
                        Icon(Icons.call, size: 24.sp, color: Color(lightColor3).withOpacity(0.5))
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: 640.h,
                child: ListView(
                  padding: EdgeInsets.all(18.sp),
                  children: [
                    ...messages.map((msg) {
                      bool isSend = msg['sender'] == 'admin';
                      return Row(
                        mainAxisAlignment: isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 5.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.sp),
                                margin: EdgeInsets.symmetric(vertical: 5.h),
                                constraints: BoxConstraints(maxWidth: 250.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.r), topRight: Radius.circular(8.r)), color: isSend ? Color(lightColor3) :  Color(secondaryColor),
                                  border: Border.all(width: 1.sp, color: isSend ? Color(primaryColor) : Colors.transparent)),
                                child: Text(
                                  msg['text'],
                                  style: TextStyle(fontSize: 14.sp, color:  Color(darkColor1), fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(color: Color(lightColor3)),
                                child: Text("$time", style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: Color(darkColor3))),
                              ),
                              SizedBox(height: 5.h)
                            ],
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(18.sp),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(lightColor3),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)),
                          boxShadow: [
                            BoxShadow(color: Color(darkColor3), blurRadius: 4, offset: Offset(0, 2))
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: messageTC,
                                focusNode: messageFN,
                                style: TextStyle(color: Color(darkColor1), fontSize: 15.sp),
                                onTapOutside: (event) => messageFN.unfocus(),
                                minLines: 1,
                                maxLines: 4,
                                textInputAction: TextInputAction.send,
                                decoration: InputDecoration(
                                  hintText: "Type here...",
                                  border: InputBorder.none,
                                  isCollapsed: false,
                                  contentPadding: EdgeInsets.symmetric(vertical: 14.sp),
                                  hintStyle: TextStyle(fontSize: 15.sp, color: Colors.grey),
                                ),
                                onSubmitted: (value) => sendMessage(value),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(Icons.camera_alt_rounded, color: Color(darkColor3)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(primaryColor),
                        boxShadow: [
                          BoxShadow(color: Color(darkColor3), blurRadius: 4, offset: Offset(0, 2))
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: () => sendMessage(messageTC.text),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
