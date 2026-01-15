import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/core/constants.dart';
import 'package:portfolio/core/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NavBar extends StatelessWidget {
  final VoidCallback? onAboutTap;
  final VoidCallback? onServicesTap;
  final VoidCallback? onExperienceTap;
  final VoidCallback? onContactTap;
  final String activeSection; // New: to track scrolling state

  const NavBar({
    super.key,
    this.onAboutTap,
    this.onServicesTap,
    this.onExperienceTap,
    this.onContactTap,
    this.activeSection = '',
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo / Name
        Text(
          AppConstants.name.split(' ')[0], // "FAWAZ"
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),

        // Navigation Links
        if (!isMobile)
          Row(
            children: [
              _NavLink(
                text: AppConstants.about,
                onTap: onAboutTap,
                isActive: activeSection == AppConstants.about,
              ),
              const SizedBox(width: 20),
              _NavLink(
                text: AppConstants.services,
                onTap: onServicesTap,
                isActive: activeSection == AppConstants.services,
              ),
              const SizedBox(width: 20),
              _NavLink(
                text: AppConstants.experienceStr,
                onTap: onExperienceTap,
                isActive: activeSection == AppConstants.experienceStr,
              ),
              const SizedBox(width: 20),
              _NavLink(
                text: AppConstants.contact,
                onTap: onContactTap,
                isActive: activeSection == AppConstants.contact,
              ),
              const SizedBox(width: 20),
              const ThemeToggle(),
            ],
          ),

        // Mobile Menu Icon + Theme Toggle
        if (isMobile)
          Row(
            children: [
              const ThemeToggle(),
              const SizedBox(width: 10),
              IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
            ],
          ),
      ],
    );
  }
}

class _NavLink extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isActive;

  const _NavLink({required this.text, this.onTap, required this.isActive});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine color: Active OR Hover -> Primary, Else -> Faded
    final color = (widget.isActive || _isHovered)
        ? theme.primaryColor
        : theme.colorScheme.onSurface.withValues(alpha: 0.7);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: (widget.isActive || _isHovered)
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            // Animated Underline
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 2,
              // Width: Expand if hovered OR active
              width: (_isHovered || widget.isActive) ? 20 : 0,
              color: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppConstants.hello,
          style: theme.textTheme.titleMedium?.copyWith(
            letterSpacing: 2.0,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 10),

        // Line separator with animations could go here
        Container(height: 2, width: 100, color: theme.primaryColor),
        const SizedBox(height: 20),

        // Big Name
        Text(
          AppConstants.name,
          textAlign: TextAlign.center,
          style: GoogleFonts.oswald(
            // Using Oswald or similar for heavy font
            fontSize: isMobile ? 48 : 80,
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface,
            height: 1.0,
          ),
        ),

        const SizedBox(height: 10),

        // Role
        Text(
          AppConstants.role,
          style: theme.textTheme.titleSmall?.copyWith(
            letterSpacing: 3.0,
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class SocialBar extends StatelessWidget {
  const SocialBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialIcon(
          icon: FontAwesomeIcons.github,
          url: 'https://github.com/fawas986',
          tooltip: 'GitHub',
        ),
        const SizedBox(height: 15),
        _SocialIcon(
          icon: FontAwesomeIcons.instagram,
          url: 'https://www.instagram.com/thakku_z/?hl=en',
          tooltip: 'Instagram',
        ),
        const SizedBox(height: 15),
        _SocialIcon(
          icon: FontAwesomeIcons.linkedinIn,
          url: 'https://www.linkedin.com/in/fawas-rahim/',
          tooltip: 'LinkedIn',
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final String url;
  final String tooltip;
  const _SocialIcon({
    required this.icon,
    required this.url,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: () async {
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url));
          }
        },
        icon: FaIcon(icon, size: 20),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }
}

class ScrollIndicator extends StatelessWidget {
  final VoidCallback? onTap;
  const ScrollIndicator({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Touch area padding
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                'scroll',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_downward,
              size: 16,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return IconButton(
          onPressed: () {
            themeProvider.toggleTheme();
          },
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return RotationTransition(turns: animation, child: child);
            },
            child: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              key: ValueKey<bool>(themeProvider.isDarkMode),
              color: Theme.of(context).primaryColor,
            ),
          ),
        );
      },
    );
  }
}
