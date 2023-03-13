import 'package:flutter/material.dart';

import '../../style/theme.dart';


class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const CustomFilterChip({
    Key? key,
    required this.label,
    required this.selected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      shadowColor: Colors.transparent,
      checkmarkColor: ColorTheme.primary,
      selectedColor: ColorTheme.primaryLight,
      backgroundColor: Colors.white,
      labelStyle: selected
          ? const TextStyle(fontSize: 13, color: Colors.black)
          : const TextStyle(fontSize: 13, color: Colors.black),
      side: selected
          ? const BorderSide(
              color: ColorTheme.primary,
              width: 0.5,
            )
          : const BorderSide(
              color: ColorTheme.inactiveIcon,
              width: 0.5,
            ),
      padding: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
    );
  }
}

class CustomFilterChipWithoutChecker extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const CustomFilterChipWithoutChecker({
    Key? key,
    required this.label,
    required this.selected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      showCheckmark: false,
      shadowColor: Colors.transparent,
      checkmarkColor: Colors.white,
      selectedColor: ColorTheme.primaryLight,
      backgroundColor: Colors.white,
      labelStyle: selected
          ? const TextStyle(fontSize: 15, color: Colors.black)
          : const TextStyle(fontSize: 15, color: Colors.black),
      side: selected
          ? const BorderSide(
              color: ColorTheme.primary,
              width: 0.5,
            )
          : const BorderSide(
              color: ColorTheme.inactiveIcon,
              width: 0.5,
            ),
      padding: const EdgeInsets.only(left: 5, right: 5, top: 4, bottom: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
    );
  }
}
