import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mylaundry/provider/laundry_provider.dart';
import 'package:mylaundry/provider/order_provider.dart';
import 'package:mylaundry/provider/user_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:secure_application/secure_application.dart';
import 'package:flutter_screenutil/src/screenutil_init.dart';
import '../routers/routers.dart' as RouterGen;
import 'provider/app_provider.dart';
import 'service/themes.dart';
import 'package:provider/src/change_notifier_provider.dart';


final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() {
  runApp(const MyLaundryMobile());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyLaundryMobile extends StatefulWidget {
  const MyLaundryMobile({super.key});

  @override
  State<MyLaundryMobile> createState() => _MyLaundryMobileState();
}

class _MyLaundryMobileState extends State<MyLaundryMobile> {
  final SecureApplicationController _secureApplicationController = SecureApplicationController(SecureApplicationState());
  @override
  void initState() {
    super.initState();
    _ini();
  }

  void _ini() async{
     await initializeDateFormatting('en', null);
    
  }

  

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 860),
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppProvider()),
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => LaundryProvider()),
            ChangeNotifierProvider(create: (_) => OrderProvider())
          ],
          child: MaterialApp(
            title: 'Booble Laundry',
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Inter',
              primaryColor: Color(primaryColor),
              bottomAppBarColor: Color(0xFFBD202E),
              backgroundColor: Color(0xFFFBFCFD),
              appBarTheme: appBarThemeCollapse(),
              scaffoldBackgroundColor: Color(0xFFFBFCFD),
              indicatorColor: Color(0xFFBD202E),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              textTheme: TextTheme(
                overline: TextStyle(
                  letterSpacing: 0.02,
                  fontWeight: FontWeight.w600,
                ),
                bodyText1: TextStyle(fontWeight: FontWeight.w600),
                bodyText2: TextStyle(fontWeight: FontWeight.w600),
                caption: TextStyle(fontWeight: FontWeight.w600),
                headline6: TextStyle(fontWeight: FontWeight.w600),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Color(primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              useMaterial3: true,
            ),
            builder: (context, child) {
              return SecureApplication(
                secureApplicationController: _secureApplicationController,
                nativeRemoveDelay: 300,
                child: SecureGate(child: child!),
              );
            },   
            navigatorObservers: [routeObserver],
            onGenerateRoute: RouterGen.Router.generateRoute,
            onUnknownRoute:  (settings) => MaterialPageRoute(
              settings: settings,
              builder: (_) => EmptyPage(),
            ),
          ),
        );
      }
    );
  }

  AppBarTheme appBarThemeCollapse() {
    return AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      centerTitle: true,
      elevation: 0,
      color: Colors.white,
    );
  }
}


class EmptyPage extends StatefulWidget {
  const EmptyPage({super.key});

  @override
  State<EmptyPage> createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            children: [
              Text("Page Not Found"),
            ],
        ),
      ),
    );
  }
}