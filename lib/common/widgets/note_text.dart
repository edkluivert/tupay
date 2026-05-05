import 'package:tupay/core/core.dart';

class NoteText extends StatelessWidget {
  const NoteText(
    this.text, {
    this.textAlign = TextAlign.left,
    this.color,
    super.key,
  });

  final String text;
  final TextAlign textAlign;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.inputFieldHints?.copyWith(
            color: color,
          ),
    );
  }
}
