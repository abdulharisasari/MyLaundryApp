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

  void toggleSidebar() {
    if (_isSidebarOpen) {
      // Tutup dengan urutan terbalik
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
      // Buka sidebar
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
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
            child: _isSidebarOpen?Container(): widget.pageContent,
          ),
          Positioned(
            top: 0,
            left: 0,
            child: GestureDetector(
              onTap: toggleSidebar,
              child: Container(
                height: 100,
                width: 100,
                color: Colors.transparent,
              ),
            ),
          ),
          if (_isSidebarOpen)
            GestureDetector(
              onTap: toggleSidebar,
              child: Container(
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            top: 0,
            bottom: 0,
            left: _isSidebarOpen ? 0 : -270,
            child: Container(
              width: 270,
              color: const Color(0xFF2D837E),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: toggleSidebar,
                            ),
                          ),
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isSidebarOpen)
            Positioned(
              top: 65,
              right: 70,
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: toggleSidebar,
              ),
            ),
          if (_isSidebarOpen)
            Positioned(
              top: 0,
              bottom: 100,
              left: 310,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.slowMiddle,
                child: widget.pageContent,
              ),
            ),
          if (_showOverlayEffect)
            Positioned(
              top: 80,
              bottom: 120,
              left: 240,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                child: Container(
                  width: 30,
                  color: Colors.white54,
                ),
              ),
            ),
          if (_showeOver)
            Positioned(
              top: 100,
              bottom: 140,
              left: 220,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                child: Container(
                  width: 20,
                  color: Colors.white10,
                ),
              ),
            ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 900),
                curve: Curves.bounceInOut,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  color: _isSidebarOpen ? Color(0xFF2D837E) : Colors.transparent,
                ),
              )),
          Positioned(
              left: 100,
              right: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 900),
                curve: Curves.bounceInOut,
                child: Container(
                  height: 100,
                  width: double.infinity,
                  color: _isSidebarOpen ? Color(0xFF2D837E) : Colors.transparent,
                ),
              )),
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
