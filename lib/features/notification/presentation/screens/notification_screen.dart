import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../models/push_notification_model.dart';
import '../../../../services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();
  void getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM TOKEN: $token");
  }

  String formatDate(DateTime date) {
    return DateFormat("dd.MM.yyyy HH:mm").format(date);
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    final box = _notificationService.box;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Уведомления",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await _notificationService.clearAll();
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<PushNotificationModel> box, _) {
            final notifications = box.values.toList()
              ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

            if (notifications.isEmpty) {
              return Center(
                child: Text(
                  "Уведомлений пока нет",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            return ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (_, __) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Divider(color: const Color(0xffD9D9D9), height: 1.h),
              ),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () async {
                      await _notificationService.markAsRead(item.id);
                    },
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (!item.isRead) ...[
                          Icon(
                            Icons.circle,
                            color: const Color(0xff23A58A),
                            size: 8.sp,
                          ),
                          6.horizontalSpace,
                        ],
                        Expanded(
                          child: Text(
                            item.title ?? "Без названия",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.body != null)
                          Text(
                            item.body!,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                          ),
                        8.verticalSpace,
                        Text(
                          formatDate(item.timestamp),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(fontSize: 12.sp),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        await _notificationService.delete(item.id);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
