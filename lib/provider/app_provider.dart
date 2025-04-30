
import 'dart:io';

import 'package:flutter/material.dart';

import '../service/enums.dart';

class AppProvider extends ChangeNotifier {
  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  // int _loginAttempt = 0;
  int _selectedBottomNavBar = 0;
  PageController get pageController => _pageController;
  int get selectedBottomNavBar => _selectedBottomNavBar;

  ServerEnvironment _serverEnvironment = ServerEnvironment.PRODUCTION;

  bool _globalBooleanVariable = false;
  bool get globalBooleanVariable => _globalBooleanVariable;
  set globalBooleanVariable(bool value) {
    _globalBooleanVariable = value;
    notifyListeners();
  }

  String get serverEnvironment {
    late String env;
    switch (_serverEnvironment) {
      case ServerEnvironment.PRODUCTION:
        env = 'Production';
        break;
      default:
        env = 'Development';
        break;
    }
    return env;
  }

  String get appVer {
    late String version;
    version = Platform.isIOS ? "1.0.0.1" : "1.0.0.2";
    return version;
  }

  bool _launchApp = false;
  bool get launchApp => _launchApp;
  set launchApp(bool value) {
    _launchApp = value;
    notifyListeners();
  }

  void selectBottomNavBar(int index) {
    _selectedBottomNavBar = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }

  

  // Future<DeviceModel?> getDeviceInfo(BuildContext context) async {
  //   late DeviceModel? device;

  //   final prov = Provider.of<MapProvider>(context, listen: false);
  //   final latLng = prov.currentLocation;

  //   try {
  //     final firebaseMessaging = FirebaseMessaging.instance;
  //     final String? tokenFCM = await firebaseMessaging.getToken();
  //     if (tokenFCM != null) await Utils.setTokenFCM(tokenFCM);
  //     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  //     if (Platform.isAndroid) {
  //       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //       device = DeviceModel(
  //         uuid: androidInfo.id,
  //         platform: 'android',
  //         pushToken: tokenFCM,
  //         version: '1.0.0',
  //         name: androidInfo.model,
  //         platformVersion: androidInfo.version.release,
  //         latitude: latLng?.latitude ?? null,
  //         longitude: latLng?.longitude ?? null,
  //       );
  //     } else if (Platform.isIOS) {
  //       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //       device = DeviceModel(
  //         uuid: iosInfo.identifierForVendor,
  //         platform: 'ios',
  //         pushToken: tokenFCM,
  //         version: '1.0.0',
  //         name: iosInfo.name,
  //         platformVersion: iosInfo.systemVersion,
  //         latitude: latLng?.latitude ?? null,
  //         longitude: latLng?.longitude ?? null,
  //       );
  //     } else {
  //       device = null;
  //     }
  //   } catch (e) {
  //     debugPrint('catch app prov -- $e');
  //     device = null;
  //   }
  //   return device;
  // }

  // void setLoginAttempt() {
  //   if (_loginAttempt > 2) return;
  //   _loginAttempt += 1;
  // }

  // void resetState() {
  //   _loginAttempt = 0;
  //   _selectedBottomNavBar = 0;
  // }

  // void changeServerEnv(BuildContext context, [bool devMode = false]) {
  //   late ServerEnvironment env;
  //   if (devMode) {
  //     env = ServerEnvironment.DEVELOPMENT;
  //   } else {
  //     env = ServerEnvironment.PRODUCTION;
  //   }
  //   _serverEnvironment = env;

  //   listener(context);
  // }

  // void listener(BuildContext context) async {
  //   final prefs = await SharedPreferences.getInstance();

  //   await prefs.setString(
  //     'env',
  //     serverEnvironment,
  //   );

  //   final result = prefs.getString('env');

  //   showSnackBar(context, result ?? '-');
  // }
}
