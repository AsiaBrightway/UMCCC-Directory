import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final Map<T, String> items;
  final ValueChanged<T?> onChanged;
  final double buttonHeight;
  final double buttonElevation;
  final EdgeInsets buttonPadding;
  final BoxDecoration buttonDecoration;

  const CustomDropdownButton({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.buttonHeight = 44.0,
    this.buttonElevation = 4.0,
    this.buttonPadding = const EdgeInsets.symmetric(horizontal: 10),
    this.buttonDecoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      border: Border.fromBorderSide(BorderSide(color: Colors.black26)),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        value: value,
        hint: Text(
          hint,
          style: const TextStyle(fontSize: 14),
        ),
        items: items.entries.map((entry) {
          return DropdownMenuItem<T>(
            value: entry.key,
            child: Text(
              entry.value,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          elevation: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black26,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 44,
        ),
      ),
    );
  }
}
