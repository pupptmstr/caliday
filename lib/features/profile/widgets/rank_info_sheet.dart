import 'package:flutter/material.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/enums.dart';

/// Shows the rank-info bottom sheet used on both Home and Profile screens.
///
/// [earnedRank] — the SP-based rank the user has actually achieved.
/// [effectiveRank] — the currently displayed rank (may be lower due to decay).
/// [totalSP] — for highlighting which thresholds have been crossed.
void showRankInfoSheet(
  BuildContext context, {
  required Rank earnedRank,
  required Rank effectiveRank,
  required int totalSP,
  int daysSinceLastWorkout = 0,
}) {
  final scheme = Theme.of(context).colorScheme;
  final l10n = context.l10n;
  final isDecayed = effectiveRank.index < earnedRank.index;

  showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text(
            l10n.tooltipRankTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          ...Rank.values.map((rank) {
            final isEarned = totalSP >= rank.spThreshold;
            final isCurrent = rank == earnedRank;
            final isEffective = rank == effectiveRank;
            final isDecayTarget = isDecayed && isEffective;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDecayTarget
                          ? Colors.amber.shade600
                          : isCurrent
                              ? AppTheme.brandBlue
                              : isEarned
                                  ? AppTheme.success
                                  : scheme.outlineVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      rank.localizedName(l10n),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: (isCurrent || isDecayTarget)
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: (isCurrent || isDecayTarget)
                            ? scheme.onSurface
                            : isEarned
                                ? scheme.onSurface
                                : scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Text(
                    '${rank.spThreshold} SP',
                    style: TextStyle(
                      fontSize: 13,
                      color: isCurrent
                          ? AppTheme.brandBlue
                          : isDecayTarget
                              ? Colors.amber.shade600
                              : scheme.onSurfaceVariant,
                      fontWeight: (isCurrent || isDecayTarget)
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }),
          if (isDecayed) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.amber.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.withAlpha(60)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      size: 18, color: Colors.amber.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.rankDecayWarning(daysSinceLastWorkout),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}