import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _contentController;
  late AnimationController _pulseController;
  late AnimationController _orbitController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _subtitleFade;
  late Animation<double> _loaderFade;
  late Animation<double> _pulse;
  late Animation<double> _orbit;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _orbit = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _orbitController, curve: Curves.linear));

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _contentController,
            curve: const Interval(0.35, 0.65, curve: Curves.easeOutCubic),
          ),
        );

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.35, 0.65, curve: Curves.easeIn),
      ),
    );

    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: const Interval(0.5, 0.75, curve: Curves.easeOutCubic),
          ),
        );

    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.5, 0.75, curve: Curves.easeIn),
      ),
    );

    _loaderFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    _contentController.forward();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) context.go(RouteNames.home);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _contentController.dispose();
    _pulseController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Animated gradient background ──────────────────────
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) {
              final t = _bgController.value;
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: isDark
                      ? LinearGradient(
                          begin: Alignment(
                            math.cos(t * 2 * math.pi) * 0.5,
                            math.sin(t * 2 * math.pi) * 0.5,
                          ),
                          end: Alignment(
                            -math.cos(t * 2 * math.pi) * 0.5,
                            -math.sin(t * 2 * math.pi) * 0.5,
                          ),
                          colors: const [
                            Color(0xFF0A0A1A),
                            Color(0xFF130A2E),
                            Color(0xFF0D1A3A),
                            Color(0xFF0A0A1A),
                          ],
                        )
                      : LinearGradient(
                          begin: Alignment(
                            math.cos(t * 2 * math.pi) * 0.5,
                            math.sin(t * 2 * math.pi) * 0.5,
                          ),
                          end: Alignment(
                            -math.cos(t * 2 * math.pi) * 0.5,
                            -math.sin(t * 2 * math.pi) * 0.5,
                          ),
                          colors: const [
                            Color(0xFFE8E4FF),
                            Color(0xFFD4EEFF),
                            Color(0xFFEFD4FF),
                            Color(0xFFE8E4FF),
                          ],
                        ),
                ),
              );
            },
          ),

          // ── Floating orbs ──────────────────────────────────────
          AnimatedBuilder(
            animation: _orbit,
            builder: (_, __) {
              return Stack(
                children: [
                  Positioned(
                    left:
                        size.width * 0.5 +
                        math.cos(_orbit.value) * size.width * 0.3 -
                        60,
                    top:
                        size.height * 0.3 +
                        math.sin(_orbit.value) * size.height * 0.15 -
                        60,
                    child: _Orb(
                      size: 120,
                      color: isDark
                          ? const Color(0xFF7C6FF7).withOpacity(0.25)
                          : const Color(0xFF6C63FF).withOpacity(0.15),
                    ),
                  ),
                  Positioned(
                    left:
                        size.width * 0.2 +
                        math.cos(_orbit.value + math.pi) * size.width * 0.15 -
                        40,
                    top:
                        size.height * 0.6 +
                        math.sin(_orbit.value + math.pi) * size.height * 0.1 -
                        40,
                    child: _Orb(
                      size: 80,
                      color: isDark
                          ? const Color(0xFF03DAC6).withOpacity(0.2)
                          : const Color(0xFF03DAC6).withOpacity(0.12),
                    ),
                  ),
                  Positioned(
                    right:
                        size.width * 0.1 +
                        math.cos(_orbit.value + math.pi / 2) * size.width * 0.1,
                    top:
                        size.height * 0.15 +
                        math.sin(_orbit.value + math.pi / 2) *
                            size.height *
                            0.05,
                    child: _Orb(
                      size: 60,
                      color: isDark
                          ? const Color(0xFFFF6B9D).withOpacity(0.2)
                          : const Color(0xFFFF6B9D).withOpacity(0.12),
                    ),
                  ),
                ],
              );
            },
          ),

          // ── Main content ───────────────────────────────────────
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with glass effect
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: AnimatedBuilder(
                        animation: _pulse,
                        builder: (_, child) =>
                            Transform.scale(scale: _pulse.value, child: child),
                        child: _GlassContainer(
                          width: 120,
                          height: 120,
                          borderRadius: 36,
                          isDark: isDark,
                          child: const Text(
                            '🐶',
                            style: TextStyle(fontSize: 56),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Title
                  SlideTransition(
                    position: _titleSlide,
                    child: FadeTransition(
                      opacity: _titleFade,
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: isDark
                              ? const [
                                  Color(0xFFFFFFFF),
                                  Color(0xFFB8B0FF),
                                  Color(0xFF7C6FF7),
                                ]
                              : const [
                                  Color(0xFF2D2B8F),
                                  Color(0xFF6C63FF),
                                  Color(0xFF9B5DE5),
                                ],
                        ).createShader(bounds),
                        child: const Text(
                          'Dog Gallery',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -1,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle chips
                  SlideTransition(
                    position: _subtitleSlide,
                    child: FadeTransition(
                      opacity: _subtitleFade,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          _Chip(label: 'Clean Architecture', isDark: isDark),
                          _Chip(label: 'Riverpod', isDark: isDark),
                          _Chip(label: 'Dio', isDark: isDark),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Loader
                  FadeTransition(
                    opacity: _loaderFade,
                    child: _AnimatedDotLoader(isDark: isDark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────────────────────────

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _GlassContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final bool isDark;
  final Widget child;

  const _GlassContainer({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.isDark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.white.withOpacity(0.6),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.15)
              : Colors.white.withOpacity(0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0xFF7C6FF7).withOpacity(0.3)
                : const Color(0xFF6C63FF).withOpacity(0.2),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isDark;
  const _Chip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark
            ? Colors.white.withOpacity(0.07)
            : Colors.white.withOpacity(0.55),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.12)
              : const Color(0xFF6C63FF).withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark
              ? Colors.white.withOpacity(0.7)
              : const Color(0xFF4A3FBF),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _AnimatedDotLoader extends StatefulWidget {
  final bool isDark;
  const _AnimatedDotLoader({required this.isDark});

  @override
  State<_AnimatedDotLoader> createState() => _AnimatedDotLoaderState();
}

class _AnimatedDotLoaderState extends State<_AnimatedDotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isDark
        ? const Color(0xFF7C6FF7)
        : const Color(0xFF6C63FF);
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final t = (_ctrl.value - delay).clamp(0.0, 1.0);
            final bounce = math.sin(t * math.pi) * 10;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Transform.translate(
                offset: Offset(0, -bounce),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.4 + t * 0.6),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
