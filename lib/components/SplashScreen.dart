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
      duration: const Duration(milliseconds: 5000),
    );

    _radius = Tween<double>(begin: 0, end: 5000).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Запускаем анимацию только после отрисовки первого кадра Flutter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 5000), () {
        if (mounted) _controller.forward();
      });
    });

    // Навигация на основной экран после завершения анимации
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) Navigator.pushReplacementNamed(context, '/main');
      }
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
              width: 110,
              height: 110,
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
