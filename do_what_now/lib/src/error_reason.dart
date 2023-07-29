import 'result.dart';
import 'error.dart';

/// Describes the type of error stored in the instance of the [Error] class.
enum ErrorReason { 

  /// The [Error] was the result of a null object [Result] or an empty result.
  empty, 

  /// The error is simply a meaningfull message.
  message,
  
  /// The [Error] stores an object, possible caught by a custom [Exception].
  object, 

  /// The [Error] was the result of an [Exception] retured from a [Result].
  exception, 
}