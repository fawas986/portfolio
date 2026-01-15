import 'package:flutter/material.dart';
import 'package:portfolio/core/constants.dart';
import 'package:portfolio/presentation/widgets/home_widgets.dart';
import 'package:portfolio/presentation/widgets/education_experience_section.dart';
import 'package:portfolio/presentation/widgets/contact_section.dart';
import 'package:portfolio/presentation/widgets/about_section.dart';
import 'package:portfolio/presentation/widgets/what_i_do_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey educationKey = GlobalKey();
  final GlobalKey experienceKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey whatIDoKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  String _activeSection = ''; // Track active section

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Simple heuristic: check which section top is closest to 0 or within view
    // A better approach is checking if the section's RenderBox intersects with viewport

    // We can define "active" as: The section that is currently at the top or covering most of the screen.
    // Let's check offsets.

    // Helper to get offset of a key
    double? getOffset(GlobalKey key) {
      final context = key.currentContext;
      if (context == null) return null;
      final box = context.findRenderObject() as RenderBox;
      // We need offset relative to the scroll view start.
      // box.localToGlobal(Offset.zero) gives global screen coordinates.
      // We can use that.
      final position = box.localToGlobal(Offset.zero);
      return position.dy;
      // If position.dy is around 0 to screenHeight/2, it's likely active.
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final threshold = screenHeight * 0.4; // Detection threshold

    // Check sections in order
    // Since we are using a SingleChildScrollView, the offsets change as we scroll.

    String newActive = '';

    // We can check each section's position relative to the viewport top
    // The "active" one is usually the one that has just passed the top or is about to.

    final aboutPos = getOffset(aboutKey);
    final whatIDoPos = getOffset(whatIDoKey);
    final experiencePos = getOffset(
      experienceKey,
    ); // Education spans multiple, simplifying to experience section roughly
    final contactPos = getOffset(contactKey);

    // Simple logic: explicitly check ranges
    // Note: getOffset returns Y position relative to SCREEN TOP.

    if (contactPos != null && contactPos < screenHeight - 100) {
      newActive = AppConstants.contact;
    } else if (experiencePos != null && experiencePos < threshold) {
      newActive = AppConstants.experienceStr;
    } else if (whatIDoPos != null && whatIDoPos < threshold) {
      newActive = AppConstants.services;
    } else if (aboutPos != null && aboutPos < threshold) {
      newActive = AppConstants.about;
    } else {
      // Hero section or above
      newActive = '';
    }

    if (newActive != _activeSection) {
      setState(() {
        _activeSection = newActive;
      });
    }
  }

  void scrollToSection(GlobalKey key, {double extraOffset = 40}) {
    final context = key.currentContext;
    if (context == null) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);

    final double targetOffset =
        _scrollController.offset + position.dy - extraOffset;

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final size = MediaQuery.of(context).size;

    // Simple responsive breakpoint
    final isMobile = size.width < 800;

    return Scaffold(
      body: Stack(
        children: [
          // Background - allows for future complex backgrounds
          Container(color: Theme.of(context).scaffoldBackgroundColor),

          // Main Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20.0 : 60.0,
              vertical: isMobile ? 20.0 : 10.0,
            ),
            child: Column(
              children: [
                // Navbar
                NavBar(
                  activeSection: _activeSection,
                  onAboutTap: () => scrollToSection(aboutKey, extraOffset: 20),
                  onServicesTap: () =>
                      scrollToSection(whatIDoKey, extraOffset: 30),
                  onExperienceTap: () => scrollToSection(
                    experienceKey,
                    extraOffset: 30,
                  ), // Scroll to Experience directly as per constant name, usually education comes first so maybe educationKey? But Constant says EXPERIENCE. Let's use experienceKey for direct match or educationKey if that's the start of that "page". The previous code linked "EducationExperience" to experienceKey mostly. Let's stick to experienceKey if the user wants "EXPERIENCE". Or if "SERVICES" -> WhatIDo.
                  // Wait, "Services" -> What I Do.
                  // "Experience" -> EducationExperience.
                  // EducationExperienceSection starts with Education. Scroll to educationKey then?
                  // Providing educationKey for the Experience Nav Link for logical flow (top of section)
                  onContactTap: () => scrollToSection(contactKey),
                ),

                // Expanded Area for Hero Section & content
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // First Page Section (Hero + Footer)
                            SizedBox(
                              height: constraints.maxHeight,
                              child: Stack(
                                children: [
                                  // Centered Hero Content
                                  Center(
                                    child: Transform.translate(
                                      offset: const Offset(0, -20),
                                      child: const HeroSection(),
                                    ),
                                  ),

                                  // Footer Elements
                                  if (!isMobile)
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const SocialBar(),
                                          // Scroll Button on Right
                                          ScrollIndicator(
                                            onTap: () =>
                                                scrollToSection(aboutKey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (isMobile)
                                    const Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Center(child: SocialBar()),
                                    ),
                                ],
                              ),
                            ),

                            // About Section
                            AboutSection(
                              aboutKey: aboutKey,
                              onScrollTap: () =>
                                  scrollToSection(whatIDoKey, extraOffset: 30),
                              onHireMeTap: () => scrollToSection(
                                contactKey,
                              ), // Passed callback
                            ),

                            // What I Do Section
                            WhatIDoSection(
                              key: whatIDoKey,
                              onScrollTap: () => scrollToSection(
                                educationKey,
                                extraOffset: -10,
                              ),
                            ),

                            // Education and Experience Section
                            EducationExperienceSection(
                              educationKey: educationKey,
                              experienceKey: experienceKey,
                              onScrollToExperience: () => scrollToSection(
                                experienceKey,
                                extraOffset: 20,
                              ),
                              onScrollToContact: () =>
                                  scrollToSection(contactKey),
                            ),
                            // Contact Section
                            ContactSection(key: contactKey),
                          ],
                        ),
                      );
                    },
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
