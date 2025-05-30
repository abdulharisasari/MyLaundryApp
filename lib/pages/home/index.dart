import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylaundry/models/laundry_model.dart';
import 'package:mylaundry/models/order_model.dart';
import 'package:mylaundry/provider/laundry_provider.dart';
import 'package:mylaundry/provider/order_provider.dart';
import 'package:mylaundry/provider/user_provider.dart';
import 'package:mylaundry/service/assets.dart';
import 'package:mylaundry/service/themes.dart';
import 'package:provider/src/provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/user_model.dart';
import '../../service/utisl.dart';

class HomePage extends StatefulWidget {
  final void Function(int) onTapMenuItem;
  final bool isGuest;
  const HomePage({Key? key, required this.onTapMenuItem, required this.isGuest}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LaundryModel> laundryListModel = [];
  List<OrderModel> orderListModel = [];
  List<bool> _visibleList = [];

  UserModel mUser = UserModel();
  FocusNode _searchFN = FocusNode();
  String address = '';
  bool _isLoading = false, _isLaundryFetched = false, _isOrder = false;


  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await _getProfile();    
    await _getLaundry();
    await _getOrderHistory();
    _fetchUserLocation();
    _visibleList = List.filled(laundryListModel.length, false);
    _startAnimation();
  }


  void _startAnimation() {
    for (int i = 0; i < laundryListModel.length; i++) {
      Future.delayed(Duration(milliseconds: 200 * i), () {
        if (mounted) {
          setState(() {
            _visibleList[i] = true;
          });
        }
      });
    }
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

  void _fetchUserLocation() async {
    try {
      Position position = await _getCurrentPosition();
      String kecamatan = await _getAddressFromPosition(position);
      setState(() {
        address = kecamatan;
      });
      print('Kecamatan saat ini: $kecamatan');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

  LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<String> _getAddressFromPosition(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String? kecamatan = place.subAdministrativeArea ?? place.subLocality;
      return kecamatan ?? 'Kecamatan tidak ditemukan';
    } else {
      return 'Alamat tidak ditemukan';
    }
  }

  Future<void> _getLaundry() async{
    final laundryProv = Provider.of<LaundryProvider>(context, listen: false);
    setState(() {
      _isLaundryFetched = true;
    });
    try {
      final laundryState = await laundryProv.fetchLaundries();
      if (laundryState.isNotEmpty) {
        setState(() {
          laundryListModel = laundryState;
        });
      }
    } catch (e) {
      debugPrint("catch _getLaundry -- $e");
    }finally{
      setState(() {
       _isLaundryFetched = false;
      });
    }
  }

  Future<void> _getOrderHistory() async{
    final orderProv = Provider.of<OrderProvider>(context,listen: false);
    setState(() {
      _isOrder = true;
    });
    try {
      final orderState = await orderProv.fetchOrders();
      if (orderState.isNotEmpty) {
        setState(() {
          orderListModel = orderState;
        });
      }
    } catch (e) {
      debugPrint("catch -getOrderHistory --$e");
    }finally{
      setState(() {
        _isOrder =false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:_isLoading?Center(child: CircularProgressIndicator()): Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 45.w,
                    height: 45.h,
                    padding: EdgeInsets.all(10.sp), decoration: BoxDecoration(color: Color(primaryColor), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r), topRight: Radius.circular(10.r))),
                    child: Image.asset(icHomeMenu, height: 24.h, width: 24.w, fit: BoxFit.cover)),
                  Column(
                    children: [
                      Text("$address", style: TextStyle(fontSize: 16.sp, color: Color(primaryColor))),
                      Text("${Utils.formatDateTime(DateTime.now(), locale: "en")}", style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w300)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.notifications, color: Color(darkColor3), size: 24.sp),
                      CircleAvatar(radius: 25.sp, backgroundImage: NetworkImage("${mUser.imageUrl}")),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 12.sp),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r), topRight: Radius.circular(20.r))),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: null,
                        focusNode: _searchFN,
                        onTapOutside: (event) => _searchFN.unfocus(),
                        decoration: InputDecoration.collapsed(filled: true, fillColor: Colors.transparent, hintText: "Searh for a laundry?", hintStyle: TextStyle(color: Colors.grey[500]), hoverColor: Colors.transparent),
                        onFieldSubmitted: (value) {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Icon(Icons.search, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
              Text("Category", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Color(primaryColor))),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _menu("Wash",icMenuWash),_menu("Dry Clean",icMenuDryClean),_menu("Iron",icMenuIron),_menu("Shoes",icMenuShoes)
                ],
              ),
              SizedBox(height: 35.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Populer Laundry", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Color(primaryColor))),
                  Text("See all", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Color(primaryColor))),
                ],
              ),
              SizedBox(height: 5.h),
              Container(
                height: 230.h,
                child:_isLaundryFetched?Center(child: CircularProgressIndicator()): laundryListModel.isEmpty? Center(child: Text('Tidak ada data order.', style: TextStyle(fontSize: 18, color: Colors.grey))): 
                ListView.builder(
                 scrollDirection: Axis.horizontal,
                 itemCount: laundryListModel.length,
                 itemBuilder: (context, index) {
                   final laundry = laundryListModel[index];
                   return GestureDetector(
                     onTap: () {},
                     child: Card(
                      margin: EdgeInsets.only(right: 20.w, top: 10.h, bottom: 10.h),
                      elevation: 4,
                      child: Container(
                        width: 240.w,
                        decoration: BoxDecoration(
                          color: Color(lightColor4), 
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.r), topRight: Radius.circular(15.r)), 
                          boxShadow: [BoxShadow(color: Color(0x19000000), blurRadius: 4, offset: Offset(0, 4))],),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:BorderRadius.only(bottomLeft: Radius.circular(10.r),topRight: Radius.circular(10.r)),
                              child: Image.network(
                                laundry.imageUrl ?? '',
                                height: 125.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300], height: 125.h, child: Icon(Icons.image_not_supported, color: Colors.grey)),
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child; 
                                  return Container(height: 125.h, alignment: Alignment.center, child: CircularProgressIndicator());
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${laundry.name}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                                  if (laundry.rating != null) ...[
                                    Row(
                                      children: [
                                        for (int i = 0; i < 5; i++)
                                        Icon(i < laundry.rating! ? Icons.star : Icons.star_border, color: Colors.amber, size: 12.sp),
                                        SizedBox(width: 8.w),
                                        SizedBox(width: 5.w),
                                        Text("(${laundry.totalOrders})", style: TextStyle(fontSize: 12.sp, color: Colors.grey))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.access_time, color: Colors.grey, size: 16.sp),
                                            SizedBox(width: 4.w),
                                            Text('${laundry.openTime} PM - ${laundry.closeTime} PM', style: TextStyle(color: Colors.grey, fontSize: 9.sp))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on_outlined, color: Colors.grey, size: 16.sp),
                                            SizedBox(width: 4.w),
                                            Text('${laundry.distance} Km', style: TextStyle(color: Colors.grey, fontSize: 9.sp))
                                          ],
                                        ),
                                      ],
                                    )
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                   );
                 },
               ),
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("History", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Color(primaryColor))),
                  Text("See all", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Color(primaryColor))),
                ],
              ),
              SizedBox(height: 15.h),
              Container(
                height: 110.h,
                child:_isOrder? Center(child: CircularProgressIndicator()): orderListModel.isEmpty ? Center(child: Text('Tidak ada data order.', style: TextStyle(fontSize: 18, color: Colors.grey))): 
                  ListView.builder(
                  itemCount: orderListModel.length,
                  itemBuilder: (context, index) {
                    final order = orderListModel[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 20.h), 
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 108.h,
                          decoration: BoxDecoration(
                            color: Color(secondaryColor),
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r), topRight: Radius.circular(10.r))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
                                    child: Image.network(
                                      order.imageUrl ?? '',
                                      height: 125.h,
                                      width: 95.w,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300], height: 125.h, child: Icon(Icons.image_not_supported, color: Colors.grey)),
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(height: 125.h, alignment: Alignment.center, child: CircularProgressIndicator());
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${order.serviceName}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on_outlined,size: 15.sp, color: Color(primaryColor)),
                                          Text("${order.address}", style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.normal)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.date_range_outlined, size: 15.sp, color: Color(primaryColor)),
                                          Text("${order.estimatedFinish}", style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.normal)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 70.w,
                                      height: 30.h, decoration: BoxDecoration(color: Color(primaryColor), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r), topRight: Radius.circular(10.r))),
                                      child: Center(child: Text("${order.serviceType}", style: TextStyle(color: Colors.white)))),
                                  Text("\$${order.price}", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold,color: Color(primaryColor))),
                                  SizedBox(height: 10.h)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },

                ),
              ),
              SizedBox(height: 20.h)
            ],
          ),
        ),
      ),
    );
  }

  Widget _menu(String label, String path) {
    return Column(
      children: [
        Container(
          height: 70.h,
          width: 70.w,
          padding: EdgeInsets.all(15.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.r), topRight: Radius.circular(15.r)),
            color: Color(primaryColor),
            boxShadow: [BoxShadow(color: Color(darkColor3), blurRadius: 4, offset: Offset(0, 4))]),
          child: Image.asset(path, fit: BoxFit.cover)),
        SizedBox(height: 10.h),
        Text(label, style: TextStyle(fontSize: 15.sp, color: Color(primaryColor))),
      ],
    );
  }
}
