import 'package:flutter/material.dart';
import 'package:flutter_icon/flutter_icon.dart';

void main() {
  runApp(const MorphIconDemoApp());
}

class MorphIconDemoApp extends StatelessWidget {
  const MorphIconDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Morph Icon Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
      ),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  bool _isSidebar = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Static reference icons (both states side by side)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    CustomPaint(
                      size: const Size.square(80),
                      painter: StaticIconPainter.sidebar(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sidebar',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(width: 40),
                Column(
                  children: [
                    CustomPaint(
                      size: const Size.square(80),
                      painter: StaticIconPainter.tabBar(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tab Bar',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 48),
            // Animated morph icon (tap to toggle)
            const Text(
              'Tap to morph',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 12),
            MorphSidebarTabBarIcon(
              size: 120,
              color: Colors.white,
              onToggled: (isSidebar) {
                setState(() => _isSidebar = isSidebar);
              },
            ),
            const SizedBox(height: 16),
            Text(
              _isSidebar ? 'Sidebar' : 'Tab Bar',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            // Actual size preview
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomPaint(
                  size: const Size.square(24),
                  painter: StaticIconPainter.sidebar(color: Colors.white70),
                ),
                const SizedBox(width: 12),
                CustomPaint(
                  size: const Size.square(24),
                  painter: StaticIconPainter.tabBar(color: Colors.white70),
                ),
                const SizedBox(width: 12),
                MorphSidebarTabBarIcon(
                  size: 24,
                  color: Colors.white70,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
