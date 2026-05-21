import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/theme_provider.dart';
import '../providers/home_provider.dart';
import '../widgets/post_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0A1A)
          : const Color(0xFFF0F2FF),
      body: Stack(
        children: [
          // Subtle background gradient blobs
          Positioned(
            top: -80,
            right: -60,
            child: _BackgroundBlob(
              size: 280,
              color: isDark
                  ? const Color(0xFF7C6FF7).withOpacity(0.12)
                  : const Color(0xFF6C63FF).withOpacity(0.08),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: _BackgroundBlob(
              size: 240,
              color: isDark
                  ? const Color(0xFF03DAC6).withOpacity(0.08)
                  : const Color(0xFF03DAC6).withOpacity(0.06),
            ),
          ),

          // Main content
          CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // ── Glass AppBar ───────────────────────────────────
              SliverAppBar(
                pinned: true,
                expandedHeight: 120,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                flexibleSpace: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
                      title: Row(
                        children: [
                          const Text('🐶', style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 8),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: isDark
                                  ? const [Color(0xFFFFFFFF), Color(0xFFB8B0FF)]
                                  : const [
                                      Color(0xFF2D2B8F),
                                      Color(0xFF7C6FF7),
                                    ],
                            ).createShader(bounds),
                            child: const Text(
                              'Dog Gallery',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      background: _GlassAppBarBg(isDark: isDark),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4, top: 8),
                    child: _ThemeToggleButton(isDark: isDark),
                  ),
                  if (state.isSuccess || state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(right: 12, top: 8),
                      child: _GlassIconButton(
                        icon: Icons.refresh_rounded,
                        isDark: isDark,
                        onTap: () => ref.read(homeProvider.notifier).refresh(),
                      ),
                    ),
                ],
              ),

              // ── Body ───────────────────────────────────────────
              if (state.isLoading || state.isInitial)
                const SliverFillRemaining(child: _LoadingView())
              else if (state.hasError)
                SliverFillRemaining(
                  child: _ErrorView(
                    message: state.errorMessage ?? 'Something went wrong.',
                    onRetry: () => ref.read(homeProvider.notifier).refresh(),
                    isDark: isDark,
                  ),
                )
              else if (state.isEmpty)
                SliverFillRemaining(child: _EmptyView(isDark: isDark))
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 400 + index * 60),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 30 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: DogImageCard(
                            dog: state.images[index],
                            isDark: isDark,
                          ),
                        ),
                      );
                    }, childCount: state.images.length),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────────────────────────

class _BackgroundBlob extends StatelessWidget {
  final double size;
  final Color color;
  const _BackgroundBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _GlassAppBarBg extends StatelessWidget {
  final bool isDark;
  const _GlassAppBarBg({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF7C6FF7).withOpacity(0.12),
                  const Color(0xFF1A1A3E).withOpacity(0.25),
                  const Color(0xFF03DAC6).withOpacity(0.06),
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.55),
                  const Color(0xFFEEECFF).withOpacity(0.45),
                  Colors.white.withOpacity(0.35),
                ],
              ),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? const Color(0xFF7C6FF7).withOpacity(0.18)
                : Colors.white.withOpacity(0.7),
            width: 0.8,
          ),
        ),
      ),
    );
  }
}

class _ThemeToggleButton extends ConsumerWidget {
  final bool isDark;
  const _ThemeToggleButton({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(themeModeProvider.notifier).state = isDark
            ? ThemeMode.light
            : ThemeMode.dark;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 72,
        height: 36,
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.white.withOpacity(0.55),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.12)
                : Colors.white.withOpacity(0.7),
            width: 0.8,
          ),
        ),
        child: Stack(
          children: [
            // Sliding indicator
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 30,
                height: 28,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  gradient: LinearGradient(
                    colors: isDark
                        ? const [Color(0xFF7C6FF7), Color(0xFF5B4FF0)]
                        : const [Color(0xFFFFD93D), Color(0xFFFF9A3C)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? const Color(0xFF7C6FF7).withOpacity(0.4)
                          : const Color(0xFFFFD93D).withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                      key: ValueKey(isDark),
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Opposite icon (faded)
            Align(
              alignment: isDark ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Icon(
                  isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                  size: 14,
                  color: isDark
                      ? Colors.white.withOpacity(0.25)
                      : Colors.black.withOpacity(0.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;
  const _GlassIconButton({
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.white.withOpacity(0.55),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.12)
                : Colors.white.withOpacity(0.7),
            width: 0.8,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDark
              ? Colors.white.withOpacity(0.8)
              : const Color(0xFF4A3FBF),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: isDark ? const Color(0xFF7C6FF7) : const Color(0xFF6C63FF),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Fetching adorable dogs...',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? Colors.white.withOpacity(0.5)
                  : const Color(0xFF6C63FF).withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool isDark;

  const _ErrorView({
    required this.message,
    required this.onRetry,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: isDark
                    ? Colors.red.withOpacity(0.1)
                    : Colors.red.withOpacity(0.07),
                border: Border.all(
                  color: Colors.red.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: const Center(
                child: Text('😵', style: TextStyle(fontSize: 36)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? Colors.white.withOpacity(0.4)
                    : Colors.black.withOpacity(0.4),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: isDark
                        ? const [Color(0xFF7C6FF7), Color(0xFF5B4FF0)]
                        : const [Color(0xFF6C63FF), Color(0xFF9B5DE5)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Try Again',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final bool isDark;
  const _EmptyView({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🐾', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'No dogs found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down to refresh',
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? Colors.white.withOpacity(0.4)
                  : Colors.black.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}
