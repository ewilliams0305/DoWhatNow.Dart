import 'do_what.dart';
import 'what.dart';

/// Describes the type of error stored in the instance of the [What] class.
enum Why {
  /// The [What] was the result of a null object [DoWhat] or an empty result.
  empty,

  /// The error is simply a meaningfull message.
  message,

  /// The [What] stores an object, possible caught by a custom [Exception].
  object,

  /// The [What] was the result of an [Exception] retured from a [DoWhat].
  exception,
}
