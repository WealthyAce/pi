import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Color tokens matching the 'Vitality Tech' theme color palette.
class VitalityTechColors {
  static const Color primary = Color(0xFF006E2F);
  static const Color primaryContainer = Color(0xFF22C55E);
  static const Color primaryFixedDim = Color(0xFF4AE176);
  static const Color secondary = Color(0xFF9D4300);
  static const Color secondaryContainer = Color(0xFFFD761A);
  static const Color secondaryFixed = Color(0xFFFFDBCA);
  static const Color secondaryFixedDim = Color(0xFFFFB690);
  static const Color onSecondaryFixed = Color(0xFF341100);
  static const Color tertiary = Color(0xFF006591);
  static const Color tertiaryContainer = Color(0xFF36B6FB);
  static const Color tertiaryFixedDim = Color(0xFF89CEFF);
  static const Color background = Color(0xFFF8F9FF);
  static const Color onBackground = Color(0xFF0B1C30);
  static const Color surface = Color(0xFFF8F9FF);
  static const Color onSurface = Color(0xFF0B1C30);
  static const Color onSurfaceVariant = Color(0xFF3D4A3D);
  static const Color outline = Color(0xFF6D7B6C);
  static const Color outlineVariant = Color(0xFFBCCBB9);
  static const Color surfaceContainerLow = Color(0xFFEFF4FF);
  static const Color surfaceContainerHigh = Color(0xFFDCE9FF);
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
    letterSpacing: -0.96,
    color: VitalityTechColors.onSurface,
  );

  static const TextStyle headlineLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: -0.24,
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
    letterSpacing: 0.14,
    color: VitalityTechColors.onSurfaceVariant,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.6,
    color: VitalityTechColors.onSurfaceVariant,
  );
}

// route
class PersonalizationHubView extends StatefulWidget {
  const PersonalizationHubView({super.key});

  @override
  State<PersonalizationHubView> createState() => _PersonalizationHubViewState();
}

class _PersonalizationHubViewState extends State<PersonalizationHubView> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWide = screenWidth > 768;

    return Scaffold(
      backgroundColor: VitalityTechColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(1.0, -0.8),
                  radius: 1.5,
                  colors: [
                    Color(0xFFE5EEFF),
                    Color(0xFFF8F9FF),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 56.0),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Personalization Hub',
                            style: VitalityTechTypography.headlineLg.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Harness clinical-grade AI to tailor every meal to your unique biological needs and lifestyle preferences.',
                            style: VitalityTechTypography.bodyMd.copyWith(
                              color: VitalityTechColors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PersonalizationCard(
                              icon: Icons.soup_kitchen_outlined,
                              title: 'Healthy Homemade Modifier',
                              description:
                              'Transform traditional family recipes into nutrient-dense powerhouses.',
                              iconColor: VitalityTechColors.primary,
                              iconBgColor: VitalityTechColors.primaryFixedDim
                                  .withValues(alpha: 0.2),
                              onTap: () => Navigator.pushNamed(context, '/homemade-food'),
                            ),
                          ),
                          const SizedBox(width: 24.0),
                          Expanded(
                            child: PersonalizationCard(
                              icon: Icons.published_with_changes_outlined,
                              title: 'Healthy Smart Alternatives',
                              description:
                              'Instant meal replacements based on your current pantry and dietary goals.',
                              iconColor: VitalityTechColors.secondary,
                              iconBgColor: VitalityTechColors.secondaryFixedDim
                                  .withValues(alpha: 0.3),
                              onTap: () => Navigator.pushNamed(context, '/smarter-alternatives'),
                            ),
                          ),
                          const SizedBox(width: 24.0),
                          Expanded(
                            child: PersonalizationCard(
                              icon: Icons.psychology_outlined,
                              title: 'Open Discussion AI',
                              description:
                              'Ask complex questions about nutrition, vitamin interactions, or performance fueling.',
                              iconColor: VitalityTechColors.tertiary,
                              iconBgColor: VitalityTechColors.tertiaryFixedDim
                                  .withValues(alpha: 0.3),
                              onTap: () => Navigator.pushNamed(context, '/nutrition-chatbot'),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          PersonalizationCard(
                            icon: Icons.soup_kitchen_outlined,
                            title: 'Healthy Homemade Modifier',
                            description:
                            'Transform traditional family recipes into nutrient-dense powerhouses.',
                            iconColor: VitalityTechColors.primary,
                            iconBgColor: VitalityTechColors.primaryFixedDim
                                .withValues(alpha: 0.2),
                            onTap: () => Navigator.pushNamed(context, '/homemade-food'),
                          ),
                          const SizedBox(height: 16.0),
                          PersonalizationCard(
                            icon: Icons.published_with_changes_outlined,
                            title: 'Healthy Smart Alternatives',
                            description:
                            'Instant meal replacements based on your current pantry and dietary goals.',
                            iconColor: VitalityTechColors.secondary,
                            iconBgColor: VitalityTechColors.secondaryFixedDim
                                .withValues(alpha: 0.3),
                            onTap: () => Navigator.pushNamed(context, '/smarter-alternatives'),
                          ),
                          const SizedBox(height: 16.0),
                          PersonalizationCard(
                            icon: Icons.psychology_outlined,
                            title: 'Open Discussion AI',
                            description:
                            'Ask complex questions about nutrition, vitamin interactions, or performance fueling.',
                            iconColor: VitalityTechColors.tertiary,
                            iconBgColor: VitalityTechColors.tertiaryFixedDim
                                .withValues(alpha: 0.3),
                            onTap: () => Navigator.pushNamed(context, '/nutrition-chatbot'),
                          ),
                        ],
                      ),
                    const SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: VitalityTechColors.outlineVariant,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: VitalityTechColors.outlineVariant,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Container(
                          width: 24,
                          height: 8,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            color: VitalityTechColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: PreferredSize(
              preferredSize: const Size.fromHeight(56.0),
              child: Container(
                decoration: BoxDecoration(
                  color: VitalityTechColors.surface.withValues(alpha: 0.7),
                  border: const Border(
                    bottom: BorderSide(
                      color: Color(0x1F6D7B6C),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: VitalityTechColors.primaryFixedDim,
                                    border: Border.all(
                                      color: VitalityTechColors.primary
                                          .withValues(alpha: 0.2),
                                      width: 1.5,
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.network(
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuB2LGOjFFIaap3vQAwfyseq6v6NlTF_ODJyxi5-2LbFFjMvhP1X9Ztgce9voCjBE4hBZjWLfBAzzyXgk7J-6IaibdkHDQPJLvwfgk3fp9Cl2gr7y2PeZYuL1Y1uWt_nKmsspYKLtPJPDMFQCKZklKNTD29wU-rzbKuynini39u77WuZEzEliYfnXA1T8G_zGgfEyudda-IevK_dsofiarXts1IXX1-O8VjOaryASnR_CxmnANCeTuBSyZyY2dVv-2EnS-0zOmclr4Y',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.person,
                                      size: 18,
                                      color: VitalityTechColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Text(
                                  'NutriScan AI',
                                  style: VitalityTechTypography.headlineMd
                                      .copyWith(
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
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: VitalityTechColors.surface.withValues(alpha: 0.8),
        border: const Border(
          top: BorderSide(
            color: Color(0x33BCCBB9),
            width: 1.0,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: SafeArea(
            child: SizedBox(
              height: 68.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomNavItem(
                    icon: Icons.photo_camera_outlined,
                    label: 'Camera',
                    isActive: false,
                    onTap: () => Navigator.pushNamed(context, '/scan'),
                  ),
                  _buildBottomNavItem(
                    icon: Icons.insights_outlined,
                    label: 'Stats',
                    isActive: false,
                    onTap: () => Navigator.pushNamed(context, '/nutrition-detail'),
                  ),
                  _buildBottomNavActiveAIHub(),
                ],
              ),
            ),
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
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: VitalityTechColors.onSurfaceVariant,
                size: 24.0,
              ),
              const SizedBox(height: 4.0),
              Text(
                label,
                style: VitalityTechTypography.labelSm.copyWith(
                  color: VitalityTechColors.onSurfaceVariant,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavActiveAIHub() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(24.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: VitalityTechColors.primary,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: VitalityTechColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8.0,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                  size: 20.0,
                ),
                SizedBox(width: 8.0),
                Text(
                  'AI Hub',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PersonalizationCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback onTap;

  const PersonalizationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.iconBgColor,
    required this.onTap,
  });

  @override
  State<PersonalizationCard> createState() => _PersonalizationCardState();
}

class _PersonalizationCardState extends State<PersonalizationCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed ? 0.97 : (_isHovered ? 1.02 : 1.0);
    final translationY = _isHovered ? -8.0 : 0.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          transform: Matrix4.diagonal3Values(scale, scale, 1.0)..setTranslationRaw(0, translationY, 0),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: _isHovered
                  ? VitalityTechColors.primary.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.85),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? VitalityTechColors.primary.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: _isHovered ? 32.0 : 20.0,
                offset: Offset(0, _isHovered ? 12.0 : 4.0),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: widget.iconBgColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.iconColor,
                        size: 32.0,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      widget.title,
                      style: VitalityTechTypography.headlineMd.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.description,
                      style: VitalityTechTypography.bodyMd.copyWith(
                        color: VitalityTechColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}