import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../providers/whats_new_provider.dart';

/// The bell in the Profile app bar: opens "What's new", with a dot while there
/// is an entry the user has not opened yet.
class WhatsNewBell extends ConsumerWidget {
  const WhatsNewBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Badge(
        smallSize: 9,
        isLabelVisible: ref.watch(hasUnseenReleaseNotesProvider),
        child: const Icon(Icons.notifications_none_rounded),
      ),
      tooltip: context.l10n.whatsNewTitle,
      onPressed: () => context.push('/whats-new'),
    );
  }
}
