import 'package:flutter/material.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'utils/routes.dart';
import 'package:audio_session/audio_session.dart';
import 'package:provider/provider.dart';
import 'providers/session_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AllUsersProvider allUsersProvider = AllUsersProvider();
  // await allUsersProvider.loadUserData();

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
          // create: (_) => AllUsersProvider(),
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










    // AllUsersProvider allUsersProvider = context.read<AllUsersProvider>();

    // return FutureBuilder<void>(
    //   future: allUsersProvider.loadUserData(),
    //   builder: (context, snapshot) {
        
    //     // //
    //     // // 1. WAITING
    //     // //
    //     // if (snapshot.connectionState == ConnectionState.waiting) {
    //     //   print("waiting");
    //     //   return const MaterialApp(
    //     //     home: Scaffold(
    //     //       body: Center(
    //     //         child: CircularProgressIndicator(),
    //     //       ),
    //     //     ),
    //     //   );
    //     // }

    //     // //
    //     // // 2. ERROR
    //     // //
    //     // if (snapshot.hasError) {
    //     //   print("Snapshot has error");
    //     //   return MaterialApp(
    //     //     home: Scaffold(
    //     //       body: Center(
    //     //         child: Padding(
    //     //           padding: EdgeInsets.all(16.0),
    //     //           child: Column(
    //     //             mainAxisAlignment: MainAxisAlignment.center,
    //     //             children: [
    //     //               Text(
    //     //                 snapshot.error.toString(),
    //     //                 style: TextStyle(
    //     //                   color: Colors.red,
    //     //                   fontSize: 18,
    //     //                 ),
    //     //                 textAlign: TextAlign.center,
    //     //               ),
    //     //               SizedBox(height: 20),
    //     //               ElevatedButton(
    //     //                 onPressed: () {
    //     //                   // Force rebuild by creating a new future
    //     //                   // (context as Element).markNeedsBuild();
    //     //                 },
    //     //                 child: Text("Retry"),
    //     //               ),
    //     //               SizedBox(height: 20,),
    //     //               ElevatedButton(
    //     //                 onPressed: () {
    //     //                   allUsersProvider.quarantineCorruptFile();
    //     //                   // Force rebuild by creating a new future
    //     //                   // (context as Element).markNeedsBuild();
    //     //                 },
    //     //                 child: Text("Move Save File To Corrupted"),
    //     //               ),
    //     //               SizedBox(height: 20,),
    //     //               ElevatedButton(
    //     //                 onPressed: () {
    //     //                   try
    //     //                   {
    //     //                   allUsersProvider.deleteUserData();
    //     //                   }
    //     //                   catch (e) {
    //     //                     print("Error deleting user data: $e");
    //     //                   }
    //     //                   // Force rebuild by creating a new future
    //     //                   // (context as Element).markNeedsBuild();
    //     //                 },
    //     //                 child: Text("Delete Save File"),
    //     //               ),
    //     //             ],
    //     //           ),
    //     //         ),
    //     //       ),
    //     //     ),
    //     //   );
    //     // }

    //     // //
    //     // // 3. SUCCESS
    //     // //
    //     // print("Snapshot has no error");
    //     return MaterialApp(
    //       title: 'Navigation Demo',
    //       debugShowCheckedModeBanner: false,
    //       initialRoute: AppRoutes.role,
    //       routes: appRoutes,
    //       theme: ThemeData(
    //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //         useMaterial3: true,
    //       ),
    //     );
    //   },
    // );








  
  }
}
