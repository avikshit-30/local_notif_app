import 'package:flutter/material.dart';

import '../constants/textstyles.dart';

class Instructions extends StatelessWidget {
  const Instructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            '1) Clicking on this button would send notifs of the menu of that particular meal for 15 days(1 cycle).',
            style: w400.size12.colorWhite),
        const SizedBox(
          height: 5,
        ),
        Text(
            "2) After completion of cycle,you'll get a notif to come back and again schedule for the next 15 days.",
            style: w400.size12.colorWhite),
        const SizedBox(
          height: 5,
        ),
        Text(
            '3) The button would be unclickable during any gray period between 2 mess menus(if any).',
            style: w400.size12.colorWhite),
        const SizedBox(
          height: 5,
        ),
        Text(
            '4) If you missed the notif permission pop-up, pls go to settings and ensure notifications are not blocked.',
            style: w400.size12.colorWhite),
        const SizedBox(
          height: 5,
        ),
        Text(
            "5) We care for your privacy and so the app doesn't run in the background.",
            style: w400.size12.colorWhite),
        const SizedBox(
          height: 25,
        ),
        Text('Notif Timings:', style: w500.size16.colorWhite),
        Text(
            'Breakfast: 00:01 am\n(you can decide whether to wake up or not)\nLunch: 11:07 am\nDinner: 5:37 pm',
            style: w400.size12.colorWhite),
      ],
    );
  }
}
