import 'package:flutter/material.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'utils/routes.dart';
import 'package:provider/provider.dart';
import 'providers/session_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Loading .env...");
  await dotenv.load(fileName: "./assets/.env");
  print(".env loaded!");
  final AllUsersProvider allUsersProvider = AllUsersProvider();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SessionProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => RecordingProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => allUsersProvider,
        ),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.role,
      routes: appRoutes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );

  }
}
