import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/di/injection.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';

/// Main entry point of the Groshly Customer App
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (for production)
  if (!AppConstants.useMockData) {
    await Firebase.initializeApp();
  }
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Configure dependency injection
  await configureDependencies();
  
  runApp(
    const ProviderScope(
      child: GroshlyApp(),
    ),
  );
}

/// Root widget of the Groshly Customer App
class GroshlyApp extends ConsumerWidget {
  const GroshlyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      // Router configuration
      routerConfig: router,
      
      // Localization (for future use)
      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: [
      //   const Locale('en', 'US'),
      //   const Locale('hi', 'IN'),
      // ],
    );
  }
}
