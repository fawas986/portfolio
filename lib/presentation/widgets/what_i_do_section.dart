import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/presentation/widgets/home_widgets.dart';

class WhatIDoSection extends StatelessWidget {
  final VoidCallback? onScrollTap;
  const WhatIDoSection({super.key, this.onScrollTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 1000;
    final theme = Theme.of(context);

    // Header logic similar to before but tuned for column layout
    final headerContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "FEATURES",
          style: GoogleFonts.oswald(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "What I Do",
          style: GoogleFonts.oswald(
            fontSize: isMobile ? 48 : 48, // Reduced max size for desktop
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 3, width: 60, color: theme.primaryColor),
          ],
        ),
      ],
    );

    return Container(
      width: size.width,
      // For desktop, aim for at least screen height to act as a "page"
      // But allow it to be scrollable if content overflows (MinHeight)
      // Actually user wanted it to "fit", so using Center + minHeight helps
      constraints: BoxConstraints(minHeight: size.height),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 30, // Reduced vertical padding
        horizontal: isMobile ? 20 : 60,
      ),
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          // Main Content centered
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerContent,
                SizedBox(height: isMobile ? 50 : 25), // Reduced gap
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: _ServicesGrid(
                    isMobile: isMobile,
                    isInternalMobile: isMobile,
                  ),
                ),
              ],
            ),
          ),

          // Scroll Indicator
          Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ScrollIndicator(onTap: onScrollTap),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  final bool isMobile;
  final bool isInternalMobile; // Helper for logic inside
  const _ServicesGrid({required this.isMobile, required this.isInternalMobile});

  @override
  Widget build(BuildContext context) {
    final services = [
      _ServiceItem(
        icon: Icons.phone_android,
        title: "Flutter App Development",
        description:
            "Building high-performance cross-platform mobile applications using Flutter for Android and iOS.",
      ),
      _ServiceItem(
        icon: Icons.design_services,
        title: "UI/UX Implementation",
        description:
            "Converting designs into clean, responsive, and pixel-perfect user interfaces with smooth animations.",
      ),
      _ServiceItem(
        icon: Icons.cloud_outlined,
        title: "Firebase Integration",
        description:
            "Integrating Firebase services including authentication, Firestore, real-time database, and cloud storage.",
      ),
      _ServiceItem(
        icon: Icons.storage,
        title: "Local Database & Offline Support",
        description:
            "Implementing SQLite and local storage solutions for offline-first apps with seamless data syncing.",
      ),
      _ServiceItem(
        icon: Icons.api_outlined,
        title: "API Integration",
        description:
            "Connecting REST APIs, handling JSON data, and managing secure network communication in apps.",
      ),
      _ServiceItem(
        icon: Icons.build_circle_outlined,
        title: "App Optimization & Maintenance",
        description:
            "Improving app performance, fixing bugs, refactoring code, and maintaining scalable architecture.",
      ),
    ];

    if (!isInternalMobile) {
      // Desktop Grid - 3 Columns to reduce height and equal rows
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 columns = 2 rows for 6 items
          crossAxisSpacing: 20, // Reduced spacing
          mainAxisSpacing: 20, // Reduced spacing
          childAspectRatio:
              1.6, // Wider aspect ratio = less vertical height per item
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          return _ServiceCard(item: services[index]);
        },
      );
    }

    // Mobile Wrap
    return Center(
      child: Wrap(
        spacing: 30,
        runSpacing: 30,
        alignment: WrapAlignment.center,
        children: services.map((service) {
          return SizedBox(
            width: double.infinity,
            child: _ServiceCard(item: service),
          );
        }).toList(),
      ),
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final String title;
  final String description;

  _ServiceItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _ServiceCard extends StatefulWidget {
  final _ServiceItem item;
  const _ServiceCard({required this.item});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ), // Reduced padding
        decoration: BoxDecoration(
          color: _isHovered ? theme.primaryColor : backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (!_isHovered)
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            if (_isHovered)
              BoxShadow(
                color: theme.primaryColor.withValues(alpha: 0.4),
                blurRadius: 25,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.item.icon,
              size: 32, // Slightly smaller icon
              color: _isHovered ? Colors.white : theme.primaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              widget.item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.oswald(
                fontSize: 18, // Slightly smaller font
                fontWeight: FontWeight.w600,
                color: _isHovered ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.item.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12, // Slightly smaller font
                height: 1.4,
                color: _isHovered
                    ? Colors.white.withValues(alpha: .9)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
