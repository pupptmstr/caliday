import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/static/release_notes_catalog.dart';
import '../providers/whats_new_provider.dart';

/// "What's new": the history of what changed in each version, newest first,
/// with a NEW tag on the entries the user had not seen before opening it.
class WhatsNewScreen extends ConsumerStatefulWidget {
  const WhatsNewScreen({super.key});

  @override
  ConsumerState<WhatsNewScreen> createState() => _WhatsNewScreenState();
}

class _WhatsNewScreenState extends ConsumerState<WhatsNewScreen> {
  /// Which entries were new when the screen opened. Fixed here, because
  /// opening marks them as seen and the tags must not vanish under the eyes.
  late final Set<String> _newVersions;

  @override
  void initState() {
    super.initState();
    _newVersions = {
      for (final n
          in ReleaseNotesCatalog.unseenSince(ref.read(seenReleaseVersionProvider)))
        n.version,
    };
    // After the first frame: a provider must not change while the tree builds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(seenReleaseVersionProvider.notifier).markSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.whatsNewTitle)),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: ReleaseNotesCatalog.all.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final note = ReleaseNotesCatalog.all[i];
            return _ReleaseCard(
              version: note.version,
              date: DateFormat.yMMMMd(locale).format(note.date),
              lines: note.text(l10n).split('\n').where((s) => s.trim().isNotEmpty).toList(),
              isNew: _newVersions.contains(note.version),
              isDark: isDark,
            );
          },
        ),
      ),
    );
  }
}

class _ReleaseCard extends StatelessWidget {
  const _ReleaseCard({
    required this.version,
    required this.date,
    required this.lines,
    required this.isNew,
    required this.isDark,
  });

  final String version;
  final String date;
  final List<String> lines;
  final bool isNew;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark ? AppTheme.cardShadowDark : AppTheme.cardShadowLight,
        border: isNew
            ? Border.all(color: AppTheme.brandBlue.withAlpha(140), width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.whatsNewVersion(version),
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
              ),
              if (isNew)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.brandBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.whatsNewBadge,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(Icons.check_rounded, size: 16, color: AppTheme.brandBlue),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(line, style: const TextStyle(fontSize: 14, height: 1.35))),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
