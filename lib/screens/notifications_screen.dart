import 'package:first_store/bloc/notifications/notifications_bloc.dart';
import 'package:first_store/models/notification_model.dart';
import 'package:first_store/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppBar(
        backgroundColor: c.bg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الإشعارات',
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: c.textPrimary,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocBuilder<NotificationsBloc, NotificationsState>(
            buildWhen: (prev, curr) =>
                prev.unreadCount != curr.unreadCount,
            builder: (context, state) {
              if (state.unreadCount == 0) {
                return const SizedBox.shrink();
              }
              return TextButton(
                onPressed: () => context
                    .read<NotificationsBloc>()
                    .add(const MarkAllAsRead()),
                child: Text(
                  'قراءة الكل',
                  style: TextStyle(
                    color: c.gold,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state.notifications.isEmpty) {
            return _EmptyState(c: c);
          }

          final groups = _groupByDay(state.notifications);

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: groups.length,
            itemBuilder: (_, i) {
              final group = groups[i];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 4,
                    ),
                    child: Text(
                      group.label,
                      style: TextStyle(
                        color: c.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  ...group.items.map(
                    (n) => _NotificationTile(notif: n, c: c),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<_NotifGroup> _groupByDay(List<AppNotification> items) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    final today = <AppNotification>[];
    final yest = <AppNotification>[];
    final older = <AppNotification>[];

    for (final n in items) {
      if (_sameDay(n.createdAt, now)) {
        today.add(n);
      } else if (_sameDay(n.createdAt, yesterday)) {
        yest.add(n);
      } else {
        older.add(n);
      }
    }

    return [
      if (today.isNotEmpty) _NotifGroup('اليوم', today),
      if (yest.isNotEmpty) _NotifGroup('أمس', yest),
      if (older.isNotEmpty) _NotifGroup('سابقاً', older),
    ];
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

// ── Group Model ──────────────────────────────────────────
class _NotifGroup {
  final String label;
  final List<AppNotification> items;
  const _NotifGroup(this.label, this.items);
}

// ── Empty State ──────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final AppColors c;
  const _EmptyState({required this.c});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 72,
            color: c.textMuted,
          ),
          const Gap(16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              color: c.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(8),
          Text(
            'ستظهر هنا إشعارات طلباتك وعروضك',
            style: TextStyle(color: c.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ── Notification Tile ────────────────────────────────────
class _NotificationTile extends StatefulWidget {
  final AppNotification notif;
  final AppColors c;
  const _NotificationTile({required this.notif, required this.c});

  @override
  State<_NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<_NotificationTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final n = widget.notif;
    final c = widget.c;

    return Dismissible(
      key: Key(n.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: c.error,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
      onDismissed: (_) {
        HapticFeedback.lightImpact();
        context
            .read<NotificationsBloc>()
            .add(DeleteNotification(n.id));
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          if (!n.isRead) {
            context
                .read<NotificationsBloc>()
                .add(MarkAsRead(n.id));
          }
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: n.isRead
                  ? c.surface
                  : c.gold.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: n.isRead
                    ? c.border
                    : c.gold.withOpacity(0.25),
                width: 0.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: n.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(n.icon, color: n.color, size: 18),
                ),
                const Gap(12),
                // النص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              n.title,
                              style: TextStyle(
                                color: c.textPrimary,
                                fontWeight: n.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          if (!n.isRead)
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: c.gold,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const Gap(4),
                      Text(
                        n.body,
                        style: TextStyle(
                          color: c.textSecondary,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                      const Gap(6),
                      Text(
                        n.timeAgo,
                        style: TextStyle(
                          color: c.textMuted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}