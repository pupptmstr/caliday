import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/static/release_notes_catalog.dart';
import '../providers/whats_new_provider.dart';

/// "What's new": the newest [ReleaseNotesCatalog.recentCount] versions in full,
/// newest first, with a NEW tag on the entries the user had not seen before
/// opening it; under them the whole history, one card per line of versions
/// (0.9, 0.8 … 0.1) with its main points, folded until tapped.
class WhatsNewScreen extends ConsumerStatefulWidget {
  const WhatsNewScreen({super.key});

  @override
  ConsumerState<WhatsNewScreen> createState() => _WhatsNewScreenState();
}

class _WhatsNewScreenState extends ConsumerState<WhatsNewScreen> {
  /// Which entries were new when the screen opened. Fixed here, because
  /// opening marks them as seen and the tags must not vanish under the eyes.
  late final Set<String> _newVersions;

  bool _historyOpen = false;

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

  static List<String> _lines(String text) =>
      text.split('\n').where((s) => s.trim().isNotEmpty).toList();

  /// "October 2026", "May – October 2026", "December 2025 – January 2026".
  static String _span(DateTime from, DateTime to, String locale) {
    final end = DateFormat.yMMMM(locale).format(to);
    if (from.year == to.year && from.month == to.month) return end;
    final start = from.year == to.year
        ? DateFormat('LLLL', locale).format(from)
        : DateFormat.yMMMM(locale).format(from);
    return '$start – $end';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.whatsNewTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _SectionHeader(l10n.whatsNewRecent),
            for (final note in ReleaseNotesCatalog.recent) ...[
              _ReleaseCard(
                version: l10n.whatsNewVersion(note.version),
                date: DateFormat.yMMMMd(locale).format(note.date),
                lines: _lines(note.text(l10n)),
                isNew: _newVersions.contains(note.version),
                isDark: isDark,
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => _historyOpen = !_historyOpen),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(child: _SectionHeader(l10n.whatsNewHistory, padded: false)),
                    AnimatedRotation(
                      turns: _historyOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(Icons.expand_more, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
            if (_historyOpen)
              for (final line in ReleaseNotesCatalog.lines) ...[
                const SizedBox(height: 12),
                _ReleaseCard(
                  version: l10n.whatsNewVersion(line.version),
                  date: _span(line.from, line.to, locale),
                  lines: _lines(line.text(l10n)),
                  isNew: false,
                  isDark: isDark,
                  bullet: Icons.circle,
                ),
              ],
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title, {this.padded = true});

  final String title;
  final bool padded;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
    return padded
        ? Padding(padding: const EdgeInsets.fromLTRB(4, 4, 4, 10), child: text)
        : Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: text);
  }
}

class _ReleaseCard extends StatelessWidget {
  const _ReleaseCard({
    required this.version,
    required this.date,
    required this.lines,
    required this.isNew,
    required this.isDark,
    this.bullet = Icons.check_rounded,
  });

  /// The title, e.g. "Version 0.9.3".
  final String version;
  final String date;
  final List<String> lines;
  final bool isNew;
  final bool isDark;

  /// A check mark for a release, a dot for a main point of a line.
  final IconData bullet;

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
                  version,
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
                    padding: EdgeInsets.only(
                        top: bullet == Icons.circle ? 6 : 2,
                        left: bullet == Icons.circle ? 4 : 0,
                        right: bullet == Icons.circle ? 4 : 0),
                    child: Icon(bullet,
                        size: bullet == Icons.circle ? 7 : 16,
                        color: AppTheme.brandBlue),
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
