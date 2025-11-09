///   ИСПОЛЬЗОВАНИЕ
///
///   return Scaffold(
///     backgroundColor: AppColors.background2,
///     body: const PulseLoadingWidget(),
///   );



import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PulseLoadingWidget extends StatefulWidget {
  const PulseLoadingWidget({Key? key}) : super(key: key);

  @override
  State<PulseLoadingWidget> createState() => _PulseLoadingWidgetState();
}

class _PulseLoadingWidgetState extends State<PulseLoadingWidget> with TickerProviderStateMixin {
  // asset + размеры + параметры
  static const String _assetPath = 'assets/images/icons/heart.svg';
  static const double _baseWidth = 68.0;
  static const double _baseHeight = 62.0;
  static const double _maxScale = 1.5;

  // длительности
  static const Duration _pulseDuration = Duration(milliseconds: 1200);
  static const Duration _fadeDuration = Duration(milliseconds: 200);
  static const Duration _minVisibleDuration = Duration(milliseconds: 2000);

  late final AnimationController _pulseCtrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _opacityPulseAnim;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  // Маркер для гарантированного минимума показа
  late final DateTime _shownAt;
  bool _pulseStarted = false;

  @override
  void initState() {
    super.initState();

    _shownAt = DateTime.now();

    // контроллер для пульсации (scale + лёгкая opacity вариация)
    _pulseCtrl = AnimationController(vsync: this, duration: _pulseDuration);
    final curved = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);
    _scaleAnim = Tween<double>(begin: 1.0, end: _maxScale).animate(curved);
    _opacityPulseAnim = Tween<double>(begin: 0.88, end: 1.0).animate(curved);

    // контроллер для fade in/out
    _fadeCtrl = AnimationController(vsync: this, duration: _fadeDuration);
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);

    // Сначала плавно появляемся
    _fadeCtrl.forward();

    // Ждём минимальное время, затем запускаем пульсацию (и делаем repeat)
    Future.delayed(_minVisibleDuration, () {
      if (!mounted) return;
      _startPulse();
    });
  }

  void _startPulse() {
    if (_pulseStarted) return;
    _pulseStarted = true;
    _pulseCtrl.repeat(reverse: true);
  }

  // Попытка плавного скрытия при dispose (не гарантируется, но даёт шанс)
  Future<void> _tryFadeOut() async {
    try {
      // если ещё не прошёл минимум, дождёмся
      final elapsed = DateTime.now().difference(_shownAt);
      final remaining = _minVisibleDuration - elapsed;
      if (remaining > Duration.zero) {
        await Future.delayed(remaining);
      }
      if (!mounted) return;
      await _fadeCtrl.reverse();
    } catch (_) {
      // ignore
    }
  }

  @override
  void dispose() {
    // Попытаться выполнить fade-out синхронно (не гарантированно, но даёт эффект в некоторых случаях)
    // Мы не ждём его окончания в dispose, просто запустим (последующий cleanup всё равно выполнится).
    _tryFadeOut();
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final svg = SvgPicture.asset(
      _assetPath,
      width: _baseWidth,
      height: _baseHeight,
    );

    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseCtrl, _fadeCtrl]),
        builder: (context, child) {
          // комбинируем общий opacity: fade * pulseOpacity
          final double overallOpacity = _fadeAnim.value * (_opacityPulseAnim.value);
          final double scale = _scaleAnim.value;
          return Opacity(
            opacity: overallOpacity.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: scale,
              child: SizedBox(width: _baseWidth, height: _baseHeight, child: child),
            ),
          );
        },
        child: svg,
      ),
    );
  }
}
