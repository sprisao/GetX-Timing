import 'package:flutter/material.dart';

class AddTimingSection extends StatefulWidget {
  final String title;
  final String? subTitle;
  final Widget content;

  const AddTimingSection({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.content,
  }) : super(key: key);

  @override
  State<AddTimingSection> createState() => _AddTimingSectionState();
}

class _AddTimingSectionState extends State<AddTimingSection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                if (widget.subTitle != null)
                  Text(
                    widget.subTitle!,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.normal),
                  )
              ],
            ),
          ),
          widget.content,
        ],
      ),
    );
  }
}
