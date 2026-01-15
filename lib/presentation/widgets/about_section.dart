import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/presentation/widgets/home_widgets.dart';

class AboutSection extends StatelessWidget {
  final void Function()? onScrollTap;
  final void Function()? onHireMeTap; // Added callback
  final GlobalKey aboutKey;
  const AboutSection({
    super.key,
    this.onScrollTap,
    this.onHireMeTap,
    required this.aboutKey,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      key: aboutKey,
      width: double.infinity,
      height: isMobile ? null : size.height,
      // Minimal height to ensure it looks good, but let content drive it
      constraints: BoxConstraints(minHeight: size.height),
      padding: EdgeInsets.symmetric(vertical: 50),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: isMobile
          ? _MobileLayout(onHireMeTap)
          : _DesktopLayout(onScrollTap, onHireMeTap),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final void Function()? onScrollTap;
  final void Function()? onHireMeTap;
  const _DesktopLayout(this.onScrollTap, this.onHireMeTap);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // LEFT: Lottie Animation
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: isMobile ? 20 : 50),
            child: Center(
              child: SizedBox(
                height: 400,
                width: 400,
                child: Lottie.asset(
                  'assets/lottie/lottie_1.json',
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "Lottie Animation\nassets/lottie/me.json",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 80),
        // RIGHT: Content
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(right: isMobile ? 20 : 50),
            child: _AboutContent(onHireMeTap),
          ),
        ),

        Column(
          children: [
            Spacer(),
            ScrollIndicator(onTap: onScrollTap),
          ],
        ),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final void Function()? onHireMeTap;
  const _MobileLayout(this.onHireMeTap);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          width: 300,
          child: Lottie.asset(
            'assets/lottie/me.json',
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    "Lottie Animation\nassets/lottie/me.json",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 40),
        _AboutContent(onHireMeTap),
      ],
    );
  }
}

class _AboutContent extends StatelessWidget {
  final void Function()? onHireMeTap;
  const _AboutContent(this.onHireMeTap);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _SectionTitle(title: "ABOUT ME", subtitle: "WHO AM I"),
        const SizedBox(height: 30),
        Text(
          "I’m a passionate Flutter Developer who enjoys building clean, scalable, and high-performance mobile applications. I specialize in crafting smooth user experiences, writing maintainable code, and turning ideas into reliable products. My focus is not just on making apps work, but on making them feel right—fast, intuitive, and polished.",
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "I’ve worked on projects involving offline-first architectures, SQLite and Firebase synchronization, complex data relationships, custom UI interactions, and performance-optimized image and video handling. I’m comfortable taking ownership of features end-to-end, from UI design to data flow and logic implementation.",
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Driven by curiosity and continuous learning, I enjoy solving real-world problems through technology and constantly refining my skills to stay aligned with modern development practices. I’m currently looking for opportunities where I can contribute, grow, and build impactful mobile experiences.',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: onHireMeTap, // Use callback
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFC107), // Amber/Yellow
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: const Text(
            "Hire Me",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.oswald(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 2,
              width: 40,
              color: const Color(0xFFFFC107), // Amber Color
            ),
            const SizedBox(width: 10),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: const Color(0xFFFFC107),
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
