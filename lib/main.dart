import 'package:diary_app/screens/onboarding_screen.dart';
import 'package:diary_app/screens/splash_screen.dart';
import 'package:diary_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import './providers/memories.dart';
import 'screens/add_memory_screen.dart';
import 'screens/memory_detail_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  runApp(MyApp(showHome: showHome));
}

class MyApp extends StatelessWidget {
  final bool showHome;
  const MyApp({
    Key? key,
    required this.showHome,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Memories(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Great Places',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          home: showHome ? const SplashScreen() : const OnBordingScreen(),
          routes: {
            AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
            MemoryDetailScreen.routeName: (ctx) => MemoryDetailScreen(null),
            BottomNavBar.routeName: (ctx) => BottomNavBar(),
          }),
    );
  }
}
