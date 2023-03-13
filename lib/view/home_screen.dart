import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timing/view/components/timing_appbar.dart';

import 'add_schedule_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarWithLogo(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /*navigate to AddTimingScreen*/
          HapticFeedback.heavyImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddScheduleScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FilledButton(onPressed: () {}, child: Text('Show My schedule')),
            FilledButton(onPressed: () {}, child: Text('Show Friends list')),
            FilledButton(onPressed: () {}, child: Text("Show Friend's Schedule")),
          ],
        ),
      ),
    );
  }
}
