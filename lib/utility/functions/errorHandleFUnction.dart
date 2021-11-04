// var f = (String s) => s;
// print(f("hi"));
// ErrorHandle.setTimeOut<void>(f);
import 'dart:async';

class ErrorHandle {
  static Future<T?> setTimeOut<T>(Future<T> Function() function) async {
    try {
      return await function().timeout(const Duration(seconds: 4));
    } on TimeoutException catch (e) {
      return null;
    } on Error catch (e) {
      print('Error: $e');
    }
  }
}
