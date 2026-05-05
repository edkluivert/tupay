import 'package:tupay/features/features.dart';

class SpendingTrendChart extends StatelessWidget {
  const SpendingTrendChart({
    required this.values,
    this.barColors,
    this.height = 120,
    super.key,
  });

  final List<double> values;

  /// Optional custom color per bar.
  /// If null at an index, the chart auto calculates the color.
  ///
  /// barColors: [
  ///   null,
  ///   AppColors.secondaryColor,
  ///   null,
  ///   null,
  ///   AppColors.greenText1,
  ///   null,
  ///   null,
  /// ]
  final List<Color?>? barColors;

  final double height;

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    assert(
    values.length == 7,
    'SpendingTrendChart requires exactly 7 values (Mon–Sun)',
    );

    assert(
    barColors == null || barColors!.length == values.length,
    'barColors must be null or have the same length as values',
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          child: CustomPaint(
            size: Size.infinite,
            painter: _BarChartPainter(
              values: values,
              barColors: barColors,
            ),
          ),
        ),
        context.uiHelper.verticalSpace(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _days
              .map(
                (day) => Text(
              day,
              style: context.appTextTheme.bodySmall14Regular?.copyWith(
                color: AppColors.grey200,
                fontSize: 16,
              ),
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}

class _BarChartPainter extends CustomPainter {
  const _BarChartPainter({
    required this.values,
    this.barColors,
  });

  final List<double> values;
  final List<Color?>? barColors;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final maxValue = values.reduce((a, b) => a > b ? a : b);

    final rankedIndexes = List<int>.generate(values.length, (index) => index)
      ..sort((a, b) => values[b].compareTo(values[a]));

    const barGap = 6.0;
    final barWidth = (size.width - barGap * (values.length - 1)) / values.length;

    final ghostPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;

    const radius = Radius.circular(4);

    for (var i = 0; i < values.length; i++) {
      final x = i * (barWidth + barGap);
      final normalised = maxValue == 0 ? 0.0 : values[i] / maxValue;
      final barHeight = normalised * size.height;
      final top = size.height - barHeight;

      final barColor = _resolveBarColor(
        index: i,
        rankedIndexes: rankedIndexes,
      );

      final barPaint = Paint()
        ..color = barColor
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromLTRBR(
          x,
          0,
          x + barWidth,
          size.height,
          radius,
        ),
        ghostPaint,
      );

      if (barHeight > 0) {
        canvas.drawRRect(
          RRect.fromLTRBR(
            x,
            top,
            x + barWidth,
            size.height,
            radius,
          ),
          barPaint,
        );
      }
    }
  }

  Color _resolveBarColor({
    required int index,
    required List<int> rankedIndexes,
  }) {
    final customColor = barColors?[index];

    if (customColor != null) {
      return customColor;
    }

    final rank = rankedIndexes.indexOf(index);

    if (rank == 0) {
      return AppColors.blackv2;
    }

    if (rank == 1 || rank == 2) {
      return AppColors.greenText1;
    }

    return AppColors.grey50;
  }

  @override
  bool shouldRepaint(_BarChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.barColors != barColors;
  }
}