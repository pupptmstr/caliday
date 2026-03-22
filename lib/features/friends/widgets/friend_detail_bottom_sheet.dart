import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/friend_profile.dart';
import '../providers/friends_provider.dart';

void showFriendDetail(
  BuildContext context,
  FriendProfile friend,
  WidgetRef ref,
) {
  final locale = Localizations.localeOf(context).languageCode;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _FriendDetailSheet(
      friend: friend,
      ref: ref,
      locale: locale,
    ),
  );
}

class _FriendDetailSheet extends StatelessWidget {
  const _FriendDetailSheet({
    required this.friend,
    required this.ref,
    required this.locale,
  });

  final FriendProfile friend;
  final WidgetRef ref;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final rank =
        Rank.values.elementAtOrNull(friend.rankIndex) ?? Rank.beginner;
    final dateStr =
        DateFormat('d MMMM yyyy', locale).format(friend.lastSynced);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name + rank badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    friend.displayName,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    rank.localizedName(l10n),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: scheme.onPrimaryContainer,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stats row
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatChip(
                    icon: Icons.bolt_rounded, value: '${friend.totalSP} SP'),
                _StatChip(
                  icon: Icons.local_fire_department_rounded,
                  value: '${friend.currentStreak}',
                  label: l10n.profileStatDays,
                ),
                _StatChip(
                  icon: Icons.emoji_events_rounded,
                  value: '${friend.longestStreak}',
                  label: l10n.profileStatRecord,
                ),
              ],
            ),

            // Branch stages
            if (friend.branchStages.isNotEmpty) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: friend.branchStages.entries.map((e) {
                  final branch = BranchId.values
                      .where((b) => b.name == e.key)
                      .firstOrNull;
                  if (branch == null) return const SizedBox.shrink();
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(branch.icon, size: 16, color: scheme.primary),
                        const SizedBox(width: 6),
                        Text(
                          'S${e.value}',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 14),
            Text(
              l10n.friendsDetailLastSynced(dateStr),
              style:
                  TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),

            // Remove button
            OutlinedButton.icon(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.friendsDeleteTitle),
                    content: Text(l10n.friendsDeleteBody(friend.displayName)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text(l10n.friendsCancel),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: scheme.error),
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text(l10n.friendsDeleteConfirm),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await ref.read(friendsProvider.notifier).remove(friend.id);
                  if (context.mounted) Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.person_remove_outlined),
              label: Text(l10n.friendsDeleteTitle),
              style:
                  OutlinedButton.styleFrom(foregroundColor: scheme.error),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.value, this.label});

  final IconData icon;
  final String value;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: scheme.primary),
          const SizedBox(width: 4),
          Text(
            label != null ? '$value $label' : value,
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}