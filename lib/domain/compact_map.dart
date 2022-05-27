// https://github.com/vandadnp/flutter-tips-and-tricks/blob/main/source/flatmap-and-compactmap-in-dart.dart
extension CompactMap<T> on Iterable<T> {
  Iterable<E> compactMap<E>(E? Function(T element) f) {
    Iterable<E> imp(E? Function(T element) f) sync* {
      for (final value in this) {
        final mapped = f(value);
        if (mapped != null) {
          yield mapped;
        }
      }
    }

    return imp(f);
  }
}
