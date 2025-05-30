import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylaundry/commons/appbar.dart';
import 'package:mylaundry/service/assets.dart';
import 'package:provider/src/provider.dart';
import '../../models/order_model.dart';
import '../../provider/order_provider.dart';
import '../../service/themes.dart';


class MyLaundryPage extends StatefulWidget {
  const MyLaundryPage({super.key});

  @override
  State<MyLaundryPage> createState() => _MyLaundryPageState();
}

class _MyLaundryPageState extends State<MyLaundryPage> {
  List<OrderModel> orderListModel = [];
  bool _isOrder = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await _getOrderHistory();
  }

  Future<void> _getOrderHistory() async {
    final orderProv = Provider.of<OrderProvider>(context, listen: false);
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
    } finally {
      setState(() {
        _isOrder = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final serviceTypes = ['All',...orderListModel.map((e) => e.serviceType).toSet().toList()];

    return DefaultTabController(
      length: serviceTypes.length,
      child: Scaffold(
        body: SafeArea(
          child: _isOrder ? Center(child: CircularProgressIndicator()): Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.sp),
            child: Column(
              children: [
                AppBarLaundry(title: "My Laundry"),
                SizedBox(height: 20.h),
                TabBar(
                  isScrollable: false,
                  labelColor: Color(primaryColor),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Color(primaryColor),
                  labelPadding: EdgeInsets.zero,
                  tabs: serviceTypes.map((type) {
                    return Tab(
                      child: Container(
                        width: 70.w, 
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(type ?? '', style: TextStyle(fontSize: 12.sp))
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: orderListModel.isEmpty? Center(child: Text('Tidak ada data order.', style: TextStyle(fontSize: 18, color: Colors.grey))): 
                    TabBarView(
                    children: serviceTypes.map((type) {
                      final filteredOrders = type == 'All' ? orderListModel : orderListModel.where((order) => order.serviceType == type).toList();
                      return ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 108.h,
                                padding: EdgeInsets.all(10.sp),
                                decoration: BoxDecoration(
                                  color: Color(secondaryColor),
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r), topRight: Radius.circular(10.r))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("${order.serviceName}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on_outlined, size: 15.sp, color: Color(primaryColor)),
                                            Text("${order.address}", style: TextStyle(fontSize: 11.sp)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.date_range_outlined, size: 15.sp, color: Color(primaryColor)),
                                            Text("${order.estimatedFinish}", style: TextStyle(fontSize: 11.sp)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10.sp),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Rp ${order.price}", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(primaryColor))),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(5.sp),
                                                decoration: BoxDecoration(color: Colors.red[100], shape: BoxShape.circle),
                                                child: Icon(Icons.delete_rounded, size: 12.sp, color: Colors.red)),
                                              SizedBox(width: 5.sp),
                                              Container(
                                                padding: EdgeInsets.all(5.sp),
                                                decoration: BoxDecoration(color: Color(primaryColor).withOpacity(0.15), shape: BoxShape.circle),
                                                child: Icon(Icons.check_sharp, size: 12.sp, color: Color(primaryColor)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}