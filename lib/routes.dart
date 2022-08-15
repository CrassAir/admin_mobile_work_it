import 'package:admin_mobile_work_it/pages/home_page.dart';
import 'package:admin_mobile_work_it/pages/landing_page.dart';
import 'package:admin_mobile_work_it/pages/login_page.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class RouterHelper {
  static const initial = '/loading';
  static const home = '/';
  static const login = '/login';

  static List<GetPage> routes = [
    GetPage(name: login, page: () => LoginPage(), curve: Curves.elasticInOut, transition: Transition.downToUp),
    GetPage(
        name: home,
        page: () => const HomePage(),
        curve: Curves.elasticInOut,
        transitionDuration: const Duration(milliseconds: 2500)),
    GetPage(
      name: initial,
      page: () => const AnimatePage(),
      transition: Transition.noTransition,
    ),
  ];
}
