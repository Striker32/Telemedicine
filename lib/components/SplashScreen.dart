import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key); // убрал const если нужен

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _radius;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final maxRadius = size.longestSide * 1.2;

      setState(() {
        _radius = Tween<double>(begin: 0, end: maxRadius).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        );
      });

      // ⏱ Задержка перед запуском анимации
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _controller.forward();
        }
      });

      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // тот же цвет, что и в launch_background
      body: Stack(
        children: [
          // анимированная заливка розовым через ClipOval
          AnimatedBuilder(
            animation: _radius,
            builder: (_, __) {
              return ClipOval(
                clipper: _CircleClipper(_radius.value),
                child: Container(color: const Color(0xFFFFECF1)),
              );
            },
          ),

          // Центрированный первый кадр: тот же image что и в launch_background
          Center(
            child: Image.asset(
              'assets/images/app/heartStart.png', // убедись что путь совпадает с pubspec
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
