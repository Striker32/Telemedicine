import 'package:flutter/material.dart';

import '../auth/auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _maxRadius = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      _maxRadius = size.longestSide * 1.2;

      // Запуск анимации с небольшой задержкой
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) _controller.forward();
      });

      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AuthGate()),
          );
        }
      });
      // Нужно вызвать setState, чтобы AnimatedBuilder увидел обновлённый _maxRadius
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              final radius = _controller.value * _maxRadius;
              return ClipOval(
                clipper: _CircleClipper(radius),
                child: Container(color: const Color(0xFFFFECF1)),
              );
            },
          ),
          Center(
            child: Image.asset(
              'assets/images/app/heartStart.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _CircleClipper extends CustomClipper<Rect> {
  final double radius;
  _CircleClipper(this.radius);

  @override
  Rect getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    return Rect.fromCircle(center: center, radius: radius);
  }

  @override
  bool shouldReclip(covariant _CircleClipper oldClipper) =>
      oldClipper.radius != radius;
}
