

import 'package:tupay/core/core.dart';
import 'package:tupay/core/logger/app_logger.dart';


extension IterableFirstWhereOrNull<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension ExFuture<T> on Future<T> {
  Future<T> trackTime(String label) async {
    final start = DateTime.now();
    final result = await this;
    final end = DateTime.now();
    final duration = end.difference(start);
    AppLogger.d('$label completed in ${duration.inMilliseconds} ms');
    return result;
  }
} // for example await fetchData().trackTime('Fetch Data');

extension ExIndexedMap<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E element) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }
}  // for example anyList.mapIndexed((i, item) => Text('$i: $item'))


extension ExScreenMetrics on BuildContext {
  MediaQueryData get mq => MediaQuery.of(this);
  double get mWidth => mq.size.width;
  double get mHeight => mq.size.height;
}

extension Extheme on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get appTextTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  UiHelper get uiHelper => UiHelper(this);

}