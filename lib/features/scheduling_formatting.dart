import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:local_notif_app/features/homepage.dart';
import 'package:local_notif_app/utils/api_state_folder.dart';
import 'package:local_notif_app/utils/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config_api/config_repo.dart';
import '../constants/textstyles.dart';
import '../notif_service.dart';
import '../secure_storage_service.dart';

// DateTime scheduleTime = DateTime.parse('2023-09-27 08:42:00');

class ScheduleBtn extends ConsumerStatefulWidget {
  const ScheduleBtn({
    super.key,
  });

  @override
  ConsumerState<ScheduleBtn> createState() => _ScheduleBtnState();
}

class _ScheduleBtnState extends ConsumerState<ScheduleBtn> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var configrepo = ref.watch(configRepoProvider);

    return ApiStateFolder(
        repos: [configrepo],
        buildLoaded: () {
          int length = configrepo.currentResult!.length;
          if (convertStringToDateTime(
                  configrepo.currentResult![length - 1].date)
              .isBefore(DateTime.now())) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              // ref.watch(upcomingProvider.notifier).state = false;
              ref.watch(isSelectedProvider.notifier).state = "no";
              ref.watch(secureStorageServiceProvider).write("value", "no");
            });

            return Column(
              children: [
                Text(
                  'New menu has not been updated. Pls check again after some time.',
                  style: w400.size12.copyWith(color: Colors.yellow),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  width: 220,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(45)),
                  child: Center(
                    child: Text(
                      'Turn On notifications',
                      style: w400.size14.colorWhite,
                    ),
                  ),
                ),
              ],
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ref.watch(upcomingProvider.notifier).state = true;
            });

            return ref.watch(isSelectedProvider) == "yes"
                ? GestureDetector(
                    onTap: () {
                      userLog('Already Scheduled');
                    },
                    child: Container(
                        height: 45,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.teal),
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: Text(
                            'Scheduled',
                            style: w400.size14.colorWhite,
                          ),
                        )),
                  )
                : GestureDetector(
                    onTap: () {
                      ref.watch(isSelectedProvider.notifier).state = "yes";
                      ref
                          .watch(secureStorageServiceProvider)
                          .write("value", "yes");
                      int l = configrepo.currentResult!.length;
                      DateTime startDateTime = convertStringToDateTime(
                              configrepo.currentResult![0].date)
                          .subtract(const Duration(days: 1));
                      DateTime endDateTime = convertStringToDateTime(
                          configrepo.currentResult![l - 1].date);

                      //print(startDateTime.toString() + endDateTime.toString());
                      int index = 0;
                      int mealId = 0;
                      for (DateTime date = startDateTime;
                          date.isBefore(endDateTime);
                          date = date.add(const Duration(days: 1))) {
                        DateTime bfscheduleTime = DateTime(
                            date.year, date.month, date.day, 00, 01, 00);
                        DateTime lscheduleTime = DateTime(
                            date.year, date.month, date.day, 11, 07, 00);
                        DateTime dscheduleTime = DateTime(
                            date.year, date.month, date.day, 17, 37, 0);
                        DateTime endNotifTime = DateTime(
                            date.year, date.month, date.day, 23, 59, 59);
                        NotificationService()
                            .scheduleNotification(
                                id: mealId,
                                title: 'Breakfast',
                                body: configrepo.currentResult![index].breakfast
                                    .skip(3)
                                    .toList()
                                    .toString()
                                    .replaceAll('[', '')
                                    .replaceAll(']', '')
                                    .toLowerCase(),
                                scheduledNotificationDateTime: bfscheduleTime)
                            .then((value) => print('${bfscheduleTime}hh'));
                        //         date.add(Duration(minutes: 1)))
                        // .then((value) => debugPrint(('scheduled for' +
                        //     date.add(Duration(minutes: 1)).toString())));

                        NotificationService()
                            .scheduleNotification(
                                id: ++mealId,
                                title: 'Lunch',
                                body: configrepo.currentResult![index].lunch
                                    .toString()
                                    .replaceAll('[', '')
                                    .replaceAll(']', '')
                                    .toLowerCase(),
                                scheduledNotificationDateTime: lscheduleTime)
                            .then((value) => print('${lscheduleTime}hh'));

                        NotificationService()
                            .scheduleNotification(
                                id: ++mealId,
                                title: 'Dinner',
                                body: configrepo.currentResult![index].dinner
                                    .toString()
                                    .replaceAll('[', '')
                                    .replaceAll(']', '')
                                    .toLowerCase(),
                                scheduledNotificationDateTime: dscheduleTime)
                            .then((value) {
                          print('${dscheduleTime}hh');
                        });
                        if (date.isAtSameMomentAs(
                            endDateTime.subtract(const Duration(days: 1)))) {
                          NotificationService().scheduleNotification(
                              id: ++mealId,
                              title: 'Cycle Complete!',
                              body:
                                  'Pls return to the app and click the button to schedule notifs for the next cycle.',
                              scheduledNotificationDateTime: endNotifTime);
                        }
                        index++;
                        mealId++;
                      }

                      userLog('Notification Scheduled Successfully');
                    },
                    child: Container(
                      height: 60,
                      width: 220,
                      decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(45)),
                      child: Center(
                        child: Text(
                          'Turn On notifications',
                          style: w400.size14.colorWhite,
                        ),
                      ),
                    ),
                  );
          }
        });
    // NotificationService().scheduleNotification(
    //     title: 'Scheduled Notification',
    //     body: '$scheduleTime',
    //     scheduledNotificationDateTime: scheduleTime);
  }
}

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('dd/MM/yy HH:mm:ss');
  return formatter.format(dateTime);
}

String formatTodayDate() {
  DateTime now = DateTime.now();
  String year = (now.year % 100).toString().padLeft(2, '0');
  String month = DateFormat('MMM').format(now);
  String day = now.day.toString().padLeft(2, '0');
  print('ttttttttttt$day-$month-$year');
  return '$day-$month-$year';
}

DateTime convertStringToDateTime(String dateString) {
  final DateFormat format = DateFormat('dd-MMM-yy');
  final DateTime dateTime = format.parse(dateString);
  print('Original DateTime: $dateTime');

  final DateTime increasedDateTime = dateTime.add(const Duration(days: 1));
  print('Increased DateTime: $increasedDateTime');

  return increasedDateTime;
}

final isSelectedProvider = StateProvider<String>((ref) => "no");
