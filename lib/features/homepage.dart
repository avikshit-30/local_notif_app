import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:local_notif_app/constants/assets.dart';

import 'package:local_notif_app/features/scheduling_formatting.dart';
import 'package:local_notif_app/features/upcoming_menu.dart';
import 'package:local_notif_app/utils/logger.dart';

import '../config_api/config_repo.dart';
import '../constants/textstyles.dart';
import '../secure_storage_service.dart';
import 'instructions.dart';

int getDefaultImageIndex() {
  final now = DateTime.now();
  final hour = now.hour;

  if (hour < 8) {
    return 0; // Morning
  } else if (hour < 16) {
    return 1; // Afternoon
  } else {
    return 2; // Evening
  }
}

final index = StateProvider<int>((ref) => -1);
final isInstrToggle = StateProvider<bool>((ref) => false);

final currentHourProvider = StateProvider<DateTime>((ref) => DateTime(2023));
final upcomingProvider = StateProvider<bool>((ref) => false);

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.watch(index.notifier).state = getDefaultImageIndex();
      ref.watch(currentHourProvider.notifier).state = now;
      var repo = ref.watch(configRepoProvider);
      repo.execute();
      if (await ref.watch(secureStorageServiceProvider).hasKey("value")) {
        ref.watch(isSelectedProvider.notifier).state =
            await ref.read(secureStorageServiceProvider).read("value");
        return;
      } else {
        ref.watch(secureStorageServiceProvider).write("value", "no");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 30,
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.grey[900],
        color: Colors.white,
        onRefresh: () async {
          DateTime now = DateTime.now();
          await Future.delayed(const Duration(seconds: 2));
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            ref.watch(index.notifier).state = getDefaultImageIndex();
            ref.watch(currentHourProvider.notifier).state = now;
            var repo = ref.watch(configRepoProvider);
            repo.execute();
          });
        },
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbColor:
                MaterialStateProperty.all(Colors.teal), // Change thumb color
            trackColor: MaterialStateProperty.all(
                Colors.transparent), // Change track color
            thickness:
                MaterialStateProperty.all(1.0), // Change scrollbar thickness
            radius: const Radius.circular(4.0), // Change scrollbar radius
          ),
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              child: Column(
                children: [
                  ScreenMain(ref: ref),
                  GestureDetector(
                    onDoubleTap: () => userLog('wow, such starry'),
                    child: Container(
                        height: ref.watch(isInstrToggle) ? 150 : 500,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          image: DecorationImage(
                            image: AssetImage(PngAssets
                                .bg), // Replace with your image file path
                            fit: BoxFit.cover, // Adjust the BoxFit as needed
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 6,
                              ),
                              Center(
                                child: Text('made with hate by',
                                    style: w400.size14.colorWhite),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () => userLog('quack'),
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius:
                                              25.0, // Adjust the radius as needed
                                          backgroundImage:
                                              AssetImage(PngAssets.squeakydp),
                                        ),
                                      ),
                                      const SizedBox(height: 6.0),
                                      GestureDetector(
                                        onTap: () => userLog('quack'),
                                        child: Text(
                                          'squeaky',
                                          style: w500.size14.colorWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            userLog('Bruder, bitte lies jetzt'),
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius:
                                              25.0, // Adjust the radius as needed
                                          backgroundImage:
                                              AssetImage(PngAssets.dubeydp),
                                        ),
                                      ),
                                      const SizedBox(height: 6.0),
                                      GestureDetector(
                                        onTap: () =>
                                            userLog('Bruder, bitte lies jetzt'),
                                        child: Text('badmeister',
                                            style: w500.size14.colorWhite),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                  'ps: hate for the mess food sweetie not for you💞💞💖',
                                  style: w500.size12.copyWith(
                                      color: Colors.white.withOpacity(0.5))),
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenMain extends StatelessWidget {
  const ScreenMain({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'Pull to refresh screen',
            style: w400.size12.copyWith(color: Colors.grey.withOpacity(0.7)),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ref.watch(upcomingProvider) ? UpcomingMenu() : Container(),
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 0, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1.0,
                height: 0.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Mess Notifications',
                    style: w400.size24.copyWith(color: Colors.white),
                  ),
                  Spacer(),
                  ref.watch(isInstrToggle)
                      ? GestureDetector(
                          onTap: () => ref
                              .watch(isInstrToggle.notifier)
                              .update((state) => !state),
                          child: Icon(
                            Icons.arrow_drop_up_outlined,
                            color: Colors.red,
                            size: 40,
                          ),
                        )
                      : GestureDetector(
                          onTap: () => ref
                              .watch(isInstrToggle.notifier)
                              .update((state) => !state),
                          child: Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Colors.teal,
                            size: 40,
                          ),
                        ),
                ],
              ),
              ref.watch(isInstrToggle)
                  ? SizedBox(
                      height: 10,
                    )
                  : Container(),
              ref.watch(isInstrToggle) ? Instructions() : Container(),
              const SizedBox(
                height: 30,
              ),
              const Center(child: ScheduleBtn()),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
