import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      width: double.infinity,
      height: isMobile ? null : size.height,
      constraints: BoxConstraints(minHeight: size.height),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 50,
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: isMobile ? const _MobileLayout() : const _DesktopLayout(),
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // LEFT COLUMN: FORM
        Expanded(
          flex: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Contact Me",
                style: GoogleFonts.oswald(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Let's start something\ngreat together.",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .7),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 50),
              const _ContactForm(),
            ],
          ),
        ),
        const SizedBox(width: 100),
        // RIGHT COLUMN: INFO
        const Expanded(
          flex: 2,
          child: Padding(padding: EdgeInsets.zero, child: _ContactInfo()),
        ),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact Me",
          style: GoogleFonts.oswald(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Let's start something\ngreat together.",
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .7),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 40),
        const _ContactForm(),
        const SizedBox(height: 60),
        const _ContactInfo(),
      ],
    );
  }
}

class _ContactForm extends StatefulWidget {
  const _ContactForm();

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final String recipient = "fawasrahim986@gmail.com";
    final String subject = Uri.encodeComponent("Portfolio Contact from $name");
    final String body = Uri.encodeComponent(
      "Name: $name\nEmail: $email\n\nResult: $message",
    );

    final Uri mailtoUri = Uri.parse(
      "mailto:$recipient?subject=$subject&body=$body",
    );

    try {
      if (await canLaunchUrl(mailtoUri)) {
        await launchUrl(mailtoUri);

        // Clear fields
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open email client")),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _UnderlineTextField(label: "Name", controller: _nameController),
        const SizedBox(height: 30),
        _UnderlineTextField(label: "Email", controller: _emailController),
        const SizedBox(height: 30),
        _UnderlineTextField(label: "Message", controller: _messageController),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _sendEmail,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800], // Dark grey button
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rectangular button
              ),
              elevation: 0,
            ),
            child: const Text("Send"),
          ),
        ),
      ],
    );
  }
}

class _ContactInfo extends StatelessWidget {
  const _ContactInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const _InfoBlock(
          title: "Let's talk",
          content: "+91 813 987 3878\nfawasrahim986@gmail.com",
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            _SocialIcon(
              icon: FontAwesomeIcons.whatsapp,
              url: 'https://wa.me/+918139873878',
              tooltip: 'WhatsApp',
            ),
            const SizedBox(width: 20),
            _SocialIcon(
              icon: FontAwesomeIcons.linkedinIn,
              url: "https://www.linkedin.com/in/fawas-rahim/",
              tooltip: 'LinkedIn',
            ),
            const SizedBox(width: 20),
            _SocialIcon(
              icon: FontAwesomeIcons.instagram,
              url: "https://www.instagram.com/thakku_z/?hl=en",
              tooltip: 'Instagram',
            ),
            const SizedBox(width: 20),
            _SocialIcon(
              icon: FontAwesomeIcons.github,
              url: "https://github.com/fawas986",
              tooltip: 'GitHub',
            ),
          ],
        ),
      ],
    );
  }
}

class _UnderlineTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller; // Added controller
  const _UnderlineTextField({required this.label, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, // Used controller
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .5),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .3),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        contentPadding: const EdgeInsets.only(bottom: 10),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final String content;
  const _InfoBlock({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .7),
            height: 1.5,
          ),
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
      child: InkWell(
        onTap: () async {
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url));
          }
        },
        child: Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
