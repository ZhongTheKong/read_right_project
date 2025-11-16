import 'package:flutter/material.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'utils/routes.dart';
import 'package:audio_session/audio_session.dart';
import 'package:provider/provider.dart';
import 'providers/session_provider.dart';

void main() async {

  final AllUsersProvider allUsersProvider = AllUsersProvider();
  await allUsersProvider.loadUserData();
  print("User data loaded");

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
        ),
        ChangeNotifierProvider(create: (_) => allUsersProvider),
        
      ],
      child: const MaterialApp(home: MyApp())
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // AllUsersProvider allUsersProvider = context.read<AllUsersProvider>();
    print("MyApp Started");
    // allUsersProvider.loadUserData();

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

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final allUsersProvider = context.read<AllUsersProvider>();

//     return FutureBuilder(
//       future: allUsersProvider.loadUserData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const MaterialApp(
//             home: Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             ),
//           );
//         } else {
//           // Data loaded, build real app
//           return MaterialApp(
//             title: 'Navigation Demo',
//             debugShowCheckedModeBanner: false,
//             initialRoute: AppRoutes.role,
//             routes: appRoutes,
//             theme: ThemeData(
//               colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//               useMaterial3: true,
//             ),
//           );
//         }
//       },
//     );
//   }
// }