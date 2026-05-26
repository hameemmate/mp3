// galaxy_widgets.dart - Update to use theme colors
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/utilities/colors.dart';
import 'package:mp3player/utilities/theme_controller.dart';

/// Drop-in — wrap any screen
class GalaxyBackground extends StatelessWidget {
  final Widget child;
  const GalaxyBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();

    return Obx(() => Stack(
          fit: StackFit.expand,
          children: [
            // Dynamic background based on theme
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.current.background,
                    theme.current.surface,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            const _StarField(),
            _AuroraLayer(theme: theme.current),
            _WaveformLayer(theme: theme.current),
            child,
          ],
        ));
  }
}

// Update AuroraLayer to accept theme
class _AuroraLayer extends StatefulWidget {
  final AppTheme theme;
  const _AuroraLayer({required this.theme});

  @override
  State<_AuroraLayer> createState() => _AuroraLayerState();
}

class _AuroraLayerState extends State<_AuroraLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 9))
          ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => CustomPaint(
            painter: _AuroraPainter(_ctrl.value, widget.theme),
            size: Size.infinite),
      );
}

class _AuroraPainter extends CustomPainter {
  final double t;
  final AppTheme theme;

  _AuroraPainter(this.t, this.theme);

  @override
  void paint(Canvas canvas, Size size) {
    final ribbons = theme.auroraRibbons;

    // Use theme's ribbon colors
    if (ribbons.isNotEmpty) {
      _ribbon(canvas, size,
          phase: t * 2 * pi,
          yBase: size.height * 0.18,
          amplitude: size.height * 0.07,
          ribbonH: size.height * 0.13,
          color1: ribbons[0][0],
          color2: ribbons[0][1],
          opacity: 0.30,
          blur: 22);
    }
    if (ribbons.length > 1) {
      _ribbon(canvas, size,
          phase: t * 2 * pi + 1.6,
          yBase: size.height * 0.10,
          amplitude: size.height * 0.05,
          ribbonH: size.height * 0.10,
          color1: ribbons[1][0],
          color2: ribbons[1][1],
          opacity: 0.24,
          blur: 18);
    }
    if (ribbons.length > 2) {
      _ribbon(canvas, size,
          phase: t * 2 * pi + 3.2,
          yBase: size.height * 0.28,
          amplitude: size.height * 0.06,
          ribbonH: size.height * 0.11,
          color1: ribbons[2][0],
          color2: ribbons[2][1],
          opacity: 0.20,
          blur: 20);
    }
    if (ribbons.length > 3) {
      _ribbon(canvas, size,
          phase: t * 2 * pi + 4.8,
          yBase: size.height * 0.06,
          amplitude: size.height * 0.04,
          ribbonH: size.height * 0.08,
          color1: ribbons[3][0],
          color2: ribbons[3][1],
          opacity: 0.16,
          blur: 16);
    }
    if (ribbons.length > 4) {
      _ribbon(canvas, size,
          phase: t * 2 * pi + 0.9,
          yBase: size.height * 0.35,
          amplitude: size.height * 0.05,
          ribbonH: size.height * 0.09,
          color1: ribbons[4][0],
          color2: ribbons[4][1],
          opacity: 0.14,
          blur: 14);
    }
  }

  void _ribbon(
    Canvas canvas,
    Size size, {
    required double phase,
    required double yBase,
    required double amplitude,
    required double ribbonH,
    required Color color1,
    required Color color2,
    required double opacity,
    required double blur,
  }) {
    const steps = 100;
    final path = Path();
    for (int i = 0; i <= steps; i++) {
      final x = size.width * i / steps;
      final y = yBase +
          amplitude * sin(phase + i * 0.09) +
          amplitude * 0.35 * sin(phase * 1.5 + i * 0.15);
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    for (int i = steps; i >= 0; i--) {
      final x = size.width * i / steps;
      final y = yBase +
          amplitude * sin(phase + i * 0.09) +
          amplitude * 0.35 * sin(phase * 1.5 + i * 0.15) +
          ribbonH;
      path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            colors: [
              color1.withOpacity(0),
              color1.withOpacity(opacity),
              color2.withOpacity(opacity * 0.85),
              color2.withOpacity(0)
            ],
            stops: const [0.0, 0.2, 0.8, 1.0],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.5))
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur));
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter old) =>
      old.t != t || old.theme != theme;
}

// Update WaveformLayer to accept theme
class _WaveformLayer extends StatefulWidget {
  final AppTheme theme;
  const _WaveformLayer({required this.theme});

  @override
  State<_WaveformLayer> createState() => _WaveformLayerState();
}

class _WaveformLayerState extends State<_WaveformLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => CustomPaint(
            painter: _WaveformPainter(_ctrl.value, widget.theme),
            size: Size.infinite),
      );
}

class _WaveformPainter extends CustomPainter {
  final double t;
  final AppTheme theme;

  _WaveformPainter(this.t, this.theme);

  @override
  void paint(Canvas canvas, Size size) {
    final baseY = size.height * 0.78;

    // Filled glow under main wave
    _drawFill(canvas, size, baseY,
        phase: t * 2 * pi, amplitude: size.height * 0.04, color: theme.primary);
    _drawFill(canvas, size, baseY + size.height * 0.012,
        phase: t * 2 * pi * 1.3 + 1.0,
        amplitude: size.height * 0.03,
        color: theme.aurora1);

    // Wave lines
    _drawWave(canvas, size, baseY,
        phase: t * 2 * pi,
        amplitude: size.height * 0.04,
        color: theme.primary,
        opacity: 0.45,
        strokeW: 2.0);
    _drawWave(canvas, size, baseY + size.height * 0.015,
        phase: t * 2 * pi * 1.4 + 1.0,
        amplitude: size.height * 0.03,
        color: theme.aurora1,
        opacity: 0.30,
        strokeW: 1.5);
    _drawWave(canvas, size, baseY - size.height * 0.015,
        phase: t * 2 * pi * 0.7 + 2.5,
        amplitude: size.height * 0.025,
        color: theme.aurora2,
        opacity: 0.25,
        strokeW: 1.5);
    _drawWave(canvas, size, baseY + size.height * 0.03,
        phase: t * 2 * pi * 1.1 + 3.8,
        amplitude: size.height * 0.02,
        color: theme.aurora3,
        opacity: 0.18,
        strokeW: 1.2);
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    double baseY, {
    required double phase,
    required double amplitude,
    required Color color,
    required double opacity,
    required double strokeW,
  }) {
    final path = Path();
    const steps = 120;
    for (int i = 0; i <= steps; i++) {
      final x = size.width * i / steps;
      final y = baseY +
          amplitude * sin(phase + i * 0.12) +
          amplitude * 0.4 * sin(phase * 2 + i * 0.2);
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    canvas.drawPath(
        path,
        Paint()
          ..color = color.withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeW
          ..strokeCap = StrokeCap.round);
  }

  void _drawFill(
    Canvas canvas,
    Size size,
    double baseY, {
    required double phase,
    required double amplitude,
    required Color color,
  }) {
    final path = Path();
    const steps = 120;
    path.moveTo(0, size.height);
    for (int i = 0; i <= steps; i++) {
      final x = size.width * i / steps;
      final y = baseY +
          amplitude * sin(phase + i * 0.12) +
          amplitude * 0.4 * sin(phase * 2 + i * 0.2);
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            colors: [color.withOpacity(0.14), color.withOpacity(0.0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
              Rect.fromLTWH(0, baseY, size.width, size.height - baseY)));
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter old) =>
      old.t != t || old.theme != theme;
}

// Star field remains the same
class _StarField extends StatelessWidget {
  const _StarField();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _StarPainter());
}

class _StarPainter extends CustomPainter {
  static final _stars = List.generate(160, (i) {
    final r = (i * 2654435761 + 1234567) % 100000;
    return _S(
        x: (r % 1000) / 1000.0,
        y: ((r * 999983) % 1000) / 1000.0,
        radius: (r % 5 + 2) / 5.5,
        opacity: (r % 6 + 2) / 14.0);
  });
  @override
  void paint(Canvas canvas, Size size) {
    for (final s in _stars) {
      canvas.drawCircle(Offset(s.x * size.width, s.y * size.height), s.radius,
          Paint()..color = Colors.white.withOpacity(s.opacity));
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _S {
  final double x, y, radius, opacity;
  const _S(
      {required this.x,
      required this.y,
      required this.radius,
      required this.opacity});
}

// GlassCard helper - unchanged but uses AppColors which now gets from theme
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final double blurSigma;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding = const EdgeInsets.all(16),
    this.gradient,
    this.blurSigma = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            color: gradient == null ? AppColors.glassLight : null,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
