import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timing/view/components/timing_appbar.dart';
import 'package:timing/viewmodel/timing_viewmodel.dart';

import 'add_schedule/add_bottom_sheet.dart';

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
              HapticFeedback.heavyImpact();
              _showMultiScreenBottomSheet(context);
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
                      .map((e) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /*date in korean format*/
                              Text(DateFormat('d일 E요일', 'ko').format(e.date)),
                              Column(
                                children: [
                                  Text(DateFormat('hh:mm a')
                                      .format(e.startTime.toLocal())),
                                  Text(DateFormat('hh:mm a')
                                      .format(e.endTime.toLocal())),
                                ],
                              )
                              /*time in korea time zone*/
                            ],
                          )))
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _showMultiScreenBottomSheet(BuildContext context) {
  showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.black,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return const MultiScreenBottomSheet();
      });
}

