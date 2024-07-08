import 'package:dars8/controller/destanation_controller.dart';
import 'package:dars8/firebase_options.dart';
import 'package:dars8/services/location_services.dart';
import 'package:dars8/views/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // PermissionStatus cameraPermission = await Permission.camera.status;
  // PermissionStatus locationPermission = await Permission.location.status;
  //
  // if (cameraPermission != PermissionStatus.granted) {
  //   await Permission.camera.request();
  // }
  // if (locationPermission != PermissionStatus.granted) {
  //   await Permission.location.request();
  // }

  /// PERMISSIONS
  if (!(await Permission.camera.request().isGranted) ||
      !(await Permission.location.request().isGranted)) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
    ].request();
    debugPrint("Permission statuses: $statuses");
  }

  await LocationService.init();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DestinationsController(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}
