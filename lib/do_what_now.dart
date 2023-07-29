

/// Support for a functional approach to error handling.
///
/// One can return an instance of a [DoWhat] from any method and return either an [What] or a value.
/// Values returned are defined by the Generic <T> parameter of the [DoWhat] object.
/// 
/// [DoWhat]s can also be created from any [Object] instance using the static [create] method.
/// [Null] objects will return an [What] result while valid objects will return a [DoWhat] containing the valid [Object] of <T> value.
/// 
/// Once a [DoWhat] is created a fluent API using extension methods can be leverage to handle the 'Do' (happy path) or 'What' (error path).
library;

export 'src/do_what.dart';
export 'src/do_state.dart';
export 'src/what.dart';
export 'src/why.dart';
export 'src/extensions.dart';

import 'src/what.dart';
import 'src/do_what.dart';

