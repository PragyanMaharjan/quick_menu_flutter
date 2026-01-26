import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/splash/presentation/pages/splash_screen.dart';
import '../features/payment/presentation/pages/thank_you_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Quick Scan Menu',
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/thank-you': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            return ThankYouScreen(order: args);
          },
        },
      ),
    );
  }
}
