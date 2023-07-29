import 'what.dart';
import 'do_what.dart';

/// The resuting state of a [DoWhat]
/// A result can only ever be pass or fail.
enum DoState {

  /// The result was successful and current storing a Value of <T>.
  success,

  /// The result failed and stores a [What] or multiple [What]s.
  fail
}
