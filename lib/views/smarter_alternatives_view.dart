import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────────────────────────────────────

/// Holds context about the food item that was scanned by the user.
class ScannedFoodContext {
  final String scannedFoodName;

  const ScannedFoodContext({
    required this.scannedFoodName,
  });
}

/// Encapsulates all data needed to render a single smart alternative card.
class SmartAlternativeModel {
  final String alternativeFoodName;
  final String? imageUrl; // nullable — null triggers the placeholder state
  final String nutritionTag; // e.g. "Vitamin A+", "High Protein", "High Satiety"
  final Color? nutritionTagColor; // optional tint override per badge
  final String macroSummary; // e.g. "Low carb, high Vitamin A."
  final String aiReasonQuote; // e.g. "A great grain-free swap with natural sweetness."

  const SmartAlternativeModel({
    required this.alternativeFoodName,
    this.imageUrl,
    required this.nutritionTag,
    this.nutritionTagColor,
    required this.macroSummary,
    required this.aiReasonQuote,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// VITALITY TECH THEME TOKENS
// ─────────────────────────────────────────────────────────────────────────────

class _VitalityColors {
  // Core greens
  static const Color primaryGreen = Color(0xFF1B8A4C);   // deep action green

  // Backgrounds
  static const Color scaffoldBg   = Color(0xFFF0F4F8);   // cool off-white
  static const Color cardBg       = Color(0xFFFFFFFF);

  // Text
  static const Color headlineText = Color(0xFF111827);
  static const Color bodyText     = Color(0xFF374151);
  static const Color mutedText    = Color(0xFF6B7280);

  // Badge palettes (tag → background)
  static const Color badgeGreenBg   = Color(0xFFDCF4E8);
  static const Color badgeBlueBg    = Color(0xFFDDEEFF);
  static const Color badgePeachBg   = Color(0xFFFFE8DC);

  // Quote block
  static const Color quoteBg        = Color(0xFFEEF3FB);
  static const Color quoteText      = Color(0xFF2563EB);

  // Image placeholder
  static const Color imagePlaceholderBg   = Color(0xFFE5E7EB);
  static const Color imagePlaceholderIcon = Color(0xFFD1D5DB);

  // AppBar
  static const Color appBarBg       = Color(0xFFF0F4F8);
  static const Color appBarIcon     = Color(0xFF1B8A4C);
  static const Color appBarTitle    = Color(0xFF1B8A4C);

  // Bottom nav
  static const Color navBg          = Color(0xFFFFFFFF);
  static const Color navInactive    = Color(0xFF9CA3AF);
  static const Color navActivePill  = Color(0xFF1B8A4C);
}

class _VitalitySpacing {
  static const double xs   = 4.0;
  static const double sm   = 8.0;
  static const double md   = 16.0;
  static const double lg   = 24.0;
  static const double xl   = 32.0;
  static const double pageH = 20.0; // horizontal page padding
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN VIEW
// ─────────────────────────────────────────────────────────────────────────────

class SmarterAlternativesView extends StatelessWidget {
  /// Inject a [ScannedFoodContext] to drive the dynamic subtitle.
  /// Defaults to a generic placeholder when not provided.
  final ScannedFoodContext foodContext;

  const SmarterAlternativesView({
    super.key,
    this.foodContext = const ScannedFoodContext(
      scannedFoodName: 'Your Scanned Item',
    ),
  });

  // ── Placeholder data ────────────────────────────────────────────────────────
  // Exactly 3 items as required. Swap these out with live AI output at runtime.
  List<SmartAlternativeModel> _buildPlaceholderAlternatives() => const [
    SmartAlternativeModel(
      alternativeFoodName: 'Alternative Option 1',
      imageUrl: null,
      nutritionTag: 'Vitamin A+',
      nutritionTagColor: _VitalityColors.badgeGreenBg,
      macroSummary: 'Low carb, high Vitamin A.',
      aiReasonQuote:
      '"A nutrient-rich option that supports your daily health goals."',
    ),
    SmartAlternativeModel(
      alternativeFoodName: 'Alternative Option 2',
      imageUrl: null,
      nutritionTag: 'High Protein',
      nutritionTagColor: _VitalityColors.badgeBlueBg,
      macroSummary: 'High protein, low fat.',
      aiReasonQuote:
      '"Plant-based fuel that keeps energy levels steady all day."',
    ),
    SmartAlternativeModel(
      alternativeFoodName: 'Alternative Option 3',
      imageUrl: null,
      nutritionTag: 'High Satiety',
      nutritionTagColor: _VitalityColors.badgePeachBg,
      macroSummary: 'High satiety, micronutrient dense.',
      aiReasonQuote:
      '"Keeps you fuller for longer with essential vitamins and minerals."',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final alternatives = _buildPlaceholderAlternatives();

    return Scaffold(
      backgroundColor: _VitalityColors.scaffoldBg,

      // ── AppBar ──────────────────────────────────────────────────────────────
      appBar: _VitalityAppBar(),

      // ── Body ────────────────────────────────────────────────────────────────
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            left: _VitalitySpacing.pageH,
            right: _VitalitySpacing.pageH,
            top: _VitalitySpacing.lg,
            bottom: _VitalitySpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Screen headline ──────────────────────────────────────────
              Text(
                'Smarter Alternatives',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: _VitalityColors.headlineText,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: _VitalitySpacing.md),

              // ── Dynamic subtitle ─────────────────────────────────────────
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _VitalityColors.bodyText,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'Based on your scan of '),
                    TextSpan(
                      text: foodContext.scannedFoodName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _VitalityColors.headlineText,
                      ),
                    ),
                    const TextSpan(
                      text:
                      ', here are some nutrient-optimized alternatives for your health goals.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: _VitalitySpacing.lg),

              // ── Alternative cards — looped ───────────────────────────────
              ...alternatives.map(
                    (item) => Padding(
                  padding: const EdgeInsets.only(bottom: _VitalitySpacing.md),
                  child: _AlternativeCard(model: item),
                ),
              ),
            ],
          ),
        ),
      ),

      // ── Bottom Navigation ────────────────────────────────────────────────
      bottomNavigationBar: const _VitalityBottomNav(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// APPBAR
// ─────────────────────────────────────────────────────────────────────────────

class _VitalityAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _VitalityAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _VitalityColors.appBarBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _VitalityColors.appBarIcon),
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushReplacementNamed('/');
          }
        },
      ),
      title: const Text(
        'Alternatives Food',
        style: TextStyle(
          color: _VitalityColors.appBarTitle,
          fontWeight: FontWeight.w700,
          fontSize: 17,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: _VitalityColors.imagePlaceholderBg,
            child: const Icon(
              Icons.person,
              size: 20,
              color: _VitalityColors.mutedText,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ALTERNATIVE CARD
// ─────────────────────────────────────────────────────────────────────────────

class _AlternativeCard extends StatelessWidget {
  final SmartAlternativeModel model;

  const _AlternativeCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _VitalityColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image placeholder area ─────────────────────────────────────
          _ImagePlaceholder(imageUrl: model.imageUrl),

          // ── Card content ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(_VitalitySpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + badge row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        model.alternativeFoodName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _VitalityColors.headlineText,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(width: _VitalitySpacing.sm),
                    _NutritionBadge(
                      label: model.nutritionTag,
                      backgroundColor:
                      model.nutritionTagColor ?? _VitalityColors.badgeGreenBg,
                    ),
                  ],
                ),
                const SizedBox(height: _VitalitySpacing.xs + 2),

                // Macro summary
                Text(
                  model.macroSummary,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _VitalityColors.mutedText,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: _VitalitySpacing.sm + 2),

                // AI reason quote block
                _QuoteBlock(quote: model.aiReasonQuote),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// IMAGE PLACEHOLDER
// ─────────────────────────────────────────────────────────────────────────────

class _ImagePlaceholder extends StatelessWidget {
  final String? imageUrl;

  const _ImagePlaceholder({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return SizedBox(
        height: 180,
        width: double.infinity,
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      color: _VitalityColors.imagePlaceholderBg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _VitalityColors.imagePlaceholderIcon,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.restaurant_outlined,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Food image preview',
            style: TextStyle(
              fontSize: 12,
              color: _VitalityColors.mutedText,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NUTRITION BADGE
// ─────────────────────────────────────────────────────────────────────────────

class _NutritionBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;

  const _NutritionBadge({
    required this.label,
    required this.backgroundColor,
  });

  /// Derive a readable text color from the background tint.
  Color get _textColor {
    if (backgroundColor == _VitalityColors.badgeGreenBg) {
      return const Color(0xFF166534);
    }
    if (backgroundColor == _VitalityColors.badgeBlueBg) {
      return const Color(0xFF1D4ED8);
    }
    if (backgroundColor == _VitalityColors.badgePeachBg) {
      return const Color(0xFFC2410C);
    }
    return _VitalityColors.primaryGreen;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _textColor,
          height: 1.3,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AI REASON QUOTE BLOCK
// ─────────────────────────────────────────────────────────────────────────────

class _QuoteBlock extends StatelessWidget {
  final String quote;

  const _QuoteBlock({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: _VitalitySpacing.md,
        vertical: _VitalitySpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: _VitalityColors.quoteBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        quote,
        style: const TextStyle(
          fontSize: 13.5,
          fontStyle: FontStyle.italic,
          color: _VitalityColors.quoteText,
          height: 1.5,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM NAVIGATION
// ─────────────────────────────────────────────────────────────────────────────

enum _NavItem { camera, stats, aiHub }

class _VitalityBottomNav extends StatelessWidget {
  const _VitalityBottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: _VitalityColors.navBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavIconItem(
              icon: Icons.camera_alt_outlined,
              label: 'Camera',
              item: _NavItem.camera,
              activeItem: _NavItem.aiHub, // aiHub is active on this screen
            ),
            _NavIconItem(
              icon: Icons.show_chart,
              label: 'Stats',
              item: _NavItem.stats,
              activeItem: _NavItem.aiHub,
            ),
            _NavPillItem(label: 'AI Hub'),
          ],
        ),
      ),
    );
  }
}

class _NavIconItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final _NavItem item;
  final _NavItem activeItem;

  const _NavIconItem({
    required this.icon,
    required this.label,
    required this.item,
    required this.activeItem,
  });

  bool get _isActive => item == activeItem;

  @override
  Widget build(BuildContext context) {
    final color = _isActive
        ? _VitalityColors.primaryGreen
        : _VitalityColors.navInactive;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (item == _NavItem.camera) {
          Navigator.pushNamed(context, '/scan');
        } else if (item == _NavItem.stats) {
          Navigator.pushNamed(context, '/nutrition-detail');
        }
      },
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight:
                _isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavPillItem extends StatelessWidget {
  final String label;

  const _NavPillItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pushNamed(context, '/'),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          color: _VitalityColors.navActivePill,
          borderRadius: BorderRadius.circular(22),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}