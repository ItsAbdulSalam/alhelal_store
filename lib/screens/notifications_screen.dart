import 'package:first_store/bloc/notifications/notifications_bloc.dart';
import 'package:first_store/models/notification_model.dart';
import 'package:first_store/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // جلب الإشعارات فور فتح الصفحة لضمان مزامنة البيانات مع Firestore
    context.read<NotificationsBloc>().add(LoadNotifications());
  }

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
          // زر "قراءة الكل" يظهر فقط في حال وجود إشعارات غير مقروءة
          BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              if (state.notifications.isEmpty || state.unreadCount == 0) {
                return const SizedBox.shrink();
              }

              return TextButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  context.read<NotificationsBloc>().add(MarkAllAsRead());
                },
                child: Text(
                  'قراءة الكل',
                  style: TextStyle(
                    color: c.gold,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
          const Gap(10),
        ],
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state.isLoading && state.notifications.isEmpty) {
            return Center(child: CircularProgressIndicator(color: c.gold));
          }

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
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  ...group.items.map((n) => _NotificationTile(notif: n, c: c)),
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
      if (_isSameDay(n.createdAt, now)) {
        today.add(n);
      } else if (_isSameDay(n.createdAt, yesterday)) {
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

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notif;
  final AppColors c;
  const _NotificationTile({required this.notif, required this.c});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft, // تم التعديل ليتناسب مع اتجاه السحب
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.redAccent,
        ),
      ),
      onDismissed: (_) {
        HapticFeedback.lightImpact();
        context.read<NotificationsBloc>().add(DeleteNotification(notif.id));
      },
      child: InkWell(
        onTap: () {
          if (!notif.isRead) {
            context.read<NotificationsBloc>().add(MarkAsRead(notif.id));
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notif.isRead ? c.surface : c.gold.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notif.isRead ? c.border : c.gold.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: notif.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(notif.icon, color: notif.color, size: 20),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notif.title,
                            style: TextStyle(
                              color: c.textPrimary,
                              fontWeight: notif.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (!notif.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: c.gold,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const Gap(6),
                    Text(
                      notif.body,
                      style: TextStyle(
                        color: c.textSecondary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      notif.timeAgo,
                      style: TextStyle(
                        color: c.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotifGroup {
  final String label;
  final List<AppNotification> items;
  const _NotifGroup(this.label, this.items);
}

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
            color: c.textMuted.withOpacity(0.3),
          ),
          const Gap(16),
          Text(
            'لا توجد إشعارات حالياً',
            style: TextStyle(
              color: c.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
