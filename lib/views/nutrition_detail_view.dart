import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Color tokens matching the 'Vitality Tech' theme color palette.
class VitalityTechColors {
  static const Color primary = Color(0xFF006E2F);
  static const Color primaryContainer = Color(0xFF22C55E);
  static const Color secondary = Color(0xFF9D4300);
  static const Color secondaryContainer = Color(0xFFFD761A);
  static const Color secondaryFixed = Color(0xFFFFDBCA);
  static const Color onSecondaryFixed = Color(0xFF341100);
  static const Color tertiary = Color(0xFF006591);
  static const Color tertiaryContainer = Color(0xFF36B6FB);
  static const Color background = Color(0xFFF8F9FF);
  static const Color onBackground = Color(0xFF0B1C30);
  static const Color surface = Color(0xFFF8F9FF);
  static const Color onSurface = Color(0xFF0B1C30);
  static const Color onSurfaceVariant = Color(0xFF3D4A3D);
  static const Color outline = Color(0xFF6D7B6C);
  static const Color outlineVariant = Color(0xFFBCCBB9);
  static const Color surfaceContainerLow = Color(0xFFEFF4FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerHighest = Color(0xFFD3E4FE);
  static const Color surfaceDim = Color(0xFFCBDBF5);
}

/// Typography tokens matching the 'Vitality Tech' design specifications.
class VitalityTechTypography {
  static const TextStyle displayLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 48,
    fontWeight: FontWeight.bold,
    height: 56 / 48,
    letterSpacing: -0.96, // -0.02em
    color: VitalityTechColors.onSurface,
  );

  static const TextStyle headlineLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24, // Mobile scale
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: -0.24, // -0.01em
    color: VitalityTechColors.onSurface,
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    color: VitalityTechColors.onSurface,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.normal,
    height: 28 / 18,
    color: VitalityTechColors.onSurface,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 24 / 16,
    color: VitalityTechColors.onSurface,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.14, // 0.01em
    color: VitalityTechColors.onSurfaceVariant,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.6, // 0.05em
    color: VitalityTechColors.onSurfaceVariant,
  );
}

/// A responsive, visually premium placeholder screen for Nutrition Details.
///
/// Designed based on the 'NutriScan AI Assistant' text-to-UI specification under the
/// 'Vitality Tech' theme colors and spacing system.

// route
class NutritionDetailView extends StatefulWidget {
  const NutritionDetailView({super.key});

  @override
  State<NutritionDetailView> createState() => _NutritionDetailViewState();
}

class _NutritionDetailViewState extends State<NutritionDetailView> {
  bool _showTooltip = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VitalityTechColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Container(
          decoration: BoxDecoration(
            color: VitalityTechColors.surface.withValues(alpha: 0.85),
            border: const Border(
              bottom: BorderSide(
                color: Color(0x1F6D7B6C), // subtle outline
                width: 1.0,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Avatar Container
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: VitalityTechColors.surfaceContainerHighest,
                          border: Border.all(
                            color: VitalityTechColors.outlineVariant.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          size: 18,
                          color: VitalityTechColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'NutriScan AI',
                        style: VitalityTechTypography.headlineMd.copyWith(
                          color: VitalityTechColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    color: VitalityTechColors.primary,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    
                    // 1. Food Image Placeholder Section
                    _buildImagePlaceholder(),
                    
                    const SizedBox(height: 40.0),
                    
                    // 2. Main Calorie Display (Circular Gauge)
                    Center(child: _buildCalorieGauge()),
                    
                    const SizedBox(height: 40.0),
                    
                    // 3. Macro Breakdown Cards
                    _buildMacroBreakdown(),
                    
                    const SizedBox(height: 40.0),
                    
                    // 4. Nutrition Facts Card List
                    _buildNutritionFactsCard(),
                    
                    const SizedBox(height: 120.0), // Extra spacer for FAB overlap & Bottom Navigation
                  ],
                ),
              ),
            ),
            
            // 5. Instruction Tooltip & FAB Layout (Positioned in Stack overlay)
            if (_showTooltip) _buildTooltipOverlay(),
          ],
        ),
      ),
      // Muted Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavigationBar(),
      // Standard FAB on bottom right
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showTooltip = !_showTooltip;
          });
        },
        backgroundColor: VitalityTechColors.primary,
        foregroundColor: Colors.white,
        elevation: 4.0,
        shape: const CircleBorder(),
        child: const Icon(Icons.lightbulb_outline),
      ),
    );
  }

  /// Builds a premium, greyed-out food image placeholder representing an empty scan state.
  Widget _buildImagePlaceholder() {
    return Container(
      height: 256.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: VitalityTechColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: VitalityTechColors.outlineVariant.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background subtle pattern or design decoration
          Positioned.fill(
            child: GridPaper(
              color: VitalityTechColors.outlineVariant.withValues(alpha: 0.04),
              divisions: 2,
              subdivisions: 1,
              interval: 40.0,
              child: const SizedBox(),
            ),
          ),
          
          // Muted Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),
          
          // Icon and helper message indicating the state
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.restaurant_menu_outlined,
                    size: 48,
                    color: VitalityTechColors.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'No Scan Selected',
                  style: VitalityTechTypography.bodyMd.copyWith(
                    fontWeight: FontWeight.w600,
                    color: VitalityTechColors.onSurfaceVariant.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Please scan a food item to view nutrition analysis.',
                  style: VitalityTechTypography.labelSm.copyWith(
                    color: VitalityTechColors.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Bottom content placeholder (overlay on black gradient)
          Positioned(
            bottom: 24.0,
            left: 24.0,
            right: 24.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Waiting for Scan...',
                  style: VitalityTechTypography.headlineLg.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Ready to analyze nutrition values',
                  style: VitalityTechTypography.labelMd.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the 0% progress circular calorie gauge.
  Widget _buildCalorieGauge() {
    return Container(
      width: 192,
      height: 192,
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular progress ring using a custom painter
          Positioned.fill(
            child: CustomPaint(
              painter: _CalorieRingPainter(
                progress: 0.0, // Strict requirement: zero progress
                trackColor: VitalityTechColors.surfaceContainerLow,
                progressColor: VitalityTechColors.primary,
              ),
            ),
          ),
          // Inner value details
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '0',
                style: VitalityTechTypography.displayLg.copyWith(
                  fontWeight: FontWeight.bold,
                  color: VitalityTechColors.onSurface,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                'Kcal',
                style: VitalityTechTypography.labelMd.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: VitalityTechColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the row of 3 macro cards (Protein, Carbs, Fats) with 0 values and zero fill.
  Widget _buildMacroBreakdown() {
    return Row(
      children: [
        Expanded(
          child: _buildMacroCard(
            title: 'PROTEIN',
            value: '0g',
            percentage: '0%',
            progress: 0.0,
            activeColor: VitalityTechColors.tertiary,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: _buildMacroCard(
            title: 'CARBS',
            value: '0g',
            percentage: '0%',
            progress: 0.0,
            activeColor: VitalityTechColors.secondary,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: _buildMacroCard(
            title: 'FATS',
            value: '0g',
            percentage: '0%',
            progress: 0.0,
            activeColor: VitalityTechColors.primary,
          ),
        ),
      ],
    );
  }

  /// Card widget helper for macros.
  Widget _buildMacroCard({
    required String title,
    required String value,
    required String percentage,
    required double progress,
    required Color activeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: VitalityTechColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: VitalityTechColors.outlineVariant.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: VitalityTechTypography.labelSm.copyWith(
              color: activeColor,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            value,
            style: VitalityTechTypography.headlineMd.copyWith(
              color: VitalityTechColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          // Micro progress bar
          Container(
            height: 4.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: VitalityTechColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            percentage,
            style: VitalityTechTypography.labelSm.copyWith(
              color: VitalityTechColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Nutrition facts card with zero value details.
  Widget _buildNutritionFactsCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: VitalityTechColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: VitalityTechColors.outlineVariant.withValues(alpha: 0.3),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: VitalityTechColors.primary.withValues(alpha: 0.02),
            blurRadius: 16.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Nutrition Facts',
                style: VitalityTechTypography.headlineMd.copyWith(
                  fontWeight: FontWeight.bold,
                  color: VitalityTechColors.onSurface,
                ),
              ),
              Text(
                'Serving: 0g',
                style: VitalityTechTypography.labelMd.copyWith(
                  color: VitalityTechColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          // Bold black divider line
          Container(
            height: 3.0,
            color: VitalityTechColors.onSurface,
          ),
          const SizedBox(height: 8.0),
          
          // Rows of values
          _buildNutritionFactRow(name: 'Saturated Fat', weightVal: '0g', percentVal: '0%'),
          _buildNutritionFactRow(name: 'Cholesterol', weightVal: '0mg', percentVal: '0%'),
          _buildNutritionFactRow(name: 'Sodium', weightVal: '0mg', percentVal: '0%'),
          _buildNutritionFactRow(name: 'Dietary Fiber', weightVal: '0g', percentVal: '0%'),
          
          // Last row (Vitamin D) without border
          _buildNutritionFactRow(name: 'Vitamin D', weightVal: '', percentVal: '0%', hideBorder: true),
        ],
      ),
    );
  }

  /// Fact row helper.
  Widget _buildNutritionFactRow({
    required String name,
    required String weightVal,
    required String percentVal,
    bool hideBorder = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: hideBorder
          ? null
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: VitalityTechColors.outlineVariant.withValues(alpha: 0.2),
                  width: 1.0,
                ),
              ),
            ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: VitalityTechTypography.bodyMd.copyWith(
                color: VitalityTechColors.onSurfaceVariant,
              ),
              children: [
                TextSpan(text: '$name  '),
                TextSpan(
                  text: weightVal,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: VitalityTechColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Text(
            percentVal,
            style: VitalityTechTypography.bodyMd.copyWith(
              fontWeight: FontWeight.bold,
              color: VitalityTechColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  /// Instruction Tooltip overlay
  Widget _buildTooltipOverlay() {
    return Positioned(
      bottom: 80.0,
      right: 20.0,
      left: 20.0,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 240),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: VitalityTechColors.secondaryFixed,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: VitalityTechColors.secondary.withValues(alpha: 0.2),
              width: 1.0,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8.0,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Text(
                  'Geser kiri untuk scan dan\nGeser kanan untuk opsi AI',
                  style: VitalityTechTypography.labelMd.copyWith(
                    color: VitalityTechColors.onSecondaryFixed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Positioned(
                top: -4.0,
                right: -4.0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showTooltip = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: const BoxDecoration(
                      color: VitalityTechColors.surfaceDim,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: VitalityTechColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Premium, glass-like bottom navigation bar.
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: VitalityTechColors.surface.withValues(alpha: 0.85),
        border: const Border(
          top: BorderSide(
            color: Color(0x1F6D7B6C), // subtle outline
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Camera button
              _buildBottomNavItem(
                icon: Icons.photo_camera_outlined,
                label: 'Camera',
                isActive: false,
                onTap: () => Navigator.pushNamed(context, '/scan'),
              ),
              // 2. Stats button (Active)
              _buildBottomNavItem(
                icon: Icons.insights,
                label: 'Stats',
                isActive: true,
                onTap: () {},
              ),
              // 3. AI Hub button
              _buildBottomNavItem(
                icon: Icons.smart_toy_outlined,
                label: 'AI Hub',
                isActive: false,
                onTap: () => Navigator.pushNamed(context, '/'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final Color itemColor =
        isActive ? VitalityTechColors.primary : VitalityTechColors.onSurfaceVariant;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (isActive)
                  Container(
                    width: 44,
                    height: 24,
                    decoration: BoxDecoration(
                      color: VitalityTechColors.primaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                Icon(
                  icon,
                  color: itemColor,
                  size: 24.0,
                ),
              ],
            ),
            const SizedBox(height: 2.0),
            Text(
              label,
              style: VitalityTechTypography.labelSm.copyWith(
                color: itemColor,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter to paint a responsive calorie progress gauge ring.
class _CalorieRingPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color trackColor;
  final Color progressColor;

  _CalorieRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 8.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track Painter
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // Active progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CalorieRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor;
  }
}
