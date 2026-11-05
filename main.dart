import 'package:flutter/material.dart';
import 'services/notification_service.dart';
import 'screens/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.initialize();
  runApp(const LordsAssistantApp());
}

class LordsAssistantApp extends StatelessWidget {
  const LordsAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF101722);
    return MaterialApp(
      title: 'Lords Mobile Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: navy,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B8CCB),
          brightness: Brightness.dark,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1A2635),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
