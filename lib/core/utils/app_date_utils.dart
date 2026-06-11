class AppDateUtils {
  static String formatShort(DateTime date) {
    final local = date.toLocal();
    return '${local.year}-${_two(local.month)}-${_two(local.day)}';
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}
