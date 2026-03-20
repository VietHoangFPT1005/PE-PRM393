import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_constants.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/major_provider.dart';
import 'presentation/providers/student_provider.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/student/student_list_screen.dart';
import 'presentation/screens/major/major_list_screen.dart';
import 'presentation/screens/map/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MajorProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
      ],
      child: MaterialApp(
        title: 'Student Management',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(), // Vào thẳng Home, không cần login
        routes: {
          '/home': (_) => const HomeScreen(),
          '/students': (_) => const StudentListScreen(),
          '/majors': (_) => const MajorListScreen(),
          '/map': (_) => const MapScreen(),
        },
      ),
    );
  }
}
