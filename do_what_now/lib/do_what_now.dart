

/// Support for a functional approach to error handling.
///
/// One can return an instance of a [Result] from any method and return either an [Error] or a value.
/// Values returned are defined by the Generic <T> parameter of the [Result] object.
/// 
/// [Result]s can also be created from any [Object] instance using the static [create] method.
/// [Null] objects will return an [Error] result while valid objects will return a [Result] containing the valid [Object] of <T> value.
/// 
/// Once a [Result] is created a fluent API using extension methods can be leverage to handle the 'Do' (happy path) or 'What' (error path).
library;

export 'src/result.dart';
export 'src/error.dart';

import 'src/error.dart';
import 'src/result.dart';

