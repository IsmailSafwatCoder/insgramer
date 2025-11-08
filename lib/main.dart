import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagramer/providers/like_provider.dart';
import 'package:instagramer/providers/save_provider.dart';
import 'package:instagramer/providers/test_provider.dart';
import 'package:instagramer/screens/login_screen.dart';
import 'package:instagramer/screens/homepage.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('-------------User is currently signed out!');
      } else {
        print('-------------User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => userdataprovider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LikeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SaveProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthStateHandler(),
      ),
    );
  }
}

class AuthStateHandler extends StatelessWidget {
  const AuthStateHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // User is logged in
            print(
                '---------------------------------User is logged in: ${snapshot.data?.email}');
            return const Homepage();
          } else if (snapshot.hasError) {
            // Handle Firebase-specific exceptions
            String errorMessage;
            if (snapshot.error is FirebaseAuthException) {
              FirebaseAuthException authException =
                  snapshot.error as FirebaseAuthException;
              errorMessage = _getFirebaseErrorMessage(authException);
            } else {
              errorMessage = 'An unknown error occurred: ${snapshot.error}';
            }

            print(
                '----------------------------------User is logged out: $errorMessage');
            return Center(
              child: Text(errorMessage),
            );
          }
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Default to login screen if no user is logged in and no error occurred
        return const LoginScreen();
      },
    );
  }

  String _getFirebaseErrorMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      default:
        return 'Authentication error: ${exception.message}';
    }
  }
}
