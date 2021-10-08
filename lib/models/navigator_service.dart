
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

}

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => NavigatorService());
}