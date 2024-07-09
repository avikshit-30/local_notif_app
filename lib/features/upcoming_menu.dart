import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_notif_app/constants/assets.dart';
import 'package:local_notif_app/features/scheduling_formatting.dart';
import 'package:local_notif_app/utils/api_state_folder.dart';
import 'package:recase/recase.dart';

import '../config_api/config_model.dart';
import '../config_api/config_repo.dart';
import '../constants/textstyles.dart';
import 'homepage.dart';

class UpcomingMenu extends ConsumerWidget {
  UpcomingMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var configRepo = ref.watch(configRepoProvider);
    return ApiStateFolder(
        repos: [configRepo],
        buildLoaded: () {
          ConfigModel foundItem = configRepo.currentResult!.firstWhere(
            (element) => element.date == formatTodayDate(),
          );

          List<Widget> menus = [
            CardCarousel(
              type: 'Breakfast',
              food: foundItem.breakfast,
              date: foundItem.date,
            ),
            CardCarousel(
              type: 'Lunch',
              food: foundItem.lunch,
              date: foundItem.date,
            ),
            CardCarousel(
              type: 'Dinner',
              food: foundItem.dinner,
              date: foundItem.date,
            )
          ];
          // List<String> currentType;
          // // Determine meal type based on the current hour
          // String currentMealType;
          // if (ref.watch(currentHourProvider).hour >= 0 &&
          //     ref.watch(currentHourProvider).hour < 10) {
          //   currentMealType = 'Breakfast';
          //   currentType = foundItem.breakfast;
          // } else if (ref.watch(currentHourProvider).hour >= 10 &&
          //     ref.watch(currentHourProvider).hour < 15) {
          //   currentMealType = 'Lunch';
          //   currentType = foundItem.lunch;
          // } else {
          //   currentMealType = 'Dinner';
          //   currentType = foundItem.dinner;
          // }

          // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          //   ref.watch(mealProvider.notifier).state = currentMealType;
          //   ref.watch(typeProvider.notifier).state = currentType;
          // });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0, 30, 0),
                child: Center(
                  child: Text(
                    'Upcoming Meal',
                    style: w400.size24.colorWhite,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0, 30, 0),
                child: Center(
                  child: Text(
                    'last updated: ${formatDateTime(ref.watch(currentHourProvider))}',
                    style: w400.size12
                        .copyWith(color: Colors.white.withOpacity(0.7)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0, 30, 0),
                child: Visibility(
                  visible: foundItem.grub,
                  child: const SizedBox(
                    height: 10,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0, 30, 0),
                child: Visibility(
                  visible: foundItem.grub,
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: Image.asset(
                        PngAssets.meme,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CarouselSlider(
                items: menus,
                options: CarouselOptions(
                  autoPlay: false,
                  // aspectRatio: 16 / 9,
                  // viewportFraction: 1.0,
                  // initialPage: 0,
                  //autoPlayInterval: const Duration(seconds: 3),
                  pauseAutoPlayOnTouch: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  enableInfiniteScroll: false,
                  scrollPhysics: BouncingScrollPhysics(),
                  initialPage: ref.watch(index),
                  viewportFraction: 0.8,
                ),
              ),
            ],
          );
        });
  }
}

class CardCarousel extends StatelessWidget {
  final List<String> food;
  final String type;
  final dynamic date;
  const CardCarousel(
      {super.key, required this.type, required this.food, this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.teal.withOpacity(0.5)),
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                type,
                style: w400.size20.colorWhite,
              ),
              Text(
                date,
                style: w400.size16.colorWhite,
              ),
            ],
          ),
          // const SizedBox(
          //   width: 30,
          // ),
          const SizedBox(
            height: 80,
            child: VerticalDivider(
              thickness: 1,
              width: 30, // Set the thickness of the divider
              color: Colors.teal, // Set the color of the divider
            ),
          ),

          Column(
            children: List<Widget>.from(food
                .toString()
                .replaceAll('[', '')
                .replaceAll(']', '')
                .split(',')
                .map((item) {
              return Expanded(
                child: Text(
                  item.trim().titleCase,
                  style: w400.size12.colorWhite,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            })),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
