import 'package:flutter/material.dart';
import '../utils/app_colors/app_colors.dart'; // Import for color consistency

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String hint;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final String Function(T) itemDisplayBuilder; // Function to customize item display
  final Color backgroundColor;
  final Color borderColor;
  final Color hintColor;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hint,
    required this.itemDisplayBuilder,  // Custom item display function
    this.height = 56.0,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    this.backgroundColor = AppColors.whiteColor,  // Default background color
    this.borderColor = const Color.fromRGBO(208, 208, 208, 1), // Default border color
    this.hintColor = const Color.fromRGBO(150, 150, 150, 1), // Default hint color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width
      height: height, // Fixed height
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor), // Border color
        borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
      ),
      child: DropdownButton<T>(
        padding: padding,
        isExpanded: true,
        underline: const SizedBox.shrink(), // Remove the underline
        value: value,
        hint: Text(
          hint,
          style: TextStyle(color: hintColor), // Hint color for consistency
        ),
        style: const TextStyle(
          color: AppColors.blackColor, // Consistent text color for all fields
          fontSize: 16,
        ),
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(itemDisplayBuilder(item)), // Use the custom display builder
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
