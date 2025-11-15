import 'package:flutter/material.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'utils/routes.dart';
import 'package:audio_session/audio_session.dart';
import 'package:provider/provider.dart';
import 'providers/session_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => SessionProvider(),
        ),

        ChangeNotifierProxyProvider<SessionProvider, RecordingProvider>(
          create: (_) => RecordingProvider(null), 
          update: (_, generalProvider, previous) {
            previous!.updateStudent(generalProvider);
            return RecordingProvider(generalProvider);
          }
        )
        
      ],
      child: const MaterialApp(home: MyApp())
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