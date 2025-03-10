import 'package:flutter/material.dart';

import '../../features/admin/add_new_caregiver/presentation/screens/add_caregiver_screen.dart';



class RouteKeys {
  static const String welcomeScreen = '/welcomeScreen';

  static const String addCaregiverScreen = '/addCaregiverScreen';

}
class Routes {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteKeys.welcomeScreen:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Welcome Screen'),
            ),
          ),
        );
      case RouteKeys.addCaregiverScreen:
        return MaterialPageRoute(
          builder: (_) => AddCaregiverScreen()
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
