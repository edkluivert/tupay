import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:tupay/common/widgets/widget.dart';

class InputField extends StatefulWidget {
  const InputField({
    required this.hint,
    super.key,
    this.controller,
    this.enterPressed,
    this.fieldFocusNode,
    this.nextFocusNode,
    this.additionalNote,
    this.onChanged,
    this.inputFormatters,
    this.maxLines = 1,
    this.validationMessage,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.password = false,
    this.smallVersion = true,
    this.suffix,
    this.prefix,
    this.height,
    this.validationBorderColor,
    this.validationColor,
    this.validator,
    this.inputKey,
    this.readOnly = false,
    this.label,
    this.labelStyle,
    this.radius = 8,
    this.initialValue,
    this.fillColor = Colors.transparent,
    this.additionalNoteTextColor,
  });

  final TextEditingController? controller;
  final TextInputType textInputType;
  final bool password;
  final String hint;
  final String? validationMessage;
  final Function? enterPressed;
  final bool smallVersion;
  final FocusNode? fieldFocusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction textInputAction;
  final String? additionalNote;
  final String? initialValue;
  final Color fillColor;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final double? radius;
  final Widget? suffix;
  final Widget? prefix;
  final double? height;
  final Color? validationBorderColor;
  final Color? validationColor;
  final FormFieldValidator<String?>? validator;
  final Key? inputKey;
  final bool readOnly;
  final String? label;
  final TextStyle? labelStyle;
  final Color? additionalNoteTextColor;

  @override
  // ignore: library_private_types_in_public_api
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool isPasswordVisible;

  @override
  void initState() {
    super.initState();
    isPasswordVisible = !widget.password;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (widget.label != null && widget.label!.isNotEmpty) ...[
          AutoSizeText(
            widget.label ?? '',
            style: widget.labelStyle ?? textTheme.subHeading!.copyWith(
              fontSize: 16,
              color: AppColors.textColor,
            ),
          ),
          const Gap(8),
        ],

        TextFormField(
          key: widget.inputKey,
          validator: widget.validator,
          controller: widget.controller,
          keyboardType: widget.textInputType,
          focusNode: widget.fieldFocusNode,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          initialValue: widget.initialValue,
          style: textTheme.inputFieldValue!.copyWith(
            color: AppColors.textColor,
          ),
          readOnly: widget.readOnly,
          cursorColor: AppColors.secondaryColor,
          inputFormatters: widget.inputFormatters ?? [],
          onEditingComplete: () {
            if (widget.enterPressed != null) {
              FocusScope.of(context).requestFocus(FocusNode());
              // ignore: avoid_dynamic_calls
              widget.enterPressed?.call();
            }
          },
          obscureText: !isPasswordVisible && widget.password,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            isDense: true,

            floatingLabelBehavior: FloatingLabelBehavior.never,
            // label: Text(
            //   widget.placeholder,
            //   style: textTheme.bodySmall14Regular,
            // ),
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color: AppColors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            fillColor: widget.fillColor,
            filled: true,
            prefixIcon: Padding(
              padding:
                  widget.prefix == null ? const EdgeInsets.only(left: 8) : const EdgeInsets.symmetric(horizontal: 16),
              child: widget.prefix,
            ),
            prefixIconConstraints: const BoxConstraints(),
            suffixIconConstraints: const BoxConstraints(),
            suffixIcon: widget.password
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      }),
                      child: !isPasswordVisible
                          ? const Icon(
                              Icons.visibility_outlined,
                              size: 16,
                              color: AppColors.grey,
                            )
                          : const Icon(
                              Icons.visibility_off_outlined,
                              size: 16,
                              color: AppColors.grey,
                            ),
                    ),
                  )
                : widget.suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius!),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius!),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius!),
              borderSide: const BorderSide(
                color: AppColors.secondaryColor,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius!),
              borderSide: const BorderSide(color: AppColors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius!),
              borderSide: const BorderSide(
                color: AppColors.red,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
            ),
          ),
          onTapOutside: (event) {
            if (widget.fieldFocusNode != null) {
              widget.fieldFocusNode?.unfocus();
            } else {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
        ),

        if (widget.validationMessage != null)...[
          const Gap(10),
          NoteText(
            widget.validationMessage!,
            color: AppColors.lightGrey100,
          )
    ],

        if (widget.additionalNote != null)...[
          const Gap(5),
          NoteText(widget.additionalNote!,
            color: widget.additionalNoteTextColor??AppColors.inputBorder,
          )
        ] ,
      ],
    ).animate()
        .fadeIn(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .slideY(
      begin: 0.18,
      end: 0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }
}
