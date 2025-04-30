import 'package:flutter/material.dart';

class CustomSidebarLayout extends StatefulWidget {
  final Widget pageContent;
  final String userName;
  final String userHandle;
  final String userAvatarUrl;

  const CustomSidebarLayout({
    super.key,
    required this.pageContent,
    required this.userName,
    required this.userHandle,
    required this.userAvatarUrl,
  });

  @override
  State<CustomSidebarLayout> createState() => _CustomSidebarLayoutState();
}

class _CustomSidebarLayoutState extends State<CustomSidebarLayout> {
  bool _isSidebarOpen = false;
  bool _showOverlayEffect = false;
  bool _showeOver = false;

  // void toggleSidebar() {
  //   if (_isSidebarOpen) {
  //     setState(() {
  //       _showeOver = false;
  //     });
  //     Future.delayed(const Duration(milliseconds: 100), () {
  //       if (_isSidebarOpen) {
  //         setState(() {
  //           _showOverlayEffect = false;
  //         });
  //       }
  //     });
  //     Future.delayed(const Duration(milliseconds: 200), () {
  //       setState(() {
  //         _isSidebarOpen = false;
  //       });
  //     });
  //   } else {
  //     setState(() {
  //       _isSidebarOpen = true;
  //     });

  //     Future.delayed(const Duration(milliseconds: 200), () {
  //       if (_isSidebarOpen) {
  //         setState(() {
  //           _showOverlayEffect = true;
  //         });
  //         Future.delayed(const Duration(milliseconds: 100), () {
  //           if (_isSidebarOpen && _showOverlayEffect) {
  //             setState(() {
  //               _showeOver = true;
  //             });
  //           }
  //         });
  //       }
  //     });
  //   }
  // }
  void toggleSidebar() {
    if (_isSidebarOpen) {
      setState(() {
        _showeOver = false;
        _showOverlayEffect = false;
        _isSidebarOpen = false;
      });
    } else {
      setState(() {
        _isSidebarOpen = true;
      });

      Future.delayed(const Duration(milliseconds: 200), () {
        if (!_isSidebarOpen) return;
        setState(() {
          _showOverlayEffect = true;
        });
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (!_isSidebarOpen || !_showOverlayEffect) return;
        setState(() {
          _showeOver = true;
        });
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final sidebarWidth = 240.0;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.only(
              left: _isSidebarOpen ? 240.0 : 0.0,
            ),
            child: AnimatedScale(
              scale: _isSidebarOpen ? 0.8 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: GestureDetector(
                onTap: _isSidebarOpen ? toggleSidebar : null,
                child: AbsorbPointer(
                  absorbing: _isSidebarOpen,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_isSidebarOpen ? 20 : 0),
                    child: widget.pageContent,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 60,
              width: double.infinity,
              color: _isSidebarOpen ? Color(0xFF2D837E) : Colors.transparent,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 80,
              width: double.infinity,
              color: _isSidebarOpen ? Color(0xFF2D837E) : Colors.transparent,
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            top: 0,
            bottom: 0,
            left: _isSidebarOpen ? 0 : -sidebarWidth,
            child: Container(
              width: sidebarWidth,
              color: const Color(0xFF2D837E),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(widget.userAvatarUrl),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.userHandle,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 30),
                      _sidebarItem(Icons.home, 'Home', true),
                      _sidebarItem(Icons.local_laundry_service, 'My Laundry', false),
                      _sidebarItem(Icons.chat, 'Chat', false),
                      _sidebarItem(Icons.person, 'Profile', false),
                      const Spacer(),
                      _sidebarItem(Icons.logout, 'Logout', false),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: _isSidebarOpen ? 50 : 30,
            left: 16,
            child: _isSidebarOpen
                ? IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.white,
                    onPressed: toggleSidebar,
                  )
                : GestureDetector(
                    onTap: toggleSidebar,
                    child: Container(
                      height: 30,
                      width: 30,
                      color: Colors.transparent,
                    )),
          ),
          if (_showOverlayEffect)
            Positioned(
              top: 80,
              bottom: 120,
              left: 210,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                child: Container(
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
                  ),
                ),
              ),
            ),
          if (_showeOver)
            Positioned(
              top: 100,
              bottom: 140,
              left: 190,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                child: Container(
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
                  ),
                ),
              ),
            ),
          if (_isSidebarOpen)
            Positioned(
              top: 60,
              bottom: 80,
              left: 230,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                child: Container(
                  width: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: selected ? Colors.white : Colors.white70),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white70,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
