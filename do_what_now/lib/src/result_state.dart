import 'error.dart';
import 'result.dart';

/// The resuting state of a [Result]
/// A result can only ever be pass or fail.
enum ResultState {

  /// The result was successful and current storing a Value of <T>.
  success,

  /// The result failed and stores an [Error] or multiple [Error]s.
  fail
}
