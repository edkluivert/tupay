import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tupay/core/constants/app_strings.dart';
import 'package:tupay/core/constants/app_colors.dart';
import 'package:tupay/core/theme/text_theme_extension.dart';

class DropItem {
  DropItem({required this.text, required this.value});
  final String text;
  final String value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DropItem) return false;
    return text == other.text && value == other.value;
  }

  @override
  int get hashCode => text.hashCode ^ value.hashCode;
}

typedef DropdownButtonBuilder = List<Widget> Function(BuildContext context);

class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown({
    required this.menuItems,
    super.key,
    this.value,
    this.onChanged,
    this.labelText = '',
    this.hintText = '',
    this.validator,
    this.validationMessage,
    this.selectedTextBuilder,
    this.fillColor = AppColors.white,
    this.borderColor = AppColors.inputBorder,
  });

  final String labelText;
  final String hintText;
  final List<DropdownMenuItem<T>> menuItems;
  final ValueChanged<T?>? onChanged;
  final T? value;
  final FormFieldValidator<T?>? validator;
  final String? validationMessage;
  final Color fillColor;
  final Color borderColor;
  final String Function(T value)? selectedTextBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: labelText.isNotEmpty,
          child: Text(
            labelText,
            style: theme.bodyNormal16Bold,
          ),
        ),
        Visibility(
          visible: labelText.isNotEmpty,
          child: const Gap(8),
        ),
        DropdownButtonFormField<T>(
          items: menuItems,
          initialValue: value,
          onChanged: onChanged,
          dropdownColor: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          elevation: 1,
          style: theme.labelMedium?.copyWith(
            fontWeight: FontWeight.w300,
            color: AppColors.textColor,
            letterSpacing: 0.5,
            height: 24 / 16,
          ),
          isExpanded: true,
          hint: Text(
            hintText.isNotEmpty ? hintText : 'Select',
            style: const TextStyle(
              color: Color(0xFF8B98B1),
              fontWeight: FontWeight.w400,
              fontSize: 16,
              letterSpacing: 0.5,
              height: 24 / 16,
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          selectedItemBuilder: (BuildContext context) {
            return menuItems.map((item) {
              final itemValue = item.value;

              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  itemValue == null
                      ? ''
                      : selectedTextBuilder?.call(itemValue) ??
                      itemValue.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            isDense: true,
            hintStyle: theme.labelSmall?.copyWith(
              fontWeight: FontWeight.w300,
              letterSpacing: 0.5,
              height: 24 / 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:  BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:  const BorderSide(
                color: AppColors.secondaryColor,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.red,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 13,
              horizontal: 10,
            ),
            errorText: validationMessage,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
