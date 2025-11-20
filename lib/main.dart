import 'package:flutter/material.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'utils/routes.dart';
import 'package:audio_session/audio_session.dart';
import 'package:provider/provider.dart';
import 'providers/session_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SessionProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => RecordingProvider(),
        ),

        // OLD CODE USED TO CONNECT THE TWO PROVIDERS
        // ChangeNotifierProxyProvider<SessionProvider, RecordingProvider>(
        //   create: (_) => RecordingProvider(null), 
        //   update: (_, generalProvider, previous) {
        //     previous!.updateStudent(generalProvider);
        //     return RecordingProvider(generalProvider);
        //   }
        // ),

        ChangeNotifierProvider(
          create: (_) => AllUsersProvider(),
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
    AllUsersProvider allUsersProvider = context.read<AllUsersProvider>();

    return FutureBuilder<void>(
      future: allUsersProvider.loadUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();


        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Optionally retry load
                      allUsersProvider.loadUserData();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            )
          );
        // } else if (snapshot.hasError) {
        //   return Text('Error: ${snapshot.error}');




        } else {
          // final String lastLoggedInUsername = allUsersProvider.allUserData!.lastLoggedInUser!.username;
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
    );
  }
}