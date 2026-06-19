import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_settings.dart';
import 'package:flutter_application_1/reset_password_page.dart';
import 'package:flutter_application_1/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState>
navigatorKey =
GlobalKey<NavigatorState>();

void main() async {

  WidgetsFlutterBinding
      .ensureInitialized();

  await Supabase.initialize(

    url:
    'https://fcucmgebocwctdxuyelp.supabase.co',

    anonKey:
    'sb_publishable_8czysszYrMgRcfaJnBljhw_ZAmhi_E5',
  );

  
  /// pass recovery 
  

  Supabase.instance.client.auth
      .onAuthStateChange
      .listen((data) {

    final event =
    data.event;

    if (event ==
        AuthChangeEvent
            .passwordRecovery) {

      navigatorKey.currentState
          ?.push(

        MaterialPageRoute(

          builder: (context) =>

          const ResetPasswordPage(),
        ),
      );
    }
  });

  runApp(

    ChangeNotifierProvider(

      create: (_) =>
      AppSettings(),

      child:
      const MyApp(),
    ),
  );
}

class MyApp
    extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(
      BuildContext context) {

    final settings =
    Provider.of<AppSettings>(
        context);

    return MaterialApp(

      navigatorKey:
      navigatorKey,

      debugShowCheckedModeBanner:
      false,

      
      /// global theme er
      

      theme: ThemeData(

        brightness:

        settings.isDark

            ? Brightness.dark

            : Brightness.light,

        primarySwatch:
        Colors.deepPurple,
      ),

      

      home:
      SplashScreen(),
    );
  }
}