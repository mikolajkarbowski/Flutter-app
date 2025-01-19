import 'dart:async';
import 'dart:ui';

Future<void> delayAction(
    {int milliseconds = 500, required VoidCallback action}) async {
  await Future.delayed(Duration(milliseconds: milliseconds));
  action();
}
