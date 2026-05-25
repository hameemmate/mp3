// galaxy_widgets.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mp3player/utilities/colors.dart';

/// Animated Galaxy Background with moving stars and nebula
class GalaxyBackground extends StatefulWidget {
  final Widget child;
  const GalaxyBackground({super.key, required this.child});

  @override
  State<GalaxyBackground> createState() => _GalaxyBackgroundState();
}

class _GalaxyBackgroundState extends State<GalaxyBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<_MovingStar> _movingStars;
  late List<_NebulaBlob> _nebulas;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    // Create moving stars with trails
    _movingStars = List.generate(80, (i) {
      return _MovingStar(
        startX: (i * 2654435761 % 1000) / 1000.0,
        startY: ((i * 1234567) % 1000) / 1000.0,
        speed: 0.0005 + (i % 5) * 0.0002,
        size: 1.5 + (i % 3),
        tailLength: 3 + (i % 5),
      );
    });

    // Animated nebulas
    _nebulas = [
      _NebulaBlob(size: 240, color: AppColors.nebulaViolet, speed: 0.5),
      _NebulaBlob(size: 200, color: AppColors.nebulaCyan, speed: 0.3),
      _NebulaBlob(size: 180, color: AppColors.nebulaGreen, speed: 0.7),
      _NebulaBlob(size: 160, color: AppColors.nebulaRose, speed: 0.4),
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Update nebula positions
        for (var nebula in _nebulas) {
          nebula.update(_animationController.value);
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            // Base gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF050010),
                    Color(0xFF0D0025),
                    Color(0xFF00152B)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Animated nebulas
            ..._nebulas.map((nebula) => Positioned(
                  top: nebula.yOffset,
                  left: nebula.xOffset,
                  child: _nebulaBlob(nebula.size, nebula.color),
                )),
            // Shooting stars with trails
            CustomPaint(
              painter: _ShootingStarPainter(
                movingStars: _movingStars,
                animationValue: _animationController.value,
              ),
              size: Size.infinite,
            ),
            // Static stars background
            const _StarField(),
            // Content with glass effect overlay
            child!,
          ],
        );
      },
      child: widget.child,
    );
  }

  Widget _nebulaBlob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0.3, 1.0],
        ),
      ),
    );
  }
}

class _NebulaBlob {
  final double size;
  final Color color;
  final double speed;
  double xOffset;
  double yOffset;

  _NebulaBlob({
    required this.size,
    required this.color,
    required this.speed,
  })  : xOffset = (size * 2654435761 % 800) - 400,
        yOffset = ((size * 2654435761 * 1234567) % 800) - 300;

  void update(double animationValue) {
    xOffset = (xOffset + speed * 0.5) % 800 - 400;
    yOffset = (yOffset + speed * 0.3) % 800 - 400;
  }
}

class _MovingStar {
  double startX, startY;
  final double speed;
  final double size;
  final int tailLength;

  _MovingStar({
    required this.startX,
    required this.startY,
    required this.speed,
    required this.size,
    required this.tailLength,
  });
}

class _ShootingStarPainter extends CustomPainter {
  final List<_MovingStar> movingStars;
  final double animationValue;

  _ShootingStarPainter(
      {required this.movingStars, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (var star in movingStars) {
      final progress = (animationValue * star.speed * 100) % 1.0;
      final currentX = (star.startX + progress) % 1.0;
      final currentY = (star.startY + progress * 0.3) % 1.0;

      final x = currentX * size.width;
      final y = currentY * size.height;

      // Draw trail stars
      for (int i = 1; i <= star.tailLength; i++) {
        final trailProgress = (progress - i * 0.02) % 1.0;
        if (trailProgress > 0) {
          final trailX = (star.startX + trailProgress) % 1.0 * size.width;
          final trailY =
              (star.startY + trailProgress * 0.3) % 1.0 * size.height;
          final opacity = (1 - i / star.tailLength) * 0.3;

          final paint = Paint()
            ..color = Colors.white.withOpacity(opacity)
            ..style = PaintingStyle.fill;
          canvas.drawCircle(Offset(trailX, trailY), star.size * 0.5, paint);
        }
      }

      // Draw main star
      final mainPaint = Paint()
        ..color = Colors.white.withOpacity(0.8 + (progress * 0.2))
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), star.size, mainPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _StarField extends StatelessWidget {
  const _StarField();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _StarPainter());
  }
}

class _StarPainter extends CustomPainter {
  static final List<_Star> _stars = List.generate(200, (i) {
    final rand = i * 2654435761 % 1000;
    return _Star(
      x: (rand % 1000) / 1000.0,
      y: ((rand * 1234567) % 1000) / 1000.0,
      r: (rand % 5 + 1) / 3.0,
      opacity: (rand % 7 + 3) / 10.0,
      twinkleSpeed: 0.5 + (i % 10) * 0.1,
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in _stars) {
      final twinkle =
          (DateTime.now().millisecondsSinceEpoch / 1000 * s.twinkleSpeed) % 1.0;
      final opacity = s.opacity * (0.5 + twinkle * 0.5);

      final paint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height),
        s.r,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

class _Star {
  final double x, y, r, opacity, twinkleSpeed;
  const _Star({
    required this.x,
    required this.y,
    required this.r,
    required this.opacity,
    required this.twinkleSpeed,
  });
}

/// Frosted liquid-glass card (unchanged)
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
