import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/core/constants.dart';
import 'package:portfolio/presentation/widgets/home_widgets.dart';

class EducationExperienceSection extends StatelessWidget {
  final GlobalKey educationKey;
  final GlobalKey experienceKey;
  final VoidCallback onScrollToExperience;
  final VoidCallback? onScrollToContact;

  const EducationExperienceSection({
    super.key,
    required this.educationKey,
    required this.experienceKey,
    required this.onScrollToExperience,
    this.onScrollToContact,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        // EDUCATION SECTION (New Style)
        SizedBox(
          key: educationKey,
          child: Container(
            constraints: BoxConstraints(minHeight: screenHeight - 60),
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _SectionTitle(title: "EDUCATION", subtitle: "LEARNING"),
                const SizedBox(height: 80),
                _EducationTimeline(isMobile: isMobile),
                if (!isMobile) ...[
                  const SizedBox(height: 50),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ScrollIndicator(onTap: onScrollToExperience),
                  ),
                ],
              ],
            ),
          ),
        ),

        // EXPERIENCE SECTION (Old Style - Restored)
        // Reduced vertical padding to make it more compact
        SizedBox(
          key: experienceKey,
          child: Container(
            constraints: BoxConstraints(minHeight: screenHeight - 60),
            padding: const EdgeInsets.symmetric(
              vertical: 30,
            ), // Reduced from 50
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _SectionTitle(
                  title: "EXPERIENCE",
                  subtitle: "INVOLVEMENT",
                ),
                const SizedBox(height: 40), // Reduced from 80
                _ExperienceTimeline(isMobile: isMobile),
                if (!isMobile && onScrollToContact != null) ...[
                  const SizedBox(height: 30), // Reduced from 50
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ScrollIndicator(onTap: onScrollToContact),
                  ),
                ],
              ],
            ),
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
      children: [
        Text(
          title,
          style: GoogleFonts.oswald(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 2,
              width: 50,
              color: const Color(0xFFFFC107), // Amber
            ),
            const SizedBox(width: 15),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: const Color(0xFFFFC107), // Amber
                letterSpacing: 3.0,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// =============================================================================
// EDUCATION WIDGETS (NEW STYLE)
// =============================================================================

class _EducationTimeline extends StatelessWidget {
  final bool isMobile;

  const _EducationTimeline({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final items = AppConstants.education;

    return Stack(
      children: [
        // Central Line
        if (!isMobile)
          Positioned.fill(
            child: Center(
              child: Container(
                width: 1, // Thin line
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.2),
              ),
            ),
          ),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final data = items[index];
            final isLeft = index % 2 == 0;

            if (isMobile) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: _MobileEducationItem(data: data),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left Side
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 60),
                        child: isLeft
                            ? _EducationContentItem(data: data, alignLeft: true)
                            : _EducationYearItem(year: data['year']!),
                      ),
                    ),
                  ),

                  // Center Dot
                  _HollowDot(),

                  // Right Side
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 60),
                        child: !isLeft
                            ? _EducationContentItem(
                                data: data,
                                alignLeft: false,
                              )
                            : _EducationYearItem(year: data['year']!),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _HollowDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
    );
  }
}

class _EducationYearItem extends StatelessWidget {
  final String year;
  const _EducationYearItem({required this.year});

  @override
  Widget build(BuildContext context) {
    return Text(
      year,
      style: GoogleFonts.oswald(
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
      ),
    );
  }
}

class _EducationContentItem extends StatelessWidget {
  final Map<String, String> data;
  final bool alignLeft;

  const _EducationContentItem({required this.data, required this.alignLeft});

  @override
  Widget build(BuildContext context) {
    final textAlign = alignLeft ? TextAlign.end : TextAlign.start;
    final crossAlign = alignLeft
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: crossAlign,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          data['title']!,
          textAlign: textAlign,
          style: GoogleFonts.oswald(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          data['subtitle']!,
          textAlign: textAlign,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: 300,
          child: Text(
            data['description']!,
            textAlign: textAlign,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.54),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileEducationItem extends StatelessWidget {
  final Map<String, String> data;
  const _MobileEducationItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['year']!,
            style: GoogleFonts.oswald(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data['title']!,
            style: GoogleFonts.oswald(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            data['subtitle']!,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data['description']!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// EXPERIENCE WIDGETS (OLD STYLE - RESTORED)
// =============================================================================

class _ExperienceTimeline extends StatelessWidget {
  final bool isMobile;

  const _ExperienceTimeline({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final items = AppConstants.experience;

    return Stack(
      children: [
        // Central Line (Only visible on Desktop/Tablet)
        if (!isMobile)
          Positioned.fill(
            child: Center(
              child: Container(
                width: 1,
                color: Theme.of(context).dividerColor.withValues(alpha: .3),
              ),
            ),
          ),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final data = items[index];
            final isLeft = index % 2 == 0;

            if (isMobile) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 30.0, // Reduced from 40
                  left: 20,
                  right: 20,
                ),
                child: _ExperienceCard(data: data, alignLeft: true),
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: isLeft
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 30,
                              bottom: 30, // Reduced from 40
                            ),
                            child: _ExperienceCard(data: data, alignLeft: true),
                          ),
                        )
                      : const SizedBox(),
                ),
                // Timeline Dot
                SizedBox(width: 60, child: Center(child: _ExperienceDot())),
                Expanded(
                  child: !isLeft
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 30,
                              bottom: 40, // Reduced from 60
                            ),
                            child: _ExperienceCard(
                              data: data,
                              alignLeft: false,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ExperienceDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .5),
          width: 1.5,
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final Map<String, String> data;
  final bool alignLeft;

  const _ExperienceCard({required this.data, required this.alignLeft});

  @override
  Widget build(BuildContext context) {
    // In the image, experience has big faded year background
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background Year
        Positioned(
          top: -20,
          right: alignLeft ? 0 : null,
          left: alignLeft ? null : 0,
          child: Text(
            data['year']!,
            style: GoogleFonts.oswald(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: .05),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16), // Reduced from 20
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF2C2C2C)
                : Colors.grey[200], // Dark Card Color or Light Grey
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['role']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data['company']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .7),
                ),
              ),
              const SizedBox(height: 6), // Reduced from 8
              Text(
                data['description']!,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .6),
                  fontSize: 12,
                  height: 1.4, // Reduced from 1.5
                ),
              ),
              const SizedBox(height: 8), // Reduced from 10
              Text(
                "${data['start']} - ${data['end']}",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
