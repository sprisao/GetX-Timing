import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timing/view/components/timing_appbar.dart';
import 'package:timing/viewmodel/timing_viewmodel.dart';

import 'add_schedule_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    super.initState();
    Provider.of<TimingViewModel>(context, listen: false).getMyScheduleList();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<TimingViewModel>(
      builder: (context, model, child) {
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
                ListView(
                  shrinkWrap: true,
                  children: model.myScheduleList
                      .map((e) => ListTile(
                            title: Text(e.startTime.toString()),
                            subtitle: Text(e.endTime.toString()),
                          ))
                      .toList(),
                ),
                FilledButton(
                    onPressed: () {}, child: Text('Show Friends list')),
                FilledButton(
                    onPressed: () {}, child: Text("Show Friend's Schedule")),
              ],
            ),
          ),
        );
      },
    );
  }
}
