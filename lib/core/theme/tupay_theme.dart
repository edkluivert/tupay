import 'package:tupay/core/core.dart';

class TupayTheme {
  static ThemeData createLightThemeData() {
    final theme = ThemeData.light();

    final textTheme = theme.textTheme.copyWith(
      displayLarge: theme.textTheme.displayLarge?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textColor,
        fontFamily: Fonts.publicSans,
      ),
      displayMedium: theme.textTheme.displayMedium?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textColor,
        fontFamily: Fonts.publicSans,
      ),
      displaySmall: theme.textTheme.displaySmall?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textColor,
        fontFamily: Fonts.publicSans,
      ),
      headlineMedium: theme.textTheme.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textColor,
        fontFamily: Fonts.publicSans,
      ),
      headlineSmall: theme.textTheme.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textColor,
        fontFamily: Fonts.publicSans,
      ),
      titleLarge: theme.textTheme.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textColor,
        fontFamily: Fonts.publicSans,
      ),
      labelLarge: theme.textTheme.labelLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textColor,
        fontFamily: Fonts.publicSans,
      ),
    );

    return ThemeData(
      fontFamily: Fonts.publicSans,
      canvasColor: Colors.transparent,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        titleTextStyle: textTheme.displaySmall,
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: AppColors.black,
        ),
        toolbarTextStyle: textTheme.bodyNormal16Regular?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      primaryIconTheme: theme.iconTheme.copyWith(
        color: AppColors.primaryColor,
      ),
      bottomSheetTheme: theme.bottomSheetTheme.copyWith(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        backgroundColor: AppColors.primaryColor.withValues(alpha: 0.4),
        modalBackgroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: theme.bottomNavigationBarTheme.copyWith(
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.textColor,
        selectedLabelStyle: textTheme.bodySmall14Bold?.copyWith(
          color: AppColors.primaryColor,
        ),
        unselectedLabelStyle: textTheme.bodySmall14Bold?.copyWith(
          color: AppColors.textColor,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: textTheme.labelLarge,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primaryColor;
            }
            return const Color(0xFFFAFBFF);
          },
        ),
        checkColor: WidgetStateProperty.all(
          const Color(0xFFFFFFFF),
        ),
        side: WidgetStateBorderSide.resolveWith(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const BorderSide(
                color: AppColors.primaryColor,
                width: 2,
              );
            }
            return const BorderSide(
              color: AppColors.greyDark,
            );
          },
        ),
        visualDensity: VisualDensity.compact,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: outlineInputBorder(),
        enabledBorder: outlineInputBorder(),
        focusedBorder: outlineInputBorder(),
        disabledBorder: outlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        hintStyle: textTheme.inputFieldValue?.copyWith(
          color: AppColors.textColor,
        ),
      ),
      colorScheme: theme.colorScheme.copyWith(
        primary: AppColors.secondaryColor,
        surface: AppColors.backgroundColor,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.secondaryColor,
        selectionColor: AppColors.secondaryColor.withValues(alpha: 0.25),
        selectionHandleColor: AppColors.secondaryColor,
      ),
    );
  }

  static OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColors.inputBorder,
      ),
    );
  }
}