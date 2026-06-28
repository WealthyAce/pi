import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Data Models
// ---------------------------------------------------------------------------

/// Represents an individual ingredient with name and price.
class IngredientItem {
  final String name;
  final String price;

  const IngredientItem({required this.name, required this.price});
}

/// Data model shell for the Healthy Homemade Recipe screen.
///
/// Encapsulates all fields necessary to render a complete recipe detail page.
/// Can be populated from an API response or instantiated with muted defaults.
class HomemadeRecipeModel {
  final String foodName;
  final String? imageUrl;
  final String nutritionalInsight;
  final double fiberRetention; // 0.0 to 1.0
  final double glycemicImpact; // 0.0 to 1.0
  final String aiProTip;
  final List<IngredientItem> ingredients;
  final List<String> preparationSteps;

  const HomemadeRecipeModel({
    required this.foodName,
    this.imageUrl,
    required this.nutritionalInsight,
    required this.fiberRetention,
    required this.glycemicImpact,
    required this.aiProTip,
    required this.ingredients,
    required this.preparationSteps,
  });

  /// A muted/placeholder default instance with zero or blank values.
  static HomemadeRecipeModel placeholder() {
    return const HomemadeRecipeModel(
      foodName: 'Healthy Recipe Alternative',
      imageUrl: null,
      nutritionalInsight:
          'Nutritional insight will appear here once a recipe is loaded.',
      fiberRetention: 0.0,
      glycemicImpact: 0.0,
      aiProTip: 'AI-powered tips will appear here.',
      ingredients: [
        IngredientItem(name: 'Ingredient name', price: '\$0.00'),
        IngredientItem(name: 'Ingredient name', price: '\$0.00'),
      ],
      preparationSteps: [
        'Preparation step will appear here.',
        'Preparation step will appear here.',
        'Preparation step will appear here.',
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Vitality Tech Design Tokens
// ---------------------------------------------------------------------------

/// Color tokens matching the 'Vitality Tech' theme color palette.
class _Colors {
  static const Color primary = Color(0xFF006E2F);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF22C55E);
  static const Color onPrimaryContainer = Color(0xFF004B1E);
  static const Color secondary = Color(0xFF9D4300);
  static const Color background = Color(0xFFF8F9FF);
  static const Color onBackground = Color(0xFF0B1C30);
  static const Color surface = Color(0xFFF8F9FF);
  static const Color onSurface = Color(0xFF0B1C30);
  static const Color onSurfaceVariant = Color(0xFF3D4A3D);
  static const Color outlineVariant = Color(0xFFBCCBB9);
  static const Color surfaceContainerLow = Color(0xFFEFF4FF);
  static const Color surfaceContainerHigh = Color(0xFFDCE9FF);
  static const Color surfaceContainerHighest = Color(0xFFD3E4FE);
}

/// Typography tokens matching the 'Vitality Tech' design specifications.
class _Typo {
  static const TextStyle headlineLgMobile = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: -0.24,
    color: _Colors.onSurface,
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    color: _Colors.onSurface,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 24 / 16,
    color: _Colors.onSurface,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.14,
    color: _Colors.onSurfaceVariant,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.6,
    color: _Colors.onSurfaceVariant,
  );
}

// ---------------------------------------------------------------------------
// Main Screen Widget
// ---------------------------------------------------------------------------

/// A fully responsive Healthy Homemade Food Detail screen.
///
/// Renders a placeholder/muted version of the design by default.
/// Supply a [HomemadeRecipeModel] to populate with real data.
class HomemadeFoodView extends StatelessWidget {
  /// The recipe model to display. Falls back to [HomemadeRecipeModel.placeholder].
  final HomemadeRecipeModel? recipe;

  // route
  const HomemadeFoodView({super.key, this.recipe});

  @override
  Widget build(BuildContext context) {
    final data = recipe ?? HomemadeRecipeModel.placeholder();

    return Scaffold(
      backgroundColor: _Colors.background,
      body: Stack(
        children: [
          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 56.0), // Room for AppBar
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Title
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 16.0,
                          ),
                          child: Text(
                            'Homemade Healthy Version',
                            style: _Typo.headlineLgMobile.copyWith(
                              color: _Colors.onBackground,
                            ),
                          ),
                        ),

                        // Hero Image Placeholder
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: _HeroImagePlaceholder(foodName: data.foodName),
                        ),

                        const SizedBox(height: 24.0),

                        // Nutritional Insight Card
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: _NutritionalInsightCard(
                            insight: data.nutritionalInsight,
                            fiberRetention: data.fiberRetention,
                            glycemicImpact: data.glycemicImpact,
                          ),
                        ),

                        const SizedBox(height: 16.0),

                        // AI Pro Tip Card
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: _AiProTipCard(tip: data.aiProTip),
                        ),

                        const SizedBox(height: 24.0),

                        // Budget-Friendly Recipe Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: _RecipeSection(
                            ingredients: data.ingredients,
                            steps: data.preparationSteps,
                          ),
                        ),

                        const SizedBox(height: 100.0), // Padding for bottom nav
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // Glassmorphic Top App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _GlassAppBar(),
          ),
        ],
      ),
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

// ---------------------------------------------------------------------------
// App Bar
// ---------------------------------------------------------------------------

class _GlassAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _Colors.surface.withValues(alpha: 0.7),
        border: const Border(
          bottom: BorderSide(
            color: Color(0x4DBCCBB9), // outlineVariant/30
            width: 1.0,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: SafeArea(
            bottom: false,
            child: Container(
              height: 56.0,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  // Back button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pushReplacementNamed('/');
                        }
                      },
                      borderRadius: BorderRadius.circular(20.0),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.arrow_back,
                          color: _Colors.primary,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Title
                  Text(
                    'Homemade Food Version',
                    style: _Typo.headlineMd.copyWith(
                      color: _Colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Avatar
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _Colors.surfaceContainerHighest,
                      border: Border.all(
                        color: _Colors.primary.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: 18,
                      color: _Colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero Image Placeholder
// ---------------------------------------------------------------------------

class _HeroImagePlaceholder extends StatelessWidget {
  final String foodName;
  const _HeroImagePlaceholder({required this.foodName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _Colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: const Color(0xFFE2E8F0), // Design spec: glass-card border
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: _Colors.primaryContainer.withValues(alpha: 0.08),
            blurRadius: 30.0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Subtle grid background
          Positioned.fill(
            child: GridPaper(
              color: _Colors.outlineVariant.withValues(alpha: 0.05),
              divisions: 2,
              subdivisions: 1,
              interval: 48.0,
              child: const SizedBox(),
            ),
          ),

          // Gradient overlay (matching design: from-black/60 to transparent)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.08),
                    Colors.black.withValues(alpha: 0.5),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Central placeholder icon
          Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_outlined,
                size: 52,
                color: _Colors.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ),

          // "RECOMMENDED SWAP" badge
          Positioned(
            bottom: 24.0,
            left: 24.0,
            right: 24.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: _Colors.primary,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    'RECOMMENDED SWAP',
                    style: _Typo.labelSm.copyWith(
                      color: _Colors.onPrimary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  foodName,
                  style: _Typo.headlineLgMobile.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Nutritional Insight Card
// ---------------------------------------------------------------------------

class _NutritionalInsightCard extends StatelessWidget {
  final String insight;
  final double fiberRetention;
  final double glycemicImpact;

  const _NutritionalInsightCard({
    required this.insight,
    required this.fiberRetention,
    required this.glycemicImpact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          const BoxShadow(
            color: Color(0x0D000000), // inner-glass-stroke equivalent
            blurRadius: 1.0,
            offset: Offset(0, -1),
          ),
          BoxShadow(
            color: _Colors.primaryContainer.withValues(alpha: 0.08),
            blurRadius: 30.0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: _Colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.insights,
                  color: _Colors.primary,
                  size: 24.0,
                ),
              ),
              const SizedBox(width: 16.0),
              Text(
                'Nutritional Insight',
                style: _Typo.headlineMd.copyWith(color: _Colors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Insight text
          Text(
            insight,
            style: _Typo.bodyMd.copyWith(
              color: _Colors.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24.0),

          // Fiber Retention progress bar
          _ProgressRow(
            label: 'Fiber Retention',
            value: fiberRetention,
            color: _Colors.primary,
          ),
          const SizedBox(height: 16.0),

          // Glycemic Impact progress bar
          _ProgressRow(
            label: 'Glycemic Impact',
            value: glycemicImpact,
            color: _Colors.secondary,
          ),
        ],
      ),
    );
  }
}

/// A labeled horizontal progress bar used for Fiber Retention / Glycemic Impact.
class _ProgressRow extends StatelessWidget {
  final String label;
  final double value; // 0.0 to 1.0
  final Color color;

  const _ProgressRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: _Typo.labelMd.copyWith(color: _Colors.onSurface),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            height: 8.0,
            decoration: BoxDecoration(
              color: _Colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(4.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// AI Pro Tip Card
// ---------------------------------------------------------------------------

class _AiProTipCard extends StatelessWidget {
  final String tip;
  const _AiProTipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: _Colors.onPrimaryContainer, // Dark green bg
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background decorative star icon
          Positioned(
            top: -8,
            right: -8,
            child: Icon(
              Icons.auto_awesome,
              size: 80,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Pro Tip',
                style: _Typo.headlineMd.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                tip,
                style: _Typo.labelMd.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Recipe Section (Ingredients + Steps)
// ---------------------------------------------------------------------------

class _RecipeSection extends StatelessWidget {
  final List<IngredientItem> ingredients;
  final List<String> steps;

  const _RecipeSection({required this.ingredients, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: _Colors.primaryContainer.withValues(alpha: 0.08),
            blurRadius: 30.0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: _Colors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  color: _Colors.secondary,
                  size: 24.0,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budget-Friendly Recipe',
                      style: _Typo.headlineMd.copyWith(
                        color: _Colors.onBackground,
                      ),
                    ),
                    Text(
                      'HEALTH DOESN\'T HAVE TO BE EXPENSIVE',
                      style: _Typo.labelSm.copyWith(
                        color: _Colors.onSurfaceVariant,
                        letterSpacing: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),

          // Ingredients sub-header
          Row(
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                color: _Colors.primary,
                size: 18.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Affordable Ingredients',
                style: _Typo.labelMd.copyWith(
                  color: _Colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Ingredients list
          if (ingredients.isEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: _Colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  'No ingredients loaded yet.',
                  style: _Typo.bodyMd.copyWith(
                    color: _Colors.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            ...ingredients.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: _Colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name,
                        style: _Typo.bodyMd.copyWith(
                          color: _Colors.onSurface,
                        ),
                      ),
                      Text(
                        item.price,
                        style: _Typo.labelSm.copyWith(
                          color: _Colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(height: 24.0),

          // Preparation steps sub-header
          Row(
            children: [
              Icon(
                Icons.restaurant_menu,
                color: _Colors.primary,
                size: 18.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Simple Preparation',
                style: _Typo.labelMd.copyWith(
                  color: _Colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Steps
          ...List.generate(steps.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step number circle
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: _Colors.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: _Typo.labelSm.copyWith(
                        color: _Colors.onPrimary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Step text
                  Expanded(
                    child: Text(
                      steps[index],
                      style: _Typo.bodyMd.copyWith(
                        color: _Colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom Navigation Bar
// ---------------------------------------------------------------------------

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _Colors.surface.withValues(alpha: 0.7),
        border: const Border(
          top: BorderSide(
            color: Color(0x4DBCCBB9), // outlineVariant/30
            width: 1.0,
          ),
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
        boxShadow: [
          BoxShadow(
            color: _Colors.primaryContainer.withValues(alpha: 0.08),
            blurRadius: 30.0,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: SafeArea(
            child: SizedBox(
              height: 68.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Camera
                  _NavItem(
                    icon: Icons.photo_camera_outlined,
                    label: 'Camera',
                    isActive: false,
                    onTap: () => Navigator.pushNamed(context, '/scan'),
                  ),
                  // Stats
                  _NavItem(
                    icon: Icons.insights_outlined,
                    label: 'Stats',
                    isActive: false,
                    onTap: () => Navigator.pushNamed(context, '/nutrition-detail'),
                  ),
                  // AI Hub (highlighted)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 10.0,
                      ),
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(context, '/'),
                        borderRadius: BorderRadius.circular(24.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: _Colors.primaryContainer,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.smart_toy,
                                color: _Colors.onPrimaryContainer,
                                size: 20.0,
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                'AI Hub',
                                style: _Typo.labelSm.copyWith(
                                  color: _Colors.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A standard bottom navigation item.
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: _Colors.onSurfaceVariant.withValues(alpha: 0.7),
                size: 24.0,
              ),
              const SizedBox(height: 4.0),
              Text(
                label,
                style: _Typo.labelSm.copyWith(
                  color: _Colors.onSurfaceVariant.withValues(alpha: 0.7),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
