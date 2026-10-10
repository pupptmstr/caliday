import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/extensions/achievement_l10n.dart';
import '../../../core/extensions/build_context_l10n.dart';
import '../../../data/models/enums.dart';
import '../../../data/static/achievement_catalog.dart';
import '../../../data/static/course_catalog.dart';

/// The course whose host presents [a]: a branch achievement belongs to its
/// branch's course ([active] when it holds the branch); the others belong to
/// the app itself and get null.
CourseId? achievementCourse(Achievement a, CourseId? active) =>
    a.branch == null ? null : CourseCatalog.courseOf(a.branch!, active: active);

/// An achievement's emoji on one line: the rank ones are two or three stars
/// and would otherwise wrap inside their square.
class AchievementEmoji extends StatelessWidget {
  const AchievementEmoji(this.emoji, {super.key, required this.size});

  final String emoji;
  final double size;

  @override
  Widget build(BuildContext context) => FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(emoji, maxLines: 1, style: TextStyle(fontSize: size)),
      );
}

/// The achievement sheet of the Achievements screen and the Profile badges.
///
/// The host of [a]'s course presents it (Goro for the app's own
/// achievements): cheering once earned ([earnedOn] set), holding a grey
/// medal with a padlock while still ahead.
void showAchievementSheet(
  BuildContext context,
  Achievement a, {
  required CourseId? active,
  String? earnedOn,
}) {
  final scheme = Theme.of(context).colorScheme;
  final l = context.l10n;
  final host = achievementCourse(a, active) ?? CourseId.calisthenics;
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
          SvgPicture.asset(
            earnedOn != null ? host.hostCheer : host.hostLocked,
            height: 120,
          ),
          const SizedBox(height: 12),
          AchievementEmoji(a.emoji, size: 36),
          const SizedBox(height: 8),
          Text(
            AchievementL10n.name(l, a.id),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AchievementL10n.desc(l, a.id),
            style: TextStyle(fontSize: 15, color: scheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          if (earnedOn != null) ...[
            const SizedBox(height: 8),
            Text(
              l.achievementsEarnedOn(earnedOn),
              style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    ),
  );
}
