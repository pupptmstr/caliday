import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/achievement_l10n.dart';
import '../../../core/extensions/build_context_l10n.dart';
import '../../../data/repositories/achievement_repository.dart';
import '../../../data/static/achievement_catalog.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(achievementRepositoryProvider);
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;

    final earnedMap = repo.getAllEarned();
    final earnedIds = repo.getAllEarnedIds(); // newest-first
    final lockedAll = AchievementCatalog.all
        .where((a) => !earnedMap.containsKey(a.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.achievementsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // ── Earned ──────────────────────────────────────────────────────
          if (earnedIds.isNotEmpty) ...[
            _SectionHeader(
              title: '${l10n.achievementsEarnedSection} (${earnedIds.length})',
            ),
            const SizedBox(height: 8),
            ...earnedIds.map((id) {
              final a = AchievementCatalog.byId(id)!;
              final earnedAt = earnedMap[id]!;
              final dateStr = DateFormat('d MMMM yyyy', locale).format(earnedAt);
              return _AchievementTile(
                achievement: a,
                subtitle: l10n.achievementsEarnedOn(dateStr),
                earned: true,
                onTap: () => _showSheet(context, a, dateStr, l10n),
              );
            }),
            const SizedBox(height: 20),
          ],

          // ── Locked ──────────────────────────────────────────────────────
          if (lockedAll.isNotEmpty) ...[
            _SectionHeader(title: l10n.achievementsLockedSection),
            const SizedBox(height: 8),
            ...lockedAll.map((a) {
              final isSecret = a.isSecret;
              return _AchievementTile(
                achievement: a,
                subtitle: isSecret ? '' : AchievementL10n.desc(l10n, a.id),
                earned: false,
                onTap: isSecret
                    ? () => _showSecretSheet(context, l10n)
                    : () => _showSheet(context, a, null, l10n),
              );
            }),
          ],
        ],
      ),
    );
  }

  void _showSheet(
    BuildContext context,
    Achievement a,
    String? dateStr,
    dynamic l10n,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(a.emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              AchievementL10n.name(l, a.id),
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AchievementL10n.desc(l, a.id),
              style: TextStyle(
                fontSize: 15,
                color: scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (dateStr != null) ...[
              const SizedBox(height: 8),
              Text(
                l.achievementsEarnedOn(dateStr),
                style: TextStyle(
                  fontSize: 13,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSecretSheet(BuildContext context, dynamic l10n) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔒', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              l.achievementsSecret,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l.achievementsSecretDesc,
              style: TextStyle(
                fontSize: 15,
                color: scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleSmall
          ?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

// ── Achievement tile ──────────────────────────────────────────────────────────

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({
    required this.achievement,
    required this.subtitle,
    required this.earned,
    required this.onTap,
  });

  final Achievement achievement;
  final String subtitle;
  final bool earned;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.l10n;
    final isHiddenSecret = achievement.isSecret && !earned;

    final emoji = isHiddenSecret ? '🔒' : achievement.emoji;
    final title =
        isHiddenSecret ? l.achievementsSecret : AchievementL10n.name(l, achievement.id);
    final desc = isHiddenSecret
        ? ''
        : (subtitle.isNotEmpty
            ? subtitle
            : AchievementL10n.desc(l, achievement.id));

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: earned
              ? scheme.primaryContainer
              : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: earned ? null : scheme.onSurfaceVariant,
        ),
      ),
      subtitle: desc.isNotEmpty
          ? Text(
              desc,
              style: TextStyle(
                fontSize: 12,
                color: scheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      onTap: onTap,
    );
  }
}
