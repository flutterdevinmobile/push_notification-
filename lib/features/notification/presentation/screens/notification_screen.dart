import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/models/notification_model.dart';
import '../../domain/payloads/notification_payload.dart';
import '../blocs/notification_bloc/notification_bloc.dart';
import '../blocs/notification_bloc/notification_event.dart';
import '../blocs/notification_bloc/notification_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Ekranga kirganda notificationlarni chaqiramiz
    context.read<NotificationBloc>().add(
          NotificationStarted(
            // bu yerda sizning payload ketadi
            // misol uchun target = "userId123"
            // agar sizda FCM user id bo‘lsa, shuni yuborasiz
            const NotificationPayload(target: "all"),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Уведомления",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              final notifications = state.notifications;

              if (notifications.isEmpty) {
                return const Center(child: Text("Нет уведомлений"));
              }

              return ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (_, __) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Divider(color: const Color(0xffD9D9D9), height: 1.h),
                ),
                itemBuilder: (context, index) {
                  final NotificationModel item = notifications[index];
                  final bool isNew = !(item.readBy["userId123"] ?? false);
                  // ⚠️ bu yerda `userId` sizning auth qismidan olinadi

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (isNew) ...[
                            Icon(Icons.circle,
                                color: const Color(0xff23A58A), size: 8.sp),
                            6.horizontalSpace,
                          ],
                          Expanded(
                            child: Text(
                              item.title,
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
                          Text(
                            item.body,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 14),
                          ),
                          8.verticalSpace,
                          Text(
                            item.date
                                .toString(), // yoki formatlab chiqarish mumkin
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontSize: 12.sp),
                          ),
                        ],
                      ),
                      onTap: () {
                        // bosilganda read qilib qo‘yish
                        context.read<NotificationBloc>().add(
                              NotificationMarkedAsRead(
                                notificationId: item.id,
                                fcmNumber: "userId123", // sizning user token/id
                              ),
                            );
                      },
                    ),
                  );
                },
              );
            } else if (state is NotificationError) {
              return Center(child: Text("Ошибка: ${state.message}"));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
