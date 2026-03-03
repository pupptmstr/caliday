import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/extensions/build_context_l10n.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            // ── Hero block ────────────────────────────────────────────────
            const SizedBox(height: 16),
            Center(
              child: SvgPicture.asset(
                'assets/goro/goro_idle_v2.svg',
                height: 120,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'CaliDay',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                '1.1.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Support section ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                l10n.aboutSectionSupport,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: scheme.primary,
                ),
              ),
            ),
            _AboutTile(
              title: l10n.aboutContactUs,
              subtitle: l10n.aboutContactUsSubtitle,
              icon: Icons.email_outlined,
              url: 'mailto:kurnyakov.petr@gmail.com',
            ),
            const Divider(indent: 20, endIndent: 20, height: 1),
            _AboutTile(
              title: l10n.aboutPrivacyPolicy,
              icon: Icons.privacy_tip_outlined,
              url: 'https://caliday.app/privacy',
            ),

            // ── Built with section ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                l10n.aboutBuiltWith,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: scheme.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(
                'Flutter · Riverpod · Hive · go_router',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Copyright ─────────────────────────────────────────────────
            Center(
              child: Text(
                l10n.aboutCopyright,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _AboutTile extends StatelessWidget {
  const _AboutTile({
    required this.title,
    required this.icon,
    required this.url,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            )
          : null,
      trailing: const Icon(Icons.open_in_new_rounded),
      onTap: () async {
        try {
          await launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
          );
        } catch (_) {}
      },
    );
  }
}
